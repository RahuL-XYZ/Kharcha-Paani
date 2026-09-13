import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/expense_model.dart';
import '../../../repositories/expense_repository.dart';
import '../../../services/expense_service.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseService();
});

/// Streams all expenses for a given household ordered newest first
final householdExpensesStreamProvider =
    StreamProvider.family<List<ExpenseModel>, String>((ref, householdId) {
  final repo = ref.watch(expenseRepositoryProvider);
  return repo.streamExpenses(householdId);
});

class ExpenseFilterState {
  final String searchQuery;
  final String? category;
  final String? memberId;
  final DateTime? startDate;
  final DateTime? endDate;

  const ExpenseFilterState({
    this.searchQuery = '',
    this.category,
    this.memberId,
    this.startDate,
    this.endDate,
  });

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty ||
      category != null ||
      memberId != null ||
      startDate != null ||
      endDate != null;

  ExpenseFilterState copyWith({
    String? searchQuery,
    String? category,
    String? memberId,
    DateTime? startDate,
    DateTime? endDate,
    bool clearCategory = false,
    bool clearMember = false,
    bool clearDates = false,
  }) {
    return ExpenseFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      category: clearCategory ? null : (category ?? this.category),
      memberId: clearMember ? null : (memberId ?? this.memberId),
      startDate: clearDates ? null : (startDate ?? this.startDate),
      endDate: clearDates ? null : (endDate ?? this.endDate),
    );
  }
}

final expenseFilterProvider =
    StateProvider.family<ExpenseFilterState, String>((ref, householdId) {
  return const ExpenseFilterState();
});

/// Filtered expenses based on search, category, member, and date range
final filteredHouseholdExpensesProvider =
    Provider.family<List<ExpenseModel>, String>((ref, householdId) {
  final expensesAsync = ref.watch(householdExpensesStreamProvider(householdId));
  final filter = ref.watch(expenseFilterProvider(householdId));

  final expenses = expensesAsync.asData?.value ?? [];

  return expenses.where((exp) {
    // Search query filter
    if (filter.searchQuery.isNotEmpty) {
      final query = filter.searchQuery.toLowerCase();
      final matchesTitle = exp.title.toLowerCase().contains(query);
      final matchesNotes = exp.notes?.toLowerCase().contains(query) ?? false;
      if (!matchesTitle && !matchesNotes) return false;
    }

    // Category filter
    if (filter.category != null && exp.category != filter.category) {
      return false;
    }

    // Member filter (paid by or participant)
    if (filter.memberId != null) {
      final isPayer = exp.paidBy == filter.memberId;
      final isParticipant = exp.participants.contains(filter.memberId);
      if (!isPayer && !isParticipant) return false;
    }

    // Date range filter
    if (filter.startDate != null) {
      final start = DateTime(
          filter.startDate!.year, filter.startDate!.month, filter.startDate!.day);
      if (exp.date.isBefore(start)) return false;
    }
    if (filter.endDate != null) {
      final end = DateTime(filter.endDate!.year, filter.endDate!.month,
          filter.endDate!.day, 23, 59, 59);
      if (exp.date.isAfter(end)) return false;
    }

    return true;
  }).toList();
});

class ExpenseActionState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const ExpenseActionState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });
}

class ExpenseController extends StateNotifier<ExpenseActionState> {
  final ExpenseRepository _repository;

  ExpenseController(this._repository) : super(const ExpenseActionState());

  Future<bool> addExpense({
    required String householdId,
    required ExpenseModel expense,
  }) async {
    state = const ExpenseActionState(isLoading: true);
    try {
      await _repository.addExpense(
        householdId: householdId,
        expense: expense,
      );
      state = const ExpenseActionState(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = ExpenseActionState(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> updateExpense({
    required String householdId,
    required ExpenseModel expense,
  }) async {
    state = const ExpenseActionState(isLoading: true);
    try {
      await _repository.updateExpense(
        householdId: householdId,
        expense: expense,
      );
      state = const ExpenseActionState(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = ExpenseActionState(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deleteExpense({
    required String householdId,
    required String expenseId,
  }) async {
    state = const ExpenseActionState(isLoading: true);
    try {
      await _repository.deleteExpense(
        householdId: householdId,
        expenseId: expenseId,
      );
      state = const ExpenseActionState(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = ExpenseActionState(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  void reset() {
    state = const ExpenseActionState();
  }
}

final expenseControllerProvider =
    StateNotifierProvider<ExpenseController, ExpenseActionState>((ref) {
  final repo = ref.watch(expenseRepositoryProvider);
  return ExpenseController(repo);
});
