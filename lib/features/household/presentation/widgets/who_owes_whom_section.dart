import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../models/household_member_model.dart';
import '../../../../services/expense_calculation_service.dart';

class WhoOwesWhomSection extends StatelessWidget {
  final List<SimplifiedDebt> debts;
  final List<HouseholdMemberModel> members;
  final String currentUserId;
  final void Function(String fromUser, String toUser, double amount) onSettleTransfer;

  const WhoOwesWhomSection({
    super.key,
    required this.debts,
    required this.members,
    required this.currentUserId,
    required this.onSettleTransfer,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                    Icons.swap_horizontal_circle_outlined,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Who Owes Whom',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                ),
              ],
            ),
            if (debts.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceVariantDark
                      : AppColors.surfaceVariantLight,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  '${debts.length} ${debts.length == 1 ? 'settlement' : 'settlements'}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutral,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Optimized minimum transactions needed to settle all group debts.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
        ),
        const SizedBox(height: 12),

        // If all settled
        if (debts.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF064E3B).withValues(alpha: 0.4)
                  : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: AppColors.positive.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.positive.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.celebration_rounded,
                    color: AppColors.positive,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Everyone is settled up! 🎉',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.positive,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'No pending debts among group members.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else
          // Optimized Debt Transactions List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: debts.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final debt = debts[index];
              final fromMember = members.firstWhere(
                (m) => m.id == debt.fromUser,
                orElse: () => HouseholdMemberModel(
                  id: debt.fromUser,
                  name: 'Member',
                  joinedAt: DateTime.now(),
                ),
              );
              final toMember = members.firstWhere(
                (m) => m.id == debt.toUser,
                orElse: () => HouseholdMemberModel(
                  id: debt.toUser,
                  name: 'Member',
                  joinedAt: DateTime.now(),
                ),
              );

              final isMePaying = debt.fromUser == currentUserId;
              final isMeReceiving = debt.toUser == currentUserId;
              final isMeInvolved = isMePaying || isMeReceiving;

              final fromName = isMePaying ? 'You' : fromMember.name;
              final toName = isMeReceiving ? 'You' : toMember.name;

              final fromInitials = fromMember.name.isNotEmpty
                  ? fromMember.name.trim().split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join().toUpperCase()
                  : '?';
              final toInitials = toMember.name.isNotEmpty
                  ? toMember.name.trim().split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join().toUpperCase()
                  : '?';

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? (isMeInvolved
                          ? AppColors.surfaceVariantDark
                          : AppColors.surfaceDark)
                      : (isMeInvolved
                          ? Colors.white
                          : AppColors.surfaceLight),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: isMeInvolved
                        ? AppColors.primary.withValues(alpha: 0.4)
                        : (isDark ? AppColors.borderDark : AppColors.borderLight),
                    width: isMeInvolved ? 1.5 : 1.0,
                  ),
                  boxShadow: [
                    if (isMeInvolved)
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Payer
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: isMePaying
                              ? AppColors.primary
                              : (isDark
                                  ? AppColors.surfaceVariantDark
                                  : AppColors.surfaceVariantLight),
                          foregroundColor: isMePaying
                              ? Colors.white
                              : (isDark ? Colors.white : Colors.black87),
                          child: Text(
                            fromInitials,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fromName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: isMePaying ? AppColors.primary : null,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Text(
                                'pays',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.negative,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Transfer Arrow & Amount
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Text(
                                CurrencyFormatter.formatPaise(debt.amountPaise),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),

                        // Receiver
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                toName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: isMeReceiving ? AppColors.positive : null,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Text(
                                'receives',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.positive,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: isMeReceiving
                              ? AppColors.positive
                              : (isDark
                                  ? AppColors.surfaceVariantDark
                                  : AppColors.surfaceVariantLight),
                          foregroundColor: isMeReceiving
                              ? Colors.white
                              : (isDark ? Colors.white : Colors.black87),
                          child: Text(
                            toInitials,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 10),

                    // Direct Settle Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => onSettleTransfer(
                          debt.fromUser,
                          debt.toUser,
                          debt.amountRupees,
                        ),
                        icon: const Icon(Icons.check_rounded, size: 16),
                        label: Text(
                          isMePaying
                              ? 'Pay ${CurrencyFormatter.formatPaise(debt.amountPaise)} to ${toMember.name}'
                              : isMeReceiving
                                  ? 'Record payment from ${fromMember.name}'
                                  : 'Record Settlement',
                          style: const TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isMeInvolved
                              ? AppColors.primary
                              : (isDark
                                  ? AppColors.surfaceVariantDark
                                  : AppColors.surfaceVariantLight),
                          foregroundColor: isMeInvolved
                              ? Colors.white
                              : (isDark ? Colors.white70 : Colors.black87),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          elevation: isMeInvolved ? 1 : 0,
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
