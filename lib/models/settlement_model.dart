import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/currency_formatter.dart';

class SettlementModel {
  final String id;
  final String fromUser; // userId who paid the settlement
  final String toUser; // userId who received the settlement
  final double amount;
  final String createdBy;
  final DateTime createdAt;
  final String status; // 'completed'

  const SettlementModel({
    required this.id,
    required this.fromUser,
    required this.toUser,
    required this.amount,
    required this.createdBy,
    required this.createdAt,
    this.status = AppConstants.settlementCompleted,
  });

  /// Amount in integer paise (e.g. ₹500.00 -> 50000 paise)
  int get amountPaise => CurrencyFormatter.toPaise(amount);

  Map<String, dynamic> toMap() {
    return {
      'fromUser': fromUser,
      'toUser': toUser,
      'amount': amount,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status,
    };
  }

  factory SettlementModel.fromMap(String id, Map<String, dynamic> map) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      return DateTime.now();
    }

    return SettlementModel(
      id: id,
      fromUser: map['fromUser'] ?? '',
      toUser: map['toUser'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      createdBy: map['createdBy'] ?? '',
      createdAt: parseDate(map['createdAt']),
      status: map['status'] ?? AppConstants.settlementCompleted,
    );
  }

  SettlementModel copyWith({
    String? id,
    String? fromUser,
    String? toUser,
    double? amount,
    String? createdBy,
    DateTime? createdAt,
    String? status,
  }) {
    return SettlementModel(
      id: id ?? this.id,
      fromUser: fromUser ?? this.fromUser,
      toUser: toUser ?? this.toUser,
      amount: amount ?? this.amount,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}
