import '../models/user_model.dart';

abstract class AuthRepository {
  Stream<UserModel?> get authStateChanges;
  String? get currentUserId;
  Future<UserModel?> getCurrentUser();
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });
  Future<void> sendPasswordReset({required String email});
  Future<void> logout();
  Future<void> updateProfile({required String name, String? photoUrl});
  Future<UserModel?> getUserById(String uid);
}
