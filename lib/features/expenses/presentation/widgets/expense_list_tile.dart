import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/expense_categories.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../models/expense_model.dart';
import '../../../../models/household_member_model.dart';

class ExpenseListTile extends StatelessWidget {
  final ExpenseModel expense;
  final List<HouseholdMemberModel> members;
  final String currentUserId;
  final VoidCallback onTap;

  const ExpenseListTile({
    super.key,
    required this.expense,
    required this.members,
    required this.currentUserId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cat = ExpenseCategories.getById(expense.category);

    // Find payer name
    final payer = members.firstWhere(
      (m) => m.id == expense.paidBy,
      orElse: () => HouseholdMemberModel(
        id: expense.paidBy,
        name: 'Roommate',
        joinedAt: DateTime.now(),
      ),
    );

    final bool isPayer = expense.paidBy == currentUserId;
    final bool isParticipant = expense.participants.contains(currentUserId);
    final int participantCount =
        expense.participants.isEmpty ? 1 : expense.participants.length;

    // Calculate individual share
    final double individualShare = expense.amount / participantCount;

    String subtitleText;
    if (isPayer) {
      subtitleText = 'You paid ${CurrencyFormatter.formatRupees(expense.amount)}';
    } else {
      subtitleText = '${payer.name} paid ${CurrencyFormatter.formatRupees(expense.amount)}';
    }

    String impactText;
    Color impactColor;
    if (isPayer) {
      if (isParticipant) {
        final double lent = expense.amount - individualShare;
        impactText = 'you lent ${CurrencyFormatter.formatRupees(lent)}';
        impactColor = AppColors.positive;
      } else {
        impactText = 'you lent ${CurrencyFormatter.formatRupees(expense.amount)}';
        impactColor = AppColors.positive;
      }
    } else {
      if (isParticipant) {
        impactText = 'you owe ${CurrencyFormatter.formatRupees(individualShare)}';
        impactColor = AppColors.negative;
      } else {
        impactText = 'not involved';
        impactColor = AppColors.neutral;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Category Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: cat.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(cat.icon, color: cat.color, size: 22),
              ),
              const SizedBox(width: 14),

              // Title and Payer info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            subtitleText,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '• ${DateFormatter.formatExpenseDate(expense.date)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textTertiaryLight,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Amount and Personal Impact
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormatter.formatRupees(expense.amount),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    impactText,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: impactColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
