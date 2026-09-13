import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user_model.dart';
import '../../../repositories/auth_repository.dart';
import '../../../services/auth_service.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthService();
});

final authStateChangesProvider = StreamProvider<UserModel?>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.authStateChanges;
});

final currentUserProvider = Provider<UserModel?>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.asData?.value;
});

final currentUserIdProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.id;
});

class AuthState {
  final bool isLoading;
  final String? errorMessage;

  const AuthState({this.isLoading = false, this.errorMessage});
}

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(const AuthState());

  Future<bool> login({required String email, required String password}) async {
    state = const AuthState(isLoading: true);
    try {
      await _authRepository.login(email: email, password: password);
      state = const AuthState(isLoading: false);
      return true;
    } catch (e) {
      state = AuthState(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AuthState(isLoading: true);
    try {
      await _authRepository.register(name: name, email: email, password: password);
      state = const AuthState(isLoading: false);
      return true;
    } catch (e) {
      state = AuthState(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> sendPasswordReset({required String email}) async {
    state = const AuthState(isLoading: true);
    try {
      await _authRepository.sendPasswordReset(email: email);
      state = const AuthState(isLoading: false);
      return true;
    } catch (e) {
      state = AuthState(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    state = const AuthState(isLoading: true);
    try {
      await _authRepository.logout();
    } finally {
      state = const AuthState(isLoading: false);
    }
  }

  Future<bool> updateProfile({required String name, String? photoUrl}) async {
    state = const AuthState(isLoading: true);
    try {
      await _authRepository.updateProfile(name: name, photoUrl: photoUrl);
      state = const AuthState(isLoading: false);
      return true;
    } catch (e) {
      state = AuthState(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  void clearError() {
    state = const AuthState(isLoading: false);
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return AuthController(authRepo);
});
