import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_constants.dart';
import '../core/errors/app_exception.dart';
import '../core/utils/invite_code_generator.dart';
import '../models/household_model.dart';
import '../models/household_member_model.dart';
import '../repositories/household_repository.dart';

class HouseholdService implements HouseholdRepository {
  final FirebaseFirestore _firestore;

  HouseholdService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _householdsCol =>
      _firestore.collection(AppConstants.colHouseholds);

  @override
  Stream<List<HouseholdModel>> streamUserHouseholds(String userId) {
    return _householdsCol
        .where('memberIds', arrayContains: userId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              HouseholdModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<HouseholdModel?> getHouseholdById(String householdId) async {
    try {
      final doc = await _householdsCol.doc(householdId).get();
      if (!doc.exists) return null;
      return HouseholdModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw AppException.fromFirebase(e);
    }
  }

  @override
  Stream<HouseholdModel?> streamHouseholdById(String householdId) {
    return _householdsCol.doc(householdId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return HouseholdModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    });
  }

  /// Generates a unique 6-character uppercase alphanumeric invite code
  Future<String> _generateUniqueInviteCode() async {
    for (int attempts = 0; attempts < 10; attempts++) {
      final code = InviteCodeGenerator.generate();
      final query = await _householdsCol
          .where('inviteCode', isEqualTo: code)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return code;
      }
    }
    // Fallback if multiple collisions (extremely unlikely with 32^6 combinations)
    return InviteCodeGenerator.generate();
  }

  @override
  Future<HouseholdModel> createHousehold({
    required String name,
    required String userId,
    required String userName,
    String? userEmail,
    String category = 'home',
    String? icon,
  }) async {
    try {
      if (name.trim().isEmpty) {
        throw AppException('Household name cannot be empty.');
      }

      final inviteCode = await _generateUniqueInviteCode();
      final householdDocRef = _householdsCol.doc();
      final now = DateTime.now();

      final household = HouseholdModel(
        id: householdDocRef.id,
        name: name.trim(),
        inviteCode: inviteCode,
        createdBy: userId,
        createdAt: now,
        isActive: true,
        memberCount: 1,
        category: category,
        icon: icon,
      );

      final member = HouseholdMemberModel(
        id: userId,
        name: userName.trim().isNotEmpty ? userName.trim() : 'Roommate',
        role: AppConstants.roleOwner,
        joinedAt: now,
        email: userEmail,
      );

      final batch = _firestore.batch();

      // 1. Create household doc
      final householdData = household.toMap();
      householdData['memberIds'] = [userId];
      batch.set(householdDocRef, householdData);

      // 2. Create member subcollection doc
      final memberDocRef = householdDocRef
          .collection(AppConstants.colMembers)
          .doc(userId);
      batch.set(memberDocRef, member.toMap());

      await batch.commit();
      return household;
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException.fromFirebase(e);
    }
  }

  @override
  Future<HouseholdModel> joinHouseholdByCode({
    required String inviteCode,
    required String userId,
    required String userName,
    String? userEmail,
  }) async {
    try {
      final sanitizedCode = InviteCodeGenerator.sanitize(inviteCode);
      if (sanitizedCode.length != 6) {
        throw AppException('Please enter a valid 6-character invite code.');
      }

      final query = await _householdsCol
          .where('inviteCode', isEqualTo: sanitizedCode)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw AppException('Invalid invite code. Household not found.');
      }

      final householdDoc = query.docs.first;
      final householdData = householdDoc.data() as Map<String, dynamic>;
      final householdId = householdDoc.id;

      final memberIds = List<String>.from(householdData['memberIds'] ?? []);
      if (memberIds.contains(userId)) {
        throw AppException('You are already a member of this household.');
      }

      final now = DateTime.now();
      final member = HouseholdMemberModel(
        id: userId,
        name: userName.trim().isNotEmpty ? userName.trim() : 'Roommate',
        role: AppConstants.roleMember,
        joinedAt: now,
        email: userEmail,
      );

      final batch = _firestore.batch();

      // 1. Add to members subcollection
      final memberDocRef = householdDoc.reference
          .collection(AppConstants.colMembers)
          .doc(userId);
      batch.set(memberDocRef, member.toMap());

      // 2. Update memberIds list & count
      batch.update(householdDoc.reference, {
        'memberIds': FieldValue.arrayUnion([userId]),
        'memberCount': FieldValue.increment(1),
      });

      await batch.commit();

      return HouseholdModel.fromMap(householdId, {
        ...householdData,
        'memberCount': (householdData['memberCount'] ?? 1) + 1,
      });
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException.fromFirebase(e);
    }
  }

  @override
  Stream<List<HouseholdMemberModel>> streamHouseholdMembers(String householdId) {
    return _householdsCol
        .doc(householdId)
        .collection(AppConstants.colMembers)
        .orderBy('joinedAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => HouseholdMemberModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  @override
  Future<List<HouseholdMemberModel>> getHouseholdMembers(String householdId) async {
    try {
      final snapshot = await _householdsCol
          .doc(householdId)
          .collection(AppConstants.colMembers)
          .get();

      return snapshot.docs
          .map((doc) => HouseholdMemberModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw AppException.fromFirebase(e);
    }
  }

  @override
  Future<void> removeMember({
    required String householdId,
    required String memberId,
  }) async {
    try {
      final householdRef = _householdsCol.doc(householdId);
      final memberRef = householdRef.collection(AppConstants.colMembers).doc(memberId);

      final batch = _firestore.batch();
      batch.delete(memberRef);
      batch.update(householdRef, {
        'memberIds': FieldValue.arrayRemove([memberId]),
        'memberCount': FieldValue.increment(-1),
      });

      await batch.commit();
    } catch (e) {
      throw AppException.fromFirebase(e);
    }
  }

  @override
  Future<void> leaveHousehold({
    required String householdId,
    required String userId,
  }) async {
    try {
      final householdRef = _householdsCol.doc(householdId);
      final memberRef = householdRef.collection(AppConstants.colMembers).doc(userId);

      final batch = _firestore.batch();
      batch.delete(memberRef);
      batch.update(householdRef, {
        'memberIds': FieldValue.arrayRemove([userId]),
        'memberCount': FieldValue.increment(-1),
      });

      await batch.commit();
    } catch (e) {
      throw AppException.fromFirebase(e);
    }
  }

  @override
  Future<void> deleteHousehold({
    required String householdId,
    required String userId,
  }) async {
    try {
      final householdRef = _householdsCol.doc(householdId);
      final doc = await householdRef.get();
      if (!doc.exists) {
        throw AppException('Household not found.');
      }
      final data = doc.data() as Map<String, dynamic>;
      if (data['createdBy'] != userId) {
        throw AppException('Only the creator can delete this group.');
      }

      // Mark inactive rather than hard-deleting to preserve audit history
      await householdRef.update({'isActive': false});
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException.fromFirebase(e);
    }
  }
}
