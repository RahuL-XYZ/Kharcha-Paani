import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../../household/providers/household_provider.dart';
import '../providers/balance_provider.dart';
import '../../settlements/presentation/settlement_history_screen.dart';
import 'settle_up_screen.dart';
import 'widgets/member_balance_card.dart';
import 'widgets/settlement_transfer_card.dart';
import '../../../core/widgets/shimmer/skeletons/balances_shimmers.dart';

class BalancesScreen extends ConsumerWidget {
  final String householdId;

  const BalancesScreen({
    super.key,
    required this.householdId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balancesAsync = ref.watch(householdBalancesProvider(householdId));
    final debtsAsync = ref.watch(simplifiedDebtsProvider(householdId));
    final membersAsync =
        ref.watch(householdMembersStreamProvider(householdId));
    final currentUserId = ref.watch(currentUserIdProvider) ?? '';

    final members = membersAsync.asData?.value ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Balances & Settle Up'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_outlined),
            tooltip: 'Settlement History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      SettlementHistoryScreen(householdId: householdId),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: balancesAsync.when(
        data: (balances) {
          if (balances.isEmpty || members.isEmpty) {
            return const Center(child: Text('No balance data available.'));
          }

          final simplifiedDebts = debtsAsync.asData?.value ?? [];

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(householdBalancesProvider(householdId));
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                // Simplified Transfers Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Suggested Settlements',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    if (simplifiedDebts.isNotEmpty)
                      Text(
                        '${simplifiedDebts.length} transfers',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Minimum transactions needed to settle all household debts.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),

                // Simplified Debts List or All Settled Card
                if (simplifiedDebts.isEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.positiveLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: AppColors.positive,
                          size: 36,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'All settled up! 🎉',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.positive,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'No outstanding debts among roommates.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.positive.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  ...simplifiedDebts.map(
                    (debt) => SettlementTransferCard(
                      debt: debt,
                      members: members,
                      currentUserId: currentUserId,
                      onSettleUp: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SettleUpScreen(
                              householdId: householdId,
                              initialFromUser: debt.fromUser,
                              initialToUser: debt.toUser,
                              initialAmount: debt.amountRupees,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 28),

                // Roommate Net Balances Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Individual Net Balances',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SettleUpScreen(householdId: householdId),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Custom Settle'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Member Net Balance Cards
                ...members.map((member) {
                  final balance = balances[member.id];
                  if (balance == null) return const SizedBox.shrink();

                  return MemberBalanceCard(
                    member: member,
                    balance: balance,
                    isCurrentUser: member.id == currentUserId,
                  );
                }),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
        loading: () => const BalancesScreenShimmer(),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
