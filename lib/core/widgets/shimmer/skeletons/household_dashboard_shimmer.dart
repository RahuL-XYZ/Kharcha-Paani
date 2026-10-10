import 'package:flutter/material.dart';
import '../app_shimmer.dart';
import '../shimmer_placeholders.dart';

class HouseholdDashboardShimmer extends StatelessWidget {
  const HouseholdDashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group Header Card Skeleton
            const ShimmerCard(
              height: 210,
              borderRadius: 24,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerLine(width: 140, height: 14),
                      ShimmerCircle(size: 32),
                    ],
                  ),
                  ShimmerLine(width: 180, height: 32),
                  ShimmerLine(width: 120, height: 14),
                  Row(
                    children: [
                      Expanded(child: ShimmerBox(height: 44)),
                      SizedBox(width: 12),
                      Expanded(child: ShimmerBox(height: 44)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tab bar chips skeleton
            Row(
              children: [
                const ShimmerBox(width: 90, height: 36),
                const SizedBox(width: 8),
                const ShimmerBox(width: 100, height: 36),
                const SizedBox(width: 8),
                const ShimmerBox(width: 80, height: 36),
              ],
            ),
            const SizedBox(height: 20),

            // Recent Expenses Section title
            const ShimmerLine(width: 130, height: 18),
            const SizedBox(height: 12),

            // Expense Tiles
            const ExpenseTileSkeleton(),
            const SizedBox(height: 10),
            const ExpenseTileSkeleton(),
            const SizedBox(height: 10),
            const ExpenseTileSkeleton(),
            const SizedBox(height: 10),
            const ExpenseTileSkeleton(),
          ],
        ),
      ),
    );
  }
}

/// A reusable individual Expense Tile skeleton item
class ExpenseTileSkeleton extends StatelessWidget {
  const ExpenseTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerCard(
      height: 76,
      borderRadius: 16,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          ShimmerCircle(size: 44),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShimmerLine(width: 120, height: 14),
                SizedBox(height: 6),
                ShimmerLine(width: 80, height: 10),
              ],
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShimmerLine(width: 60, height: 14),
              SizedBox(height: 6),
              ShimmerLine(width: 40, height: 10),
            ],
          ),
        ],
      ),
    );
  }
}
