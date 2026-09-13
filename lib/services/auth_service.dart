import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../core/errors/app_exception.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthService implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthService({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _usersCollection =>
      _firestore.collection(AppConstants.colUsers);

  static const String _userSessionKey = 'cached_user_session';

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_userSessionKey);
        return null;
      }
      
      // Fast path: Try returning cached session first to unblock UI
      UserModel? cachedUser;
      try {
        final prefs = await SharedPreferences.getInstance();
        final cachedData = prefs.getString(_userSessionKey);
        if (cachedData != null) {
          final map = jsonDecode(cachedData) as Map<String, dynamic>;
          cachedUser = UserModel.fromMap(map['id'] ?? user.uid, map);
        }
      } catch (_) {}

      // Background update from Firestore
      try {
        final doc = await _usersCollection.doc(user.uid).get();
        if (doc.exists) {
          final updatedUser = UserModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
          _cacheUserLocally(updatedUser);
          return updatedUser;
        } else {
          // Create user doc if not present
          final newUser = UserModel(
            id: user.uid,
            name: user.displayName ?? user.email?.split('@').first ?? 'User',
            email: user.email ?? '',
            photoUrl: user.photoURL,
            createdAt: DateTime.now(),
          );
          await _usersCollection.doc(user.uid).set(newUser.toMap());
          _cacheUserLocally(newUser);
          return newUser;
        }
      } catch (e) {
        // If Firestore fails, return cached user or basic auth user
        return cachedUser ?? UserModel(
          id: user.uid,
          name: user.displayName ?? 'User',
          email: user.email ?? '',
          createdAt: DateTime.now(),
        );
      }
    });
  }

  Future<void> _cacheUserLocally(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final map = user.toMap();
      map['id'] = user.id;
      // Convert Timestamp to string for JSON serialization
      map['createdAt'] = user.createdAt.toIso8601String();
      await prefs.setString(_userSessionKey, jsonEncode(map));
    } catch (_) {}
  }

  @override
  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _usersCollection.doc(user.uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
      return UserModel(
        id: user.uid,
        name: user.displayName ?? 'User',
        email: user.email ?? '',
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw AppException.fromFirebase(e);
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = cred.user!;
      final doc = await _usersCollection.doc(user.uid).get();
      if (doc.exists) {
        final existingUser = UserModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
        _cacheUserLocally(existingUser);
        return existingUser;
      }

      final userModel = UserModel(
        id: user.uid,
        name: user.displayName ?? email.split('@').first,
        email: user.email ?? email,
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
      );
      await _usersCollection.doc(user.uid).set(userModel.toMap());
      _cacheUserLocally(userModel);
      return userModel;
    } catch (e) {
      throw AppException.fromFirebase(e);
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = cred.user!;
      await user.updateDisplayName(name.trim());

      final userModel = UserModel(
        id: user.uid,
        name: name.trim(),
        email: email.trim(),
        photoUrl: null,
        createdAt: DateTime.now(),
      );

      await _usersCollection.doc(user.uid).set(userModel.toMap());
      _cacheUserLocally(userModel);
      return userModel;
    } catch (e) {
      throw AppException.fromFirebase(e);
    }
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      throw AppException.fromFirebase(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userSessionKey);
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AppException.fromFirebase(e);
    }
  }

  @override
  Future<void> updateProfile({
    required String name,
    String? photoUrl,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw AppException('User is not logged in.');

      await user.updateDisplayName(name.trim());
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      final updateData = <String, dynamic>{
        'name': name.trim(),
      };
      if (photoUrl != null) {
        updateData['photoUrl'] = photoUrl;
      }
      await _usersCollection.doc(user.uid).update(updateData);
    } catch (e) {
      throw AppException.fromFirebase(e);
    }
  }

  @override
  Future<UserModel?> getUserById(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw AppException.fromFirebase(e);
    }
  }
}
