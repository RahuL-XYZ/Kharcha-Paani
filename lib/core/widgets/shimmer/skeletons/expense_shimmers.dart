import 'package:flutter/material.dart';
import '../app_shimmer.dart';
import '../shimmer_placeholders.dart';
import 'household_dashboard_shimmer.dart';

/// Shimmer skeleton for Expense History Screen
class ExpenseHistoryShimmer extends StatelessWidget {
  const ExpenseHistoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search / Filter bar skeleton
            const Row(
              children: [
                Expanded(child: ShimmerBox(height: 48)),
                SizedBox(width: 12),
                ShimmerBox(width: 48, height: 48),
              ],
            ),
            const SizedBox(height: 20),

            // Date Group Header
            const ShimmerLine(width: 100, height: 14),
            const SizedBox(height: 12),
            const ExpenseTileSkeleton(),
            const SizedBox(height: 10),
            const ExpenseTileSkeleton(),

            const SizedBox(height: 20),

            // Another Date Group Header
            const ShimmerLine(width: 120, height: 14),
            const SizedBox(height: 12),
            const ExpenseTileSkeleton(),
            const SizedBox(height: 10),
            const ExpenseTileSkeleton(),
          ],
        ),
      ),
    );
  }
}

/// Shimmer skeleton for Expense Detail Screen
class ExpenseDetailShimmer extends StatelessWidget {
  const ExpenseDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            // Hero Icon / Category Circle
            const ShimmerCircle(size: 80),
            const SizedBox(height: 16),

            // Expense Title Line
            const ShimmerLine(width: 180, height: 22),
            const SizedBox(height: 8),

            // Category pill
            const ShimmerBox(width: 90, height: 26),
            const SizedBox(height: 20),

            // Big Amount Display Card
            const ShimmerCard(
              height: 100,
              borderRadius: 20,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShimmerLine(width: 80, height: 12),
                  SizedBox(height: 10),
                  ShimmerLine(width: 160, height: 32),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Split Details Header
            const Align(
              alignment: Alignment.centerLeft,
              child: ShimmerLine(width: 140, height: 16),
            ),
            const SizedBox(height: 12),

            // Participant Rows Skeleton
            const ShimmerCard(
              height: 70,
              borderRadius: 16,
              margin: EdgeInsets.only(bottom: 10),
            ),
            const ShimmerCard(
              height: 70,
              borderRadius: 16,
              margin: EdgeInsets.only(bottom: 10),
            ),
            const ShimmerCard(
              height: 70,
              borderRadius: 16,
              margin: EdgeInsets.only(bottom: 10),
            ),
          ],
        ),
      ),
    );
  }
}
