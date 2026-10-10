import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/household_member_model.dart';
import '../../household/providers/household_provider.dart';
import '../../settlements/providers/settlement_provider.dart';
import '../../../core/widgets/shimmer/skeletons/members_settlements_shimmers.dart';

class SettlementHistoryScreen extends ConsumerWidget {
  final String householdId;

  const SettlementHistoryScreen({
    super.key,
    required this.householdId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settlementsAsync =
        ref.watch(householdSettlementsStreamProvider(householdId));
    final membersAsync =
        ref.watch(householdMembersStreamProvider(householdId));
    final members = membersAsync.asData?.value ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settlement History'),
      ),
      body: settlementsAsync.when(
        data: (settlements) {
          if (settlements.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.history_outlined,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No settlements recorded yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'When roommates pay each other and settle balances,\nthe history will appear here.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: settlements.length,
            itemBuilder: (context, index) {
              final settlement = settlements[index];

              final fromMember = members.firstWhere(
                (m) => m.id == settlement.fromUser,
                orElse: () => HouseholdMemberModel(
                  id: settlement.fromUser,
                  name: 'Roommate',
                  joinedAt: DateTime.now(),
                ),
              );

              final toMember = members.firstWhere(
                (m) => m.id == settlement.toUser,
                orElse: () => HouseholdMemberModel(
                  id: settlement.toUser,
                  name: 'Roommate',
                  joinedAt: DateTime.now(),
                ),
              );

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.positiveLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.check_circle_outline,
                          color: AppColors.positive,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${fromMember.name} paid ${toMember.name}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormatter.formatDateTime(settlement.createdAt),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        CurrencyFormatter.formatRupees(settlement.amount),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.positive,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const SettlementHistoryShimmer(),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
