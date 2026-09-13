import 'dart:math';

class InviteCodeGenerator {
  // Omit confusing characters like '0', 'O', '1', 'I'
  static const String _chars = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
  static final Random _rnd = Random.secure();

  /// Generates a clean 6-character uppercase alphanumeric invite code
  static String generate([int length = 6]) {
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
      ),
    );
  }

  /// Sanitizes and validates invite code input
  static String sanitize(String input) {
    return input.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
  }

  static bool isValid(String code) {
    final sanitized = sanitize(code);
    return sanitized.length == 6;
  }
}
