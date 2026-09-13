import '../models/household_model.dart';
import '../models/household_member_model.dart';

abstract class HouseholdRepository {
  Stream<List<HouseholdModel>> streamUserHouseholds(String userId);
  Future<HouseholdModel?> getHouseholdById(String householdId);
  Stream<HouseholdModel?> streamHouseholdById(String householdId);
  Future<HouseholdModel> createHousehold({
    required String name,
    required String userId,
    required String userName,
    String? userEmail,
    String category = 'home',
    String? icon,
  });
  Future<HouseholdModel> joinHouseholdByCode({
    required String inviteCode,
    required String userId,
    required String userName,
    String? userEmail,
  });
  Stream<List<HouseholdMemberModel>> streamHouseholdMembers(String householdId);
  Future<List<HouseholdMemberModel>> getHouseholdMembers(String householdId);
  Future<void> removeMember({
    required String householdId,
    required String memberId,
  });
  Future<void> leaveHousehold({
    required String householdId,
    required String userId,
  });
  Future<void> deleteHousehold({
    required String householdId,
    required String userId,
  });
}
