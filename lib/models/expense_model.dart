import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/currency_formatter.dart';

class ExpenseModel {
  final String id;
  final String title;
  final double amount;
  final String category;
  final String paidBy; // userId of payer
  final List<String> participants; // List of userIds sharing the expense
  final String splitType; // 'equal', 'exact', 'percentage', 'shares'
  final Map<String, double>? splitAmounts; // Custom share amounts in rupees per participant userId
  final String? notes;
  final DateTime date;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.paidBy,
    required this.participants,
    this.splitType = AppConstants.splitTypeEqual,
    this.splitAmounts,
    this.notes,
    required this.date,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
  });

  /// Amount in integer paise (e.g. ₹100.50 -> 10050 paise)
  int get amountPaise => CurrencyFormatter.toPaise(amount);

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'paidBy': paidBy,
      'participants': participants,
      'splitType': splitType,
      if (splitAmounts != null) 'splitAmounts': splitAmounts,
      'notes': notes,
      'date': Timestamp.fromDate(date),
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  factory ExpenseModel.fromMap(String id, Map<String, dynamic> map) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      return DateTime.now();
    }

    Map<String, double>? parseSplitAmounts(dynamic val) {
      if (val is Map) {
        return val.map((k, v) => MapEntry(k.toString(), (v as num).toDouble()));
      }
      return null;
    }

    return ExpenseModel(
      id: id,
      title: map['title'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      category: map['category'] ?? 'Other',
      paidBy: map['paidBy'] ?? '',
      participants: (map['participants'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      splitType: map['splitType'] ?? AppConstants.splitTypeEqual,
      splitAmounts: parseSplitAmounts(map['splitAmounts']),
      notes: map['notes'],
      date: parseDate(map['date']),
      createdBy: map['createdBy'] ?? '',
      createdAt: parseDate(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? parseDate(map['updatedAt']) : null,
    );
  }

  ExpenseModel copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    String? paidBy,
    List<String>? participants,
    String? splitType,
    Map<String, double>? splitAmounts,
    String? notes,
    DateTime? date,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      paidBy: paidBy ?? this.paidBy,
      participants: participants ?? this.participants,
      splitType: splitType ?? this.splitType,
      splitAmounts: splitAmounts ?? this.splitAmounts,
      notes: notes ?? this.notes,
      date: date ?? this.date,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
