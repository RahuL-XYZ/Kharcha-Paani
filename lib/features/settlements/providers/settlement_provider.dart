import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/settlement_model.dart';
import '../../../repositories/settlement_repository.dart';
import '../../../services/settlement_service.dart';
import '../../auth/providers/auth_provider.dart';

final settlementRepositoryProvider = Provider<SettlementRepository>((ref) {
  return SettlementService();
});

/// Streams all settlements for a household
final householdSettlementsStreamProvider =
    StreamProvider.family<List<SettlementModel>, String>((ref, householdId) {
  final repo = ref.watch(settlementRepositoryProvider);
  return repo.streamSettlements(householdId);
});

class SettlementActionState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const SettlementActionState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });
}

class SettlementController extends StateNotifier<SettlementActionState> {
  final SettlementRepository _repository;
  final Ref _ref;

  SettlementController(this._repository, this._ref)
      : super(const SettlementActionState());

  Future<bool> recordSettlement({
    required String householdId,
    required String fromUserId,
    required String toUserId,
    required double amount,
  }) async {
    final currentUser = _ref.read(currentUserProvider);
    if (currentUser == null) {
      state = const SettlementActionState(errorMessage: 'User not logged in');
      return false;
    }

    state = const SettlementActionState(isLoading: true);
    try {
      final settlement = SettlementModel(
        id: '',
        fromUser: fromUserId,
        toUser: toUserId,
        amount: amount,
        createdBy: currentUser.id,
        createdAt: DateTime.now(),
      );

      await _repository.recordSettlement(
        householdId: householdId,
        settlement: settlement,
      );
      state = const SettlementActionState(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = SettlementActionState(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  void reset() {
    state = const SettlementActionState();
  }
}

final settlementControllerProvider =
    StateNotifierProvider<SettlementController, SettlementActionState>((ref) {
  final repo = ref.watch(settlementRepositoryProvider);
  return SettlementController(repo, ref);
});
