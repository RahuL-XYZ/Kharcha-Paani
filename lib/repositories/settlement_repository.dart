import '../models/settlement_model.dart';

abstract class SettlementRepository {
  Stream<List<SettlementModel>> streamSettlements(String householdId);
  Future<SettlementModel?> getSettlementById(String householdId, String settlementId);
  Future<SettlementModel> recordSettlement({
    required String householdId,
    required SettlementModel settlement,
  });
}
