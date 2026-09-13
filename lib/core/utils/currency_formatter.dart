import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _indianFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static final NumberFormat _indianFormatterNoDecimals = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  /// Converts a double rupees amount to integer paise (e.g. 100.50 -> 10050)
  static int toPaise(double rupees) {
    return (rupees * 100).round();
  }

  /// Converts integer paise to double rupees (e.g. 10050 -> 100.50)
  static double fromPaise(int paise) {
    return paise / 100.0;
  }

  /// Formats double rupees to Indian Rupee string (e.g. ₹12,450 or ₹12,450.50)
  static String formatRupees(double amount, {bool showDecimals = false}) {
    if (showDecimals || (amount % 1 != 0)) {
      return _indianFormatter.format(amount);
    }
    return _indianFormatterNoDecimals.format(amount);
  }

  /// Formats integer paise to Indian Rupee string (e.g. 1245000 -> ₹12,450)
  static String formatPaise(int paise, {bool showDecimals = false}) {
    final double rupees = fromPaise(paise);
    return formatRupees(rupees, showDecimals: showDecimals);
  }

  /// Formats integer paise without currency symbol (e.g. 1245000 -> 12,450)
  static String formatRaw(double amount) {
    final NumberFormat format = NumberFormat('#,##,##0.##', 'en_IN');
    return format.format(amount);
  }

  /// Formats integer paise into a compact format (e.g. 1.2L, 50K) for small screens
  static String formatCompact(int paise) {
    final double rupees = fromPaise(paise);
    if (rupees.abs() >= 10000000) {
      return '₹${(rupees / 10000000).toStringAsFixed(1)} Cr';
    } else if (rupees.abs() >= 100000) {
      return '₹${(rupees / 100000).toStringAsFixed(1)} L';
    } else if (rupees.abs() >= 1000) {
      return '₹${(rupees / 1000).toStringAsFixed(1)} k';
    }
    return formatRupees(rupees);
  }
}
