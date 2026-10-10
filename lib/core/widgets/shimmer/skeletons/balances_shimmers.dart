import 'package:flutter/material.dart';
import '../app_shimmer.dart';
import '../shimmer_placeholders.dart';

/// Skeleton for Balances Screen
class BalancesScreenShimmer extends StatelessWidget {
  const BalancesScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Standing Banner Card
            const ShimmerCard(
              height: 120,
              borderRadius: 20,
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerLine(width: 140, height: 12),
                  ShimmerLine(width: 180, height: 28),
                  ShimmerLine(width: 110, height: 12),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section Header
            const ShimmerLine(width: 130, height: 18),
            const SizedBox(height: 14),

            // Member Balance Cards Skeletons
            const MemberBalanceCardSkeleton(),
            const SizedBox(height: 12),
            const MemberBalanceCardSkeleton(),
            const SizedBox(height: 12),
            const MemberBalanceCardSkeleton(),
          ],
        ),
      ),
    );
  }
}

/// Member balance card skeleton widget
class MemberBalanceCardSkeleton extends StatelessWidget {
  const MemberBalanceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerCard(
      height: 84,
      borderRadius: 18,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          ShimmerCircle(size: 48),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShimmerLine(width: 110, height: 14),
                SizedBox(height: 8),
                ShimmerLine(width: 70, height: 10),
              ],
            ),
          ),
          SizedBox(width: 12),
          ShimmerBox(width: 76, height: 36),
        ],
      ),
    );
  }
}

/// Skeleton for Settle Up Screen
class SettleUpShimmer extends StatelessWidget {
  const SettleUpShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Select Recipient Dropdown skeleton
            const ShimmerBox(height: 56),
            const SizedBox(height: 24),

            // Transfer Card Skeleton (Payer -> Recipient)
            const ShimmerCard(
              height: 160,
              borderRadius: 24,
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShimmerCircle(size: 56),
                      SizedBox(height: 8),
                      ShimmerLine(width: 60, height: 12),
                    ],
                  ),
                  ShimmerLine(width: 40, height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShimmerCircle(size: 56),
                      SizedBox(height: 8),
                      ShimmerLine(width: 60, height: 12),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Amount Input Skeleton
            const ShimmerBox(height: 64),
            const SizedBox(height: 32),

            // Settle Button Skeleton
            const ShimmerBox(height: 54),
          ],
        ),
      ),
    );
  }
}
