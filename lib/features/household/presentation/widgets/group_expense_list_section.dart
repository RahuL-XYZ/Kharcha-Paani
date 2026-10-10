import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/expense_categories.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../models/expense_model.dart';
import '../../../../models/household_member_model.dart';
import 'package:kharcha_paani/l10n/app_localizations.dart';

class GroupExpenseListSection extends StatelessWidget {
  final List<ExpenseModel> expenses;
  final List<HouseholdMemberModel> members;
  final String currentUserId;
  final VoidCallback onViewAll;
  final ValueChanged<ExpenseModel> onTapExpense;
  final VoidCallback onAddExpense;

  const GroupExpenseListSection({
    super.key,
    required this.expenses,
    required this.members,
    required this.currentUserId,
    required this.onViewAll,
    required this.onTapExpense,
    required this.onAddExpense,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Map<String, String> memberNameMap = {
      for (var m in members) m.id: m.name
    };

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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.hhGroupExpenses,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                ),
              ],
            ),
            if (expenses.isNotEmpty)
              TextButton(
                onPressed: onViewAll,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.hhViewAll,
                      style:
                          const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                    Icon(Icons.chevron_right_rounded, size: 16),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Empty state
        if (expenses.isEmpty)
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceVariantDark
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.receipt_long_outlined,
                  size: 38,
                  color: AppColors.neutral,
                ),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.expNoExpensesYet,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.hhStartSplitting,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  onPressed: onAddExpense,
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: Text(AppLocalizations.of(context)!.hhAddFirstExpense),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
          )
        else
          // Expense List (Show top 5)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: expenses.take(5).length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final expense = expenses[index];
              final cat = ExpenseCategories.getById(expense.category);
              final payerName = expense.paidBy == currentUserId
                  ? AppLocalizations.of(context)!.expYouSuffix
                  : (memberNameMap[expense.paidBy] ?? AppLocalizations.of(context)!.expRoommate);
              final splitCount = expense.participants.length;
              final isCurrentUserParticipant =
                  expense.participants.contains(currentUserId);

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onTapExpense(expense),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceVariantDark
                          : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Category Icon
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: cat.color.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(cat.icon, size: 20, color: cat.color),
                        ),
                        const SizedBox(width: 12),

                        // Title, Payer, Date & Split Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                expense.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    'Paid by $payerName',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: expense.paidBy == currentUserId
                                          ? AppColors.primary
                                          : null,
                                    ),
                                  ),
                                  Text(
                                    '  •  Split between $splitCount ${splitCount == 1 ? 'person' : 'people'}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(fontSize: 11),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                DateFormatter.formatExpenseDate(expense.date),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontSize: 11,
                                      color: AppColors.neutral,
                                    ),
                              ),
                            ],
                          ),
                        ),

                        // Amount Column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              CurrencyFormatter.formatPaise(expense.amountPaise),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            if (isCurrentUserParticipant &&
                                expense.paidBy != currentUserId)
                              Text(
                                'you lent/borrowed',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.neutral,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 16,
                          color: AppColors.neutral,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
