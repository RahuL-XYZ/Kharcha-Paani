import 'package:flutter/material.dart';
import '../app_shimmer.dart';
import '../shimmer_placeholders.dart';

class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting line
            const ShimmerLine(width: 180, height: 24),
            const SizedBox(height: 8),
            const ShimmerLine(width: 240, height: 14),
            const SizedBox(height: 20),

            // Overall Balance Banner Card skeleton
            const ShimmerCard(
              height: 140,
              borderRadius: 20,
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerLine(width: 120, height: 12),
                      ShimmerLine(width: 60, height: 12),
                    ],
                  ),
                  ShimmerLine(width: 160, height: 28),
                  Row(
                    children: [
                      Expanded(child: ShimmerLine(height: 14)),
                      SizedBox(width: 16),
                      Expanded(child: ShimmerLine(height: 14)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section Header: Households
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerLine(width: 140, height: 20),
                ShimmerLine(width: 60, height: 16),
              ],
            ),
            const SizedBox(height: 14),

            // Household Cards List
            const ShimmerCard(
              height: 180,
              borderRadius: 24,
            ),
            const SizedBox(height: 16),
            const ShimmerCard(
              height: 180,
              borderRadius: 24,
            ),
          ],
        ),
      ),
    );
  }
}
