import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_constants.dart';
import '../core/errors/app_exception.dart';
import '../models/expense_model.dart';
import '../repositories/expense_repository.dart';

class ExpenseService implements ExpenseRepository {
  final FirebaseFirestore _firestore;

  ExpenseService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference _getExpensesCollection(String householdId) {
    return _firestore
        .collection(AppConstants.colHouseholds)
        .doc(householdId)
        .collection(AppConstants.colExpenses);
  }

  @override
  Stream<List<ExpenseModel>> streamExpenses(String householdId) {
    return _getExpensesCollection(householdId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              ExpenseModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<ExpenseModel?> getExpenseById(
      String householdId, String expenseId) async {
    try {
      final doc = await _getExpensesCollection(householdId).doc(expenseId).get();
      if (!doc.exists) return null;
      return ExpenseModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw AppException.fromFirebase(e);
    }
  }

  @override
  Future<ExpenseModel> addExpense({
    required String householdId,
    required ExpenseModel expense,
  }) async {
    try {
      if (expense.title.trim().isEmpty) {
        throw AppException('Please enter an expense title.');
      }
      if (expense.amount <= 0) {
        throw AppException('Expense amount must be greater than 0.');
      }
      if (expense.participants.isEmpty) {
        throw AppException('Please select at least one participant.');
      }
      if (expense.paidBy.trim().isEmpty) {
        throw AppException('Please select who paid for this expense.');
      }

      final docRef = _getExpensesCollection(householdId).doc();
      final newExpense = expense.copyWith(id: docRef.id);

      await docRef.set(newExpense.toMap());
      return newExpense;
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException.fromFirebase(e);
    }
  }

  @override
  Future<void> updateExpense({
    required String householdId,
    required ExpenseModel expense,
  }) async {
    try {
      if (expense.title.trim().isEmpty) {
        throw AppException('Please enter an expense title.');
      }
      if (expense.amount <= 0) {
        throw AppException('Expense amount must be greater than 0.');
      }
      if (expense.participants.isEmpty) {
        throw AppException('Please select at least one participant.');
      }

      final docRef = _getExpensesCollection(householdId).doc(expense.id);
      final updated = expense.copyWith(updatedAt: DateTime.now());
      await docRef.update(updated.toMap());
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException.fromFirebase(e);
    }
  }

  @override
  Future<void> deleteExpense({
    required String householdId,
    required String expenseId,
  }) async {
    try {
      await _getExpensesCollection(householdId).doc(expenseId).delete();
    } catch (e) {
      throw AppException.fromFirebase(e);
    }
  }
}
