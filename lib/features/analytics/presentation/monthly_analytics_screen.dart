import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/expense_categories.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../analytics/providers/analytics_provider.dart';
import '../../expenses/providers/expense_provider.dart';
import '../../../core/ads/widgets/anchored_banner_ad.dart';
import '../../../core/ads/ad_helper.dart';
import '../../../core/widgets/shimmer/skeletons/analytics_shimmer.dart';
import '../../../core/widgets/common_app_bar.dart';

class MonthlyAnalyticsScreen extends ConsumerWidget {
  final String householdId;

  const MonthlyAnalyticsScreen({
    super.key,
    required this.householdId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync =
        ref.watch(householdExpensesStreamProvider(householdId));
    final monthlyBreakdown =
        ref.watch(monthlyBreakdownProvider(householdId));
    final categoryBreakdown =
        ref.watch(categoryBreakdownProvider(householdId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const CommonAppBar(
        titleText: 'Spending Analytics',
      ),
      bottomNavigationBar:
          AdHelper.isAdsEnabled ? const AnchoredBannerAd() : null,
      body: expensesAsync.when(
        data: (expenses) {
          if (expenses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.insights_outlined,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No spending data yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Add expenses to see category breakdowns and monthly trends.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            );
          }

          final double totalSpend =
              expenses.fold(0.0, (sum, exp) => sum + exp.amount);

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              // Total Lifetime Spend Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceVariantDark
                      : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Household Spend',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.primaryDark,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      CurrencyFormatter.formatRupees(totalSpend),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Across ${expenses.length} shared ${expenses.length == 1 ? 'expense' : 'expenses'}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Category Breakdown Header
              Text(
                'Spending by Category',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),

              // Category Breakdown Bars
              ...categoryBreakdown.map((catSpending) {
                final cat = ExpenseCategories.getById(catSpending.category);

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: cat.color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(cat.icon, color: cat.color, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                cat.label,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Text(
                              CurrencyFormatter.formatRupees(
                                  catSpending.totalRupees),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: LinearProgressIndicator(
                            value: (catSpending.percentage / 100).clamp(0.0, 1.0),
                            minHeight: 8,
                            backgroundColor: isDark
                                ? AppColors.surfaceDark
                                : AppColors.surfaceVariantLight,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(cat.color),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${catSpending.expenseCount} ${catSpending.expenseCount == 1 ? 'expense' : 'expenses'}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              '${catSpending.percentage.toStringAsFixed(1)}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 28),

              // Monthly Trends Header
              Text(
                'Monthly Trends',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),

              // Monthly Group Cards
              ...monthlyBreakdown.map((monthly) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.secondary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      DateFormatter.formatMonthYear(monthly.monthYear),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      '${monthly.expenses.length} expenses recorded',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: Text(
                      CurrencyFormatter.formatRupees(monthly.totalRupees),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 40),
            ],
          );
        },
        loading: () => const MonthlyAnalyticsShimmer(),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
