import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/household_model.dart';
import '../../../models/household_member_model.dart';
import '../../../repositories/household_repository.dart';
import '../../../services/household_service.dart';
import '../../auth/providers/auth_provider.dart';

final householdRepositoryProvider = Provider<HouseholdRepository>((ref) {
  return HouseholdService();
});

/// Streams all active households that the logged-in user belongs to
final userHouseholdsStreamProvider = StreamProvider<List<HouseholdModel>>((ref) {
  final currentUserId = ref.watch(currentUserIdProvider);
  if (currentUserId == null) return Stream.value([]);
  final repo = ref.watch(householdRepositoryProvider);
  return repo.streamUserHouseholds(currentUserId);
});

/// Streams a specific household by ID
final householdDetailStreamProvider =
    StreamProvider.family<HouseholdModel?, String>((ref, householdId) {
  final repo = ref.watch(householdRepositoryProvider);
  return repo.streamHouseholdById(householdId);
});

/// Streams all members belonging to a household
final householdMembersStreamProvider =
    StreamProvider.family<List<HouseholdMemberModel>, String>((ref, householdId) {
  final repo = ref.watch(householdRepositoryProvider);
  return repo.streamHouseholdMembers(householdId);
});

/// State notifier for household actions (create, join, remove member)
class HouseholdActionState {
  final bool isLoading;
  final String? errorMessage;
  final HouseholdModel? createdHousehold;
  final HouseholdModel? joinedHousehold;

  const HouseholdActionState({
    this.isLoading = false,
    this.errorMessage,
    this.createdHousehold,
    this.joinedHousehold,
  });
}

class HouseholdController extends StateNotifier<HouseholdActionState> {
  final HouseholdRepository _repository;
  final Ref _ref;

  HouseholdController(this._repository, this._ref)
      : super(const HouseholdActionState());

  Future<HouseholdModel?> createHousehold({
    required String name,
    String category = 'home',
    String? icon,
  }) async {
    final currentUser = _ref.read(currentUserProvider);
    if (currentUser == null) {
      state = const HouseholdActionState(errorMessage: 'User not logged in');
      return null;
    }

    state = const HouseholdActionState(isLoading: true);
    try {
      final household = await _repository.createHousehold(
        name: name,
        userId: currentUser.id,
        userName: currentUser.name,
        userEmail: currentUser.email,
        category: category,
        icon: icon,
      );
      state = HouseholdActionState(isLoading: false, createdHousehold: household);
      return household;
    } catch (e) {
      state = HouseholdActionState(isLoading: false, errorMessage: e.toString());
      return null;
    }
  }

  Future<HouseholdModel?> joinHousehold({required String inviteCode}) async {
    final currentUser = _ref.read(currentUserProvider);
    if (currentUser == null) {
      state = const HouseholdActionState(errorMessage: 'User not logged in');
      return null;
    }

    state = const HouseholdActionState(isLoading: true);
    try {
      final household = await _repository.joinHouseholdByCode(
        inviteCode: inviteCode,
        userId: currentUser.id,
        userName: currentUser.name,
        userEmail: currentUser.email,
      );
      state = HouseholdActionState(isLoading: false, joinedHousehold: household);
      return household;
    } catch (e) {
      state = HouseholdActionState(isLoading: false, errorMessage: e.toString());
      return null;
    }
  }

  Future<bool> removeMember({
    required String householdId,
    required String memberId,
  }) async {
    state = const HouseholdActionState(isLoading: true);
    try {
      await _repository.removeMember(
        householdId: householdId,
        memberId: memberId,
      );
      state = const HouseholdActionState(isLoading: false);
      return true;
    } catch (e) {
      state = HouseholdActionState(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> leaveHousehold({required String householdId}) async {
    final currentUser = _ref.read(currentUserProvider);
    if (currentUser == null) {
      state = const HouseholdActionState(errorMessage: 'User not logged in');
      return false;
    }

    state = const HouseholdActionState(isLoading: true);
    try {
      await _repository.leaveHousehold(
        householdId: householdId,
        userId: currentUser.id,
      );
      state = const HouseholdActionState(isLoading: false);
      return true;
    } catch (e) {
      state = HouseholdActionState(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deleteHousehold({required String householdId}) async {
    final currentUser = _ref.read(currentUserProvider);
    if (currentUser == null) {
      state = const HouseholdActionState(errorMessage: 'User not logged in');
      return false;
    }

    state = const HouseholdActionState(isLoading: true);
    try {
      await _repository.deleteHousehold(
        householdId: householdId,
        userId: currentUser.id,
      );
      state = const HouseholdActionState(isLoading: false);
      return true;
    } catch (e) {
      state = HouseholdActionState(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  void clearState() {
    state = const HouseholdActionState();
  }
}

final householdControllerProvider =
    StateNotifierProvider<HouseholdController, HouseholdActionState>((ref) {
  final repo = ref.watch(householdRepositoryProvider);
  return HouseholdController(repo, ref);
});
