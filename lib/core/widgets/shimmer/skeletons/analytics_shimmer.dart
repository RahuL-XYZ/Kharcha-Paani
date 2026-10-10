import 'package:flutter/material.dart';
import '../app_shimmer.dart';
import '../shimmer_placeholders.dart';

/// Skeleton for Monthly Analytics Screen
class MonthlyAnalyticsShimmer extends StatelessWidget {
  const MonthlyAnalyticsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Selector Bar Skeleton
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerBox(width: 40, height: 40),
                ShimmerLine(width: 140, height: 18),
                ShimmerBox(width: 40, height: 40),
              ],
            ),
            const SizedBox(height: 20),

            // Summary Card (Total Monthly Spend)
            const ShimmerCard(
              height: 110,
              borderRadius: 20,
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShimmerLine(width: 120, height: 12),
                  SizedBox(height: 10),
                  ShimmerLine(width: 180, height: 28),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Chart Container Placeholder
            const ShimmerCard(
              height: 220,
              borderRadius: 24,
            ),
            const SizedBox(height: 24),

            // Category Spending Breakdown Title
            const ShimmerLine(width: 160, height: 18),
            const SizedBox(height: 14),

            // Category Breakdown Items
            const CategoryBreakdownItemSkeleton(),
            const SizedBox(height: 10),
            const CategoryBreakdownItemSkeleton(),
            const SizedBox(height: 10),
            const CategoryBreakdownItemSkeleton(),
          ],
        ),
      ),
    );
  }
}

class CategoryBreakdownItemSkeleton extends StatelessWidget {
  const CategoryBreakdownItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerCard(
      height: 64,
      borderRadius: 16,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          ShimmerCircle(size: 36),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShimmerLine(width: 100, height: 12),
                SizedBox(height: 6),
                ShimmerLine(width: 140, height: 8),
              ],
            ),
          ),
          SizedBox(width: 12),
          ShimmerLine(width: 50, height: 14),
        ],
      ),
    );
  }
}
