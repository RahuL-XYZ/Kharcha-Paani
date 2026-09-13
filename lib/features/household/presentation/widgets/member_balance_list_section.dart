import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../models/household_member_model.dart';
import '../../../../services/expense_calculation_service.dart';

class MemberBalanceListSection extends StatelessWidget {
  final List<HouseholdMemberModel> members;
  final Map<String, MemberBalanceSummary> balances;
  final String currentUserId;
  final ValueChanged<HouseholdMemberModel> onTapMember;

  const MemberBalanceListSection({
    super.key,
    required this.members,
    required this.balances,
    required this.currentUserId,
    required this.onTapMember,
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Member Balances',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                ),
              ],
            ),
            Text(
              '${members.length} members',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Tap any member to view pairwise breakdown & settle up.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
        ),
        const SizedBox(height: 12),

        // Member List Cards
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: members.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final member = members[index];
            final balance = balances[member.id] ??
                MemberBalanceSummary(
                  userId: member.id,
                  amountPaidPaise: 0,
                  sharePaise: 0,
                  settlementPaidPaise: 0,
                  settlementReceivedPaise: 0,
                  netBalancePaise: 0,
                );

            final isMe = member.id == currentUserId;
            final net = balance.netBalancePaise;
            final isOwed = net > 0;
            final owes = net < 0;

            final initials = member.name.isNotEmpty
                ? member.name.trim().split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join().toUpperCase()
                : '?';

            final statusColor = isOwed
                ? AppColors.positive
                : owes
                    ? AppColors.negative
                    : AppColors.neutral;

            final statusLabel = isOwed
                ? (isMe ? 'you receive' : 'gets back')
                : owes
                    ? (isMe ? 'you owe' : 'owes')
                    : 'settled';

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onTapMember(member),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? (isMe
                            ? AppColors.surfaceVariantDark
                            : AppColors.surfaceDark)
                        : (isMe
                            ? AppColors.primaryLight.withValues(alpha: 0.15)
                            : AppColors.surfaceLight),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isMe
                          ? AppColors.primary.withValues(alpha: 0.45)
                          : (isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight),
                      width: isMe ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: isMe
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.surfaceVariantDark
                                : AppColors.surfaceVariantLight),
                        foregroundColor: isMe
                            ? Colors.white
                            : (isDark ? Colors.white : Colors.black87),
                        child: Text(
                          initials,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Name, Paid, Share
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
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isMe) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 1.5),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'You',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Paid ${CurrencyFormatter.formatPaise(balance.amountPaidPaise)}  •  Share ${CurrencyFormatter.formatPaise(balance.sharePaise)}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 12,
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Net Balance Column
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
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: statusColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            statusLabel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
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
