import 'package:flutter/material.dart';
import '../app_shimmer.dart';
import '../shimmer_placeholders.dart';

/// Skeleton for Household Members Screen
class HouseholdMembersShimmer extends StatelessWidget {
  const HouseholdMembersShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Invite Code Header Card Skeleton
            const ShimmerCard(
              height: 90,
              borderRadius: 20,
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShimmerLine(width: 100, height: 12),
                      SizedBox(height: 6),
                      ShimmerLine(width: 140, height: 18),
                    ],
                  ),
                  ShimmerBox(width: 44, height: 44),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section Header
            const ShimmerLine(width: 120, height: 18),
            const SizedBox(height: 14),

            // Member Tile Skeletons
            const MemberTileSkeleton(),
            const SizedBox(height: 10),
            const MemberTileSkeleton(),
            const SizedBox(height: 10),
            const MemberTileSkeleton(),
          ],
        ),
      ),
    );
  }
}

class MemberTileSkeleton extends StatelessWidget {
  const MemberTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerCard(
      height: 72,
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
                ShimmerLine(width: 90, height: 10),
              ],
            ),
          ),
          SizedBox(width: 12),
          ShimmerBox(width: 50, height: 24),
        ],
      ),
    );
  }
}

/// Skeleton for Settlement History Screen
class SettlementHistoryShimmer extends StatelessWidget {
  const SettlementHistoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerLine(width: 100, height: 14),
            const SizedBox(height: 12),
            const SettlementTileSkeleton(),
            const SizedBox(height: 10),
            const SettlementTileSkeleton(),
            const SizedBox(height: 20),
            const ShimmerLine(width: 120, height: 14),
            const SizedBox(height: 12),
            const SettlementTileSkeleton(),
          ],
        ),
      ),
    );
  }
}

class SettlementTileSkeleton extends StatelessWidget {
  const SettlementTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerCard(
      height: 76,
      borderRadius: 16,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          ShimmerCircle(size: 40),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShimmerLine(width: 140, height: 14),
                SizedBox(height: 6),
                ShimmerLine(width: 80, height: 10),
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
