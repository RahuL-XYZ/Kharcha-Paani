import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A theme-aware shimmer container that adapts base and highlight colors
/// according to the current theme brightness (Light vs Dark mode).
class AppShimmer extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const AppShimmer({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark
        ? const Color(0xFF1E293B) // Dark Slate 800
        : const Color(0xFFE2E8F0); // Light Slate 200

    final highlightColor = isDark
        ? const Color(0xFF334155) // Dark Slate 700
        : const Color(0xFFF8FAFC); // Light Slate 50

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: const Duration(milliseconds: 1500),
      child: child,
    );
  }
}
