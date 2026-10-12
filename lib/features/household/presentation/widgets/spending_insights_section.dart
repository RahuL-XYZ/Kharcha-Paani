import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/expense_categories.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../services/expense_calculation_service.dart';

class SpendingInsightsSection extends StatelessWidget {
  final GroupSpendingInsights insights;
  final VoidCallback onOpenAnalytics;

  const SpendingInsightsSection({
    super.key,
    required this.insights,
    required this.onOpenAnalytics,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (insights.totalSpentPaise <= 0) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(
                    Icons.insights_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Spending Insights',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                ),
              ],
            ),
            TextButton(
              onPressed: onOpenAnalytics,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Row(
                children: [
                  Text(
                    'Full Analytics',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  Icon(Icons.chevron_right_rounded, size: 16),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Quick Stats Row: Highest Spender, Largest Expense, Avg Per Member
        Row(
          children: [
            // Highest Spender
            if (insights.highestSpenderName != null)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.surfaceVariantDark
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.star_rounded,
                              size: 14, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(
                            'Top Spender',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.neutral,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        insights.highestSpenderName!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        CurrencyFormatter.formatPaise(
                            insights.highestSpenderAmountPaise),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (insights.highestSpenderName != null) const SizedBox(width: 8),

            // Largest Expense
            if (insights.largestExpense != null)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.surfaceVariantDark
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.trending_up_rounded,
                              size: 14, color: AppColors.primary),
                          SizedBox(width: 4),
                          Text(
                            'Largest Bill',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.neutral,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        insights.largestExpense!.title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        CurrencyFormatter.formatPaise(
                            insights.largestExpense!.amountPaise),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(width: 8),

            // Avg Per Member
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceVariantDark
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.pie_chart_outline_rounded,
                            size: 14, color: AppColors.neutral),
                        SizedBox(width: 4),
                        Text(
                          'Avg / Member',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.neutral,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      CurrencyFormatter.formatPaise(
                          insights.averagePerMemberPaise),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'per person',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.neutral,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Category Breakdown Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceVariantDark
                : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Spending by Category',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),

              ...insights.categoryBreakdown.take(4).map((cat) {
                final catItem = ExpenseCategories.getById(cat.category);
                final percent = cat.percentage.clamp(0.0, 100.0);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: catItem.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Icon(catItem.icon,
                                size: 14, color: catItem.color),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              catItem.label,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            CurrencyFormatter.formatPaise(cat.totalPaise),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(${percent.toStringAsFixed(0)}%)',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: LinearProgressIndicator(
                          value: percent / 100,
                          minHeight: 6,
                          backgroundColor: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(catItem.color),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
