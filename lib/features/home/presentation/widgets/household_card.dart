import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kharcha_paani/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../models/household_model.dart';
import '../../../balances/providers/balance_provider.dart';

class HouseholdCard extends ConsumerWidget {
  final HouseholdModel household;
  final VoidCallback onTap;

  const HouseholdCard({
    super.key,
    required this.household,
    required this.onTap,
  });

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'trip':
        return Icons.flight_takeoff_rounded;
      case 'friends':
        return Icons.celebration_rounded;
      case 'office':
        return Icons.work_outline_rounded;
      case 'couple':
        return Icons.favorite_border_rounded;
      case 'other':
        return Icons.category_outlined;
      case 'home':
      default:
        return Icons.home_outlined;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'trip':
        return const Color(0xFF00B8D9);
      case 'friends':
        return const Color(0xFFFF8B00);
      case 'office':
        return const Color(0xFF6554C0);
      case 'couple':
        return const Color(0xFFFF5630);
      case 'other':
        return const Color(0xFF36B37E);
      case 'home':
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(householdSummaryProvider(household.id));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final catIcon = _getCategoryIcon(household.category);
    final catColor = _getCategoryColor(household.category);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Name & Member Count + Invite Code
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: isDark ? 0.2 : 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      catIcon,
                      color: catColor,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          household.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.people_outline,
                              size: 15,
                              color: AppColors.textSecondaryLight,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              AppLocalizations.of(context)!.homeMemberCount(household.memberCount),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.surfaceVariantDark
                                    : AppColors.surfaceVariantLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '#${household.inviteCode}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.textTertiaryLight,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 16),

              // Monthly Expense & User Net Status
              summaryAsync.when(
                data: (summary) {
                  final net = summary.netBalancePaise;
                  final isOwed = net > 0;
                  final owes = net < 0;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Total Household Spend
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.homeTotalExpenses,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            CurrencyFormatter.formatPaise(summary.totalExpensesPaise),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),

                      // User Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isOwed
                              ? AppColors.positiveLight
                              : owes
                                  ? AppColors.negativeLight
                                  : isDark
                                      ? AppColors.surfaceVariantDark
                                      : AppColors.surfaceVariantLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isOwed
                                  ? Icons.arrow_downward
                                  : owes
                                      ? Icons.arrow_upward
                                      : Icons.check_circle_outline,
                              size: 14,
                              color: isOwed
                                  ? AppColors.positive
                                  : owes
                                      ? AppColors.negative
                                      : AppColors.neutral,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isOwed
                                  ? AppLocalizations.of(context)!.homeYouReceive(CurrencyFormatter.formatPaise(summary.youShouldReceivePaise))
                                  : owes
                                      ? AppLocalizations.of(context)!.homeYouOwe(CurrencyFormatter.formatPaise(summary.youOwePaise))
                                      : AppLocalizations.of(context)!.homeSettledUpBadge,
                              style: TextStyle(
                                color: isOwed
                                    ? AppColors.positive
                                    : owes
                                        ? AppColors.negative
                                        : AppColors.neutral,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const SizedBox(
                  height: 36,
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                error: (_, _) => Text(
                  AppLocalizations.of(context)!.homeTapDetails,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
