class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException(this.message, {this.code, this.details});

  @override
  String toString() => message;

  factory AppException.fromFirebase(dynamic error) {
    final String errorStr = error.toString().toLowerCase();
    
    if (errorStr.contains('user-not-found')) {
      return AppException('No account found with this email address.', code: 'user-not-found');
    } else if (errorStr.contains('wrong-password') || errorStr.contains('invalid-credential')) {
      return AppException('Incorrect password. Please try again.', code: 'wrong-password');
    } else if (errorStr.contains('email-already-in-use')) {
      return AppException('An account already exists with this email address.', code: 'email-already-in-use');
    } else if (errorStr.contains('invalid-email')) {
      return AppException('Please enter a valid email address.', code: 'invalid-email');
    } else if (errorStr.contains('weak-password')) {
      return AppException('Password is too weak. Please use at least 6 characters.', code: 'weak-password');
    } else if (errorStr.contains('network-request-failed') || errorStr.contains('unavailable')) {
      return AppException('Network error. Please check your internet connection.', code: 'network-error');
    } else if (errorStr.contains('permission-denied')) {
      return AppException('You do not have permission to perform this action.', code: 'permission-denied');
    } else if (errorStr.contains('not-found')) {
      return AppException('Requested item was not found.', code: 'not-found');
    }

    return AppException('An unexpected error occurred. Please try again.', details: error);
  }
}
