import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../models/household_member_model.dart';
import '../../../../services/expense_calculation_service.dart';

class SettlementTransferCard extends StatelessWidget {
  final SimplifiedDebt debt;
  final List<HouseholdMemberModel> members;
  final String currentUserId;
  final VoidCallback onSettleUp;

  const SettlementTransferCard({
    super.key,
    required this.debt,
    required this.members,
    required this.currentUserId,
    required this.onSettleUp,
  });

  @override
  Widget build(BuildContext context) {
    final fromMember = members.firstWhere(
      (m) => m.id == debt.fromUser,
      orElse: () => HouseholdMemberModel(
        id: debt.fromUser,
        name: 'Roommate',
        joinedAt: DateTime.now(),
      ),
    );

    final toMember = members.firstWhere(
      (m) => m.id == debt.toUser,
      orElse: () => HouseholdMemberModel(
        id: debt.toUser,
        name: 'Roommate',
        joinedAt: DateTime.now(),
      ),
    );

    final bool isUserDebtor = debt.fromUser == currentUserId;
    final bool isUserCreditor = debt.toUser == currentUserId;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // From User
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isUserDebtor ? 'You' : fromMember.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'owes',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.negative,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),

                // Arrow & Amount
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Text(
                        CurrencyFormatter.formatPaise(debt.amountPaise),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Icon(
                        Icons.arrow_forward,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),

                // To User
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        isUserCreditor ? 'You' : toMember.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'receives',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.positive,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(),
            const SizedBox(height: 10),

            // Settle Up Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onSettleUp,
                icon: const Icon(Icons.handshake_outlined, size: 18),
                label: Text(
                  isUserDebtor
                      ? 'Pay ${CurrencyFormatter.formatPaise(debt.amountPaise)} to ${toMember.name}'
                      : isUserCreditor
                          ? 'Record payment from ${fromMember.name}'
                          : 'Record Settlement',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  textStyle: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
