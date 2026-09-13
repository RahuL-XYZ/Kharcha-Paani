import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_constants.dart';
import '../core/errors/app_exception.dart';
import '../models/settlement_model.dart';
import '../repositories/settlement_repository.dart';

class SettlementService implements SettlementRepository {
  final FirebaseFirestore _firestore;

  SettlementService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference _getSettlementsCollection(String householdId) {
    return _firestore
        .collection(AppConstants.colHouseholds)
        .doc(householdId)
        .collection(AppConstants.colSettlements);
  }

  @override
  Stream<List<SettlementModel>> streamSettlements(String householdId) {
    return _getSettlementsCollection(householdId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => SettlementModel.fromMap(
              doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<SettlementModel?> getSettlementById(
      String householdId, String settlementId) async {
    try {
      final doc =
          await _getSettlementsCollection(householdId).doc(settlementId).get();
      if (!doc.exists) return null;
      return SettlementModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw AppException.fromFirebase(e);
    }
  }

  @override
  Future<SettlementModel> recordSettlement({
    required String householdId,
    required SettlementModel settlement,
  }) async {
    try {
      if (settlement.amount <= 0) {
        throw AppException('Settlement amount must be greater than 0.');
      }
      if (settlement.fromUser.isEmpty || settlement.toUser.isEmpty) {
        throw AppException('Please select both payer and receiver.');
      }
      if (settlement.fromUser == settlement.toUser) {
        throw AppException('Payer and receiver cannot be the same person.');
      }

      final docRef = _getSettlementsCollection(householdId).doc();
      final newSettlement = settlement.copyWith(id: docRef.id);

      await docRef.set(newSettlement.toMap());
      return newSettlement;
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException.fromFirebase(e);
    }
  }
}
