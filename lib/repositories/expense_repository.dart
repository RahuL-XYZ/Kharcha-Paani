import '../models/expense_model.dart';

abstract class ExpenseRepository {
  Stream<List<ExpenseModel>> streamExpenses(String householdId);
  Future<ExpenseModel?> getExpenseById(String householdId, String expenseId);
  Future<ExpenseModel> addExpense({
    required String householdId,
    required ExpenseModel expense,
  });
  Future<void> updateExpense({
    required String householdId,
    required ExpenseModel expense,
  });
  Future<void> deleteExpense({
    required String householdId,
    required String expenseId,
  });
}
