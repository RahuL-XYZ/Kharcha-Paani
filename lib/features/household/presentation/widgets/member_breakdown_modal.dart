import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../models/household_member_model.dart';
import '../../../balances/providers/balance_provider.dart';
import '../../../../core/widgets/shimmer/app_shimmer.dart';
import '../../../../core/widgets/shimmer/shimmer_placeholders.dart';

class MemberBreakdownModal extends ConsumerWidget {
  final String householdId;
  final HouseholdMemberModel member;
  final String currentUserId;
  final void Function(String fromUser, String toUser, double amount) onSettle;

  const MemberBreakdownModal({
    super.key,
    required this.householdId,
    required this.member,
    required this.currentUserId,
    required this.onSettle,
  });

  static void show(
    BuildContext context, {
    required String householdId,
    required HouseholdMemberModel member,
    required String currentUserId,
    required void Function(String fromUser, String toUser, double amount) onSettle,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => MemberBreakdownModal(
        householdId: householdId,
        member: member,
        currentUserId: currentUserId,
        onSettle: onSettle,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final breakdownAsync = ref.watch(pairwiseBreakdownProvider(
      PairwiseQuery(householdId: householdId, otherUserId: member.id),
    ));

    final initials = member.name.isNotEmpty
        ? member.name.trim().split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join().toUpperCase()
        : '?';

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.78,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header: Member Profile & Net Status
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primaryLight,
                  foregroundColor: AppColors.primary,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Shared balance breakdown with you',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Content body
          Expanded(
            child: breakdownAsync.when(
              data: (breakdown) {
                final isOwed = breakdown.otherOwesYou;
                final owes = breakdown.youOweOther;
                final isSettled = breakdown.isSettled;

                final statusBgColor = isOwed
                    ? (isDark ? const Color(0xFF064E3B) : const Color(0xFFE8F5E9))
                    : owes
                        ? (isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFFEBEE))
                        : (isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight);

                final statusTextColor = isOwed
                    ? AppColors.positive
                    : owes
                        ? AppColors.negative
                        : AppColors.neutral;

                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Net Relationship Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: statusTextColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isOwed
                                ? Icons.arrow_downward_rounded
                                : owes
                                    ? Icons.arrow_upward_rounded
                                    : Icons.check_circle_outline_rounded,
                            color: statusTextColor,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isOwed
                                      ? '${member.name} owes you'
                                      : owes
                                          ? 'You owe ${member.name}'
                                          : 'Settled up with ${member.name}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: statusTextColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isSettled
                                      ? 'No pending balance'
                                      : CurrencyFormatter.formatPaise(
                                          breakdown.netBalancePaise.abs()),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: statusTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!isSettled)
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                onSettle(
                                  owes ? currentUserId : member.id,
                                  owes ? member.id : currentUserId,
                                  breakdown.netBalanceRupees.abs(),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Settle'),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Breakdown List Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Shared Expenses & Settlements',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '${breakdown.items.length} items',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (breakdown.items.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(28),
                        alignment: Alignment.center,
                        child: Text(
                          'No mutual shared expenses found.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      )
                    else
                      ...breakdown.items.map((item) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.surfaceVariantDark
                                : AppColors.surfaceVariantLight,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: item.isSettlement
                                      ? AppColors.primary.withValues(alpha: 0.12)
                                      : (isDark ? Colors.black26 : Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  item.isSettlement
                                      ? Icons.handshake_outlined
                                      : Icons.receipt_outlined,
                                  size: 18,
                                  color: item.isSettlement
                                      ? AppColors.primary
                                      : AppColors.neutral,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${item.description} • ${DateFormatter.formatDate(item.date)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                item.youPaid
                                    ? '+${CurrencyFormatter.formatPaise(item.amountPaise)}'
                                    : '-${CurrencyFormatter.formatPaise(item.amountPaise)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                  color: item.youPaid
                                      ? AppColors.positive
                                      : AppColors.negative,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                );
              },
              loading: () => const AppShimmer(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ShimmerCard(height: 56, borderRadius: 16),
                      SizedBox(height: 10),
                      ShimmerCard(height: 56, borderRadius: 16),
                    ],
                  ),
                ),
              ),
              error: (err, _) => Center(
                child: Text('Error loading breakdown: $err'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
