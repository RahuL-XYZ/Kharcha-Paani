import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../household/providers/household_provider.dart';
import 'balance_provider.dart';

class OverallUserBalance {
  final int totalHouseholds;
  final int totalExpensesPaise;
  final int totalYouPaidPaise;
  final int totalYourSharePaise;
  final int totalYouShouldReceivePaise;
  final int totalYouOwePaise;

  const OverallUserBalance({
    required this.totalHouseholds,
    required this.totalExpensesPaise,
    required this.totalYouPaidPaise,
    required this.totalYourSharePaise,
    required this.totalYouShouldReceivePaise,
    required this.totalYouOwePaise,
  });

  int get netBalancePaise => totalYouShouldReceivePaise - totalYouOwePaise;
  bool get isOwed => netBalancePaise > 0;
  bool get owes => netBalancePaise < 0;
  bool get isSettled => netBalancePaise == 0;

  factory OverallUserBalance.zero() {
    return const OverallUserBalance(
      totalHouseholds: 0,
      totalExpensesPaise: 0,
      totalYouPaidPaise: 0,
      totalYourSharePaise: 0,
      totalYouShouldReceivePaise: 0,
      totalYouOwePaise: 0,
    );
  }
}

/// Aggregates net balances across all groups the user is a member of
final overallUserBalanceProvider = Provider<AsyncValue<OverallUserBalance>>((ref) {
  final householdsAsync = ref.watch(userHouseholdsStreamProvider);

  return householdsAsync.when(
    data: (households) {
      if (households.isEmpty) {
        return AsyncValue.data(OverallUserBalance.zero());
      }

      int totalExpenses = 0;
      int totalPaid = 0;
      int totalShare = 0;
      int totalReceive = 0;
      int totalOwe = 0;

      for (final h in households) {
        final summaryAsync = ref.watch(householdSummaryProvider(h.id));
        final summary = summaryAsync.asData?.value;
        if (summary != null) {
          totalExpenses += summary.totalExpensesPaise;
          totalPaid += summary.youPaidPaise;
          totalShare += summary.yourSharePaise;
          totalReceive += summary.youShouldReceivePaise;
          totalOwe += summary.youOwePaise;
        }
      }

      return AsyncValue.data(OverallUserBalance(
        totalHouseholds: households.length,
        totalExpensesPaise: totalExpenses,
        totalYouPaidPaise: totalPaid,
        totalYourSharePaise: totalShare,
        totalYouShouldReceivePaise: totalReceive,
        totalYouOwePaise: totalOwe,
      ));
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});
