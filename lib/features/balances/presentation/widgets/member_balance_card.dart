import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../models/household_member_model.dart';
import '../../../../services/expense_calculation_service.dart';

class MemberBalanceCard extends StatelessWidget {
  final HouseholdMemberModel member;
  final MemberBalanceSummary balance;
  final bool isCurrentUser;

  const MemberBalanceCard({
    super.key,
    required this.member,
    required this.balance,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    final net = balance.netBalancePaise;
    final isOwed = net > 0;
    final owes = net < 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final initials = member.name.isNotEmpty
        ? member.name.trim().split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join().toUpperCase()
        : '?';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: isCurrentUser
                  ? AppColors.primary
                  : isDark
                      ? AppColors.surfaceVariantDark
                      : AppColors.surfaceVariantLight,
              foregroundColor: isCurrentUser
                  ? Colors.white
                  : isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
              child: Text(
                initials,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          member.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isCurrentUser) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'You',
                            style: TextStyle(
                              color: AppColors.primaryDark,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Paid: ${CurrencyFormatter.formatPaise(balance.amountPaidPaise)}  •  Share: ${CurrencyFormatter.formatPaise(balance.sharePaise)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isOwed
                      ? '+${CurrencyFormatter.formatPaise(net)}'
                      : owes
                          ? '-${CurrencyFormatter.formatPaise(net.abs())}'
                          : '₹0',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: isOwed
                        ? AppColors.positive
                        : owes
                            ? AppColors.negative
                            : AppColors.neutral,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isOwed
                      ? (isCurrentUser ? 'you receive' : 'gets back')
                      : owes
                          ? (isCurrentUser ? 'you owe' : 'owes')
                          : 'settled',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isOwed
                        ? AppColors.positive
                        : owes
                            ? AppColors.negative
                            : AppColors.neutral,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
