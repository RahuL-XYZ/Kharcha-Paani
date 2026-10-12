import 'package:flutter/material.dart';
import 'package:kharcha_paani/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/expense_categories.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../models/expense_model.dart';
import '../../../../models/household_member_model.dart';
import '../../../../services/expense_calculation_service.dart';

class ExpenseDetailTab extends StatelessWidget {
  final ExpenseModel expense;
  final List<HouseholdMemberModel> members;
  final String currentUserId;

  const ExpenseDetailTab({
    super.key,
    required this.expense,
    required this.members,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cat = ExpenseCategories.getById(expense.category);

    final payer = members.firstWhere(
      (m) => m.id == expense.paidBy,
      orElse: () => HouseholdMemberModel(
        id: expense.paidBy,
        name: AppLocalizations.of(context)!.expRoommate,
        joinedAt: DateTime.now(),
      ),
    );

    final shares = ExpenseCalculationService.calculateEqualSplit(
      amountPaise: expense.amountPaise,
      participantIds: expense.participants,
    );

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        // Hero Receipt Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceVariantDark
                : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: cat.color.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(cat.icon, color: cat.color, size: 30),
              ),
              const SizedBox(height: 14),
              Text(
                expense.title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                CurrencyFormatter.formatRupees(expense.amount),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: cat.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  cat.label,
                  style: TextStyle(
                    color: cat.color,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 16),

              // Paid By Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.expPaidByLabel,
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text(
                    expense.paidBy == currentUserId
                        ? AppLocalizations.of(context)!
                            .expYouWithName(payer.name)
                        : payer.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Date Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.expDateLabel,
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text(
                    DateFormatter.formatDate(expense.date),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              if (expense.notes != null && expense.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.expNotesHeader,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(width: 20),
                    Flexible(
                      child: Text(
                        expense.notes!,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Split Breakdown Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.expSplitBreakdown,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (expense.splitType != 'equal')
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  '${expense.splitType.toUpperCase()} ${AppLocalizations.of(context)!.expSplitSuffix}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Participant share rows
        ...shares.map((share) {
          final participant = members.firstWhere(
            (m) => m.id == share.userId,
            orElse: () => HouseholdMemberModel(
              id: share.userId,
              name: AppLocalizations.of(context)!.expRoommate,
              joinedAt: DateTime.now(),
            ),
          );
          final isMe = share.userId == currentUserId;

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: isMe
                            ? AppColors.primaryLight
                            : isDark
                                ? AppColors.surfaceVariantDark
                                : Colors.grey.shade200,
                        child: Text(
                          participant.name.isNotEmpty
                              ? participant.name[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isMe
                                ? AppColors.primary
                                : isDark
                                    ? Colors.white
                                    : Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isMe
                            ? '${participant.name} ${AppLocalizations.of(context)!.expYouSuffix}'
                            : participant.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        CurrencyFormatter.formatPaise(share.amountPaise),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      if (expense.splitType != 'equal' &&
                          expense.splitAmounts != null &&
                          expense.splitAmounts!.containsKey(share.userId))
                        Text(
                          expense.splitType == 'percentage'
                              ? '${expense.splitAmounts![share.userId]}%'
                              : expense.splitType == 'shares'
                                  ? '${expense.splitAmounts![share.userId]?.toInt()} ${AppLocalizations.of(context)!.expSharesSuffix}'
                                  : AppLocalizations.of(context)!
                                      .expExactSuffix,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 40),
      ],
    );
  }
}
