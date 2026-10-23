import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kharcha_paani/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routing/route_names.dart';
import '../../auth/providers/auth_provider.dart';
import '../../balances/providers/overall_balance_provider.dart';
import '../../household/providers/household_provider.dart';
import 'widgets/empty_household_view.dart';
import 'widgets/home_header_widget.dart';
import 'widgets/household_card.dart';
import '../../../core/ads/widgets/anchored_banner_ad.dart';
import '../../../core/ads/ad_helper.dart';
import '../../../core/widgets/shimmer/skeletons/home_screen_shimmer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getTimeGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return AppLocalizations.of(context)!.homeGreetingMorning;
    } else if (hour < 17) {
      return AppLocalizations.of(context)!.homeGreetingAfternoon;
    } else {
      return AppLocalizations.of(context)!.homeGreetingEvening;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final householdsAsync = ref.watch(userHouseholdsStreamProvider);
    final overallBalanceAsync = ref.watch(overallUserBalanceProvider);

    final displayName = currentUser?.name.isNotEmpty == true
        ? currentUser!.name.split(' ').first
        : AppLocalizations.of(context)!.homeFriend;

    return Scaffold(
      // No AppBar — the gradient header is inline in the body
      extendBodyBehindAppBar: false,
      bottomNavigationBar:
          AdHelper.isAdsEnabled ? const AnchoredBannerAd() : null,
      body: householdsAsync.when(
        data: (households) {
          if (households.isEmpty) {
            return Column(
              children: [
                // Show header even when empty
                HomeHeaderWidget(
                  overallBalanceAsync: overallBalanceAsync,
                  displayName: displayName,
                  greeting: _getTimeGreeting(context),
                ),
                const Expanded(child: EmptyHouseholdView()),
              ],
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(userHouseholdsStreamProvider);
            },
            child: CustomScrollView(
              slivers: [
                // ── Hero Header ──
                SliverToBoxAdapter(
                  child: HomeHeaderWidget(
                    overallBalanceAsync: overallBalanceAsync,
                    displayName: displayName,
                    greeting: _getTimeGreeting(context),
                  ),
                ),

                // ── Content Section ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Quick Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    context.push(RouteNames.createHousehold),
                                icon: const Icon(Icons.add, size: 18),
                                label: Text(AppLocalizations.of(context)!
                                    .homeCreateGroup),
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    context.push(RouteNames.joinHousehold),
                                icon: const Icon(Icons.group_add_outlined,
                                    size: 18),
                                label: Text(AppLocalizations.of(context)!
                                    .homeJoinRoom),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Groups Section Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.homeMyGroups,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .homeTotalCount(households.length),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),

                // ── Household Cards ──
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => HouseholdCard(
                        household: households[index],
                        onTap: () {
                          context
                              .push('/household/${households[index].id}');
                        },
                      ),
                      childCount: households.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const HomeScreenShimmer(),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline,
                    color: AppColors.negative, size: 48),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.homeFailedLoad,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () =>
                      ref.invalidate(userHouseholdsStreamProvider),
                  child: Text(AppLocalizations.of(context)!.homeTryAgain),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

