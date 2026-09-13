import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/expense_calculation_service.dart';
import '../../expenses/providers/expense_provider.dart';

final categoryBreakdownProvider =
    Provider.family<List<CategorySpending>, String>((ref, householdId) {
  final expensesAsync = ref.watch(householdExpensesStreamProvider(householdId));
  final expenses = expensesAsync.asData?.value ?? [];
  return ExpenseCalculationService.calculateCategoryBreakdown(expenses: expenses);
});

final monthlyBreakdownProvider =
    Provider.family<List<MonthlySpending>, String>((ref, householdId) {
  final expensesAsync = ref.watch(householdExpensesStreamProvider(householdId));
  final expenses = expensesAsync.asData?.value ?? [];
  return ExpenseCalculationService.calculateMonthlyBreakdown(expenses: expenses);
});

final selectedAnalyticsMonthProvider =
    StateProvider.family<DateTime?, String>((ref, householdId) {
  return null;
});
