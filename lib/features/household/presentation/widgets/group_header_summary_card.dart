import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../models/household_model.dart';
import '../../../../services/expense_calculation_service.dart';
import 'package:kharcha_paani/l10n/app_localizations.dart';

class GroupHeaderSummaryCard extends StatelessWidget {
  final HouseholdModel household;
  final HouseholdSummary summary;
  final VoidCallback onSettleUp;
  final VoidCallback onAddExpense;

  const GroupHeaderSummaryCard({
    super.key,
    required this.household,
    required this.summary,
    required this.onSettleUp,
    required this.onAddExpense,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final net = summary.netBalancePaise;
    final isOwed = net > 0;
    final owes = net < 0;
    final isSettled = net == 0;

    // Status visual styles: subtle tint for background with crisp, readable text and icons
    final statusBgColor = isOwed
        ? (isDark ? const Color(0xFF064E3B).withValues(alpha: 0.25) : const Color(0xFFECFDF5))
        : owes
            ? (isDark ? const Color(0xFFEF4444).withValues(alpha: 0.15) : const Color(0xFFFEF2F2))
            : (isDark ? AppColors.surfaceVariantDark : const Color(0xFFF1F5F9));

    final statusBorderColor = isOwed
        ? AppColors.positive.withValues(alpha: isDark ? 0.4 : 0.3)
        : owes
            ? AppColors.negative.withValues(alpha: isDark ? 0.4 : 0.3)
            : Theme.of(context).dividerColor;

    final statusTextColor = isOwed
        ? (isDark ? const Color(0xFF34D399) : AppColors.positive)
        : owes
            ? (isDark ? const Color(0xFFFCA5A5) : AppColors.negative)
            : (isDark ? Colors.white70 : AppColors.textSecondaryLight);

    final statusTitle = isOwed
        ? AppLocalizations.of(context)!.hhYouAreOwed
        : owes
            ? AppLocalizations.of(context)!.hhYouOwe
            : AppLocalizations.of(context)!.hhYouAreSettledUp;

    final statusAmount = isOwed
        ? CurrencyFormatter.formatPaise(summary.youShouldReceivePaise)
        : owes
            ? CurrencyFormatter.formatPaise(summary.youOwePaise)
            : '₹0';

    final statusIcon = isOwed
        ? Icons.arrow_downward_rounded
        : owes
            ? Icons.arrow_upward_rounded
            : Icons.check_circle_rounded;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Group Name & Meta
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    household.name.isNotEmpty
                        ? household.name[0].toUpperCase()
                        : 'G',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      household.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.people_alt_rounded,
                          size: 14,
                          color: AppColors.neutral,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppLocalizations.of(context)!.homeMemberCount(household.memberCount),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '• #${household.inviteCode}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Total group spent banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.receipt_long_rounded,
                      size: 16,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppLocalizations.of(context)!.hhTotalGroupSpend,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                Text(
                  CurrencyFormatter.formatPaise(summary.totalExpensesPaise),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Hero Net Balance Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: statusBorderColor, width: 1.2),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: statusTextColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    statusIcon,
                    color: statusTextColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusTitle.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                          color: statusTextColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isSettled ? AppLocalizations.of(context)!.hhAllSettledUp : statusAmount,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: statusTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // You Paid vs Your Share Metrics
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.surfaceDark
                        : AppColors.surfaceVariantLight,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.hhYouPaid,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.formatPaise(summary.youPaidPaise),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.surfaceDark
                        : AppColors.surfaceVariantLight,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.hhYourShare,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.formatPaise(summary.yourSharePaise),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Primary Actions: Settle Up (Hero CTA) & Add Expense
          Row(
            children: [
              Expanded(
                flex: 6,
                child: ElevatedButton.icon(
                  onPressed: onSettleUp,
                  icon: const Icon(Icons.handshake_rounded, size: 18),
                  label: Text(AppLocalizations.of(context)!.hhSettleUp),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 5,
                child: OutlinedButton.icon(
                  onPressed: onAddExpense,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(AppLocalizations.of(context)!.expAddTitle),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
