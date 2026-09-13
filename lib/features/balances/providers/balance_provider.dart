import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/expense_calculation_service.dart';
import '../../auth/providers/auth_provider.dart';
import '../../expenses/providers/expense_provider.dart';
import '../../household/providers/household_provider.dart';
import '../../settlements/providers/settlement_provider.dart';

/// Computed provider that returns member balances for all roommates in a household
final householdBalancesProvider =
    Provider.family<AsyncValue<Map<String, MemberBalanceSummary>>, String>(
        (ref, householdId) {
  final expensesAsync = ref.watch(householdExpensesStreamProvider(householdId));
  final settlementsAsync =
      ref.watch(householdSettlementsStreamProvider(householdId));
  final membersAsync = ref.watch(householdMembersStreamProvider(householdId));

  if (expensesAsync.isLoading ||
      settlementsAsync.isLoading ||
      membersAsync.isLoading) {
    return const AsyncValue.loading();
  }

  if (expensesAsync.hasError) {
    return AsyncValue.error(
        expensesAsync.error!, expensesAsync.stackTrace ?? StackTrace.current);
  }
  if (settlementsAsync.hasError) {
    return AsyncValue.error(settlementsAsync.error!,
        settlementsAsync.stackTrace ?? StackTrace.current);
  }
  if (membersAsync.hasError) {
    return AsyncValue.error(
        membersAsync.error!, membersAsync.stackTrace ?? StackTrace.current);
  }

  final expenses = expensesAsync.asData?.value ?? [];
  final settlements = settlementsAsync.asData?.value ?? [];
  final members = membersAsync.asData?.value ?? [];
  final memberIds = members.map((m) => m.id).toList();

  final balances = ExpenseCalculationService.calculateMemberBalances(
    expenses: expenses,
    settlements: settlements,
    allMemberIds: memberIds,
  );

  return AsyncValue.data(balances);
});

/// Computed provider that returns financial summary KPI metrics for the logged-in user
final householdSummaryProvider =
    Provider.family<AsyncValue<HouseholdSummary>, String>((ref, householdId) {
  final currentUserId = ref.watch(currentUserIdProvider);
  if (currentUserId == null) {
    return AsyncValue.data(HouseholdSummary.empty());
  }

  final expensesAsync = ref.watch(householdExpensesStreamProvider(householdId));
  final settlementsAsync =
      ref.watch(householdSettlementsStreamProvider(householdId));
  final membersAsync = ref.watch(householdMembersStreamProvider(householdId));

  if (expensesAsync.isLoading ||
      settlementsAsync.isLoading ||
      membersAsync.isLoading) {
    return const AsyncValue.loading();
  }

  if (expensesAsync.hasError ||
      settlementsAsync.hasError ||
      membersAsync.hasError) {
    return AsyncValue.data(HouseholdSummary.empty());
  }

  final expenses = expensesAsync.asData?.value ?? [];
  final settlements = settlementsAsync.asData?.value ?? [];
  final members = membersAsync.asData?.value ?? [];
  final memberIds = members.map((m) => m.id).toList();

  final summary = ExpenseCalculationService.calculateHouseholdSummary(
    currentUserId: currentUserId,
    expenses: expenses,
    settlements: settlements,
    allMemberIds: memberIds,
  );

  return AsyncValue.data(summary);
});

/// Computed provider that returns simplified "Who Owes Whom" transactions
final simplifiedDebtsProvider =
    Provider.family<AsyncValue<List<SimplifiedDebt>>, String>((ref, householdId) {
  final balancesAsync = ref.watch(householdBalancesProvider(householdId));

  return balancesAsync.whenData((balances) {
    return ExpenseCalculationService.calculateSimplifiedSettlements(
      memberBalances: balances,
    );
  });
});

/// Computed provider for group spending analytics and category breakdowns
final groupSpendingInsightsProvider =
    Provider.family<AsyncValue<GroupSpendingInsights>, String>(
        (ref, householdId) {
  final expensesAsync = ref.watch(householdExpensesStreamProvider(householdId));
  final membersAsync = ref.watch(householdMembersStreamProvider(householdId));

  if (expensesAsync.isLoading || membersAsync.isLoading) {
    return const AsyncValue.loading();
  }

  if (expensesAsync.hasError) {
    return AsyncValue.error(
        expensesAsync.error!, expensesAsync.stackTrace ?? StackTrace.current);
  }
  if (membersAsync.hasError) {
    return AsyncValue.error(
        membersAsync.error!, membersAsync.stackTrace ?? StackTrace.current);
  }

  final expenses = expensesAsync.asData?.value ?? [];
  final members = membersAsync.asData?.value ?? [];

  final insights = ExpenseCalculationService.calculateSpendingInsights(
    expenses: expenses,
    members: members,
  );

  return AsyncValue.data(insights);
});

/// Computed provider for recent group activity timeline
final groupActivityProvider =
    Provider.family<AsyncValue<List<GroupActivityItem>>, String>(
        (ref, householdId) {
  final expensesAsync = ref.watch(householdExpensesStreamProvider(householdId));
  final settlementsAsync =
      ref.watch(householdSettlementsStreamProvider(householdId));
  final membersAsync = ref.watch(householdMembersStreamProvider(householdId));

  if (expensesAsync.isLoading ||
      settlementsAsync.isLoading ||
      membersAsync.isLoading) {
    return const AsyncValue.loading();
  }

  if (expensesAsync.hasError ||
      settlementsAsync.hasError ||
      membersAsync.hasError) {
    return const AsyncValue.data([]);
  }

  final expenses = expensesAsync.asData?.value ?? [];
  final settlements = settlementsAsync.asData?.value ?? [];
  final members = membersAsync.asData?.value ?? [];

  final activities = ExpenseCalculationService.calculateGroupActivity(
    expenses: expenses,
    settlements: settlements,
    members: members,
  );

  return AsyncValue.data(activities);
});

/// Record parameter for pairwise breakdown provider
class PairwiseQuery {
  final String householdId;
  final String otherUserId;

  const PairwiseQuery({
    required this.householdId,
    required this.otherUserId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PairwiseQuery &&
          runtimeType == other.runtimeType &&
          householdId == other.householdId &&
          otherUserId == other.otherUserId;

  @override
  int get hashCode => householdId.hashCode ^ otherUserId.hashCode;
}

/// Computed provider for itemized pairwise breakdown between current user and a selected roommate
final pairwiseBreakdownProvider =
    Provider.family<AsyncValue<PairwiseBreakdown>, PairwiseQuery>(
        (ref, query) {
  final currentUserId = ref.watch(currentUserIdProvider) ?? '';
  final expensesAsync =
      ref.watch(householdExpensesStreamProvider(query.householdId));
  final settlementsAsync =
      ref.watch(householdSettlementsStreamProvider(query.householdId));
  final membersAsync =
      ref.watch(householdMembersStreamProvider(query.householdId));

  if (expensesAsync.isLoading ||
      settlementsAsync.isLoading ||
      membersAsync.isLoading) {
    return const AsyncValue.loading();
  }

  final expenses = expensesAsync.asData?.value ?? [];
  final settlements = settlementsAsync.asData?.value ?? [];
  final members = membersAsync.asData?.value ?? [];

  final breakdown = ExpenseCalculationService.calculatePairwiseBreakdown(
    currentUserId: currentUserId,
    otherUserId: query.otherUserId,
    expenses: expenses,
    settlements: settlements,
    members: members,
  );

  return AsyncValue.data(breakdown);
});

