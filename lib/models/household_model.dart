import 'package:cloud_firestore/cloud_firestore.dart';

class HouseholdModel {
  final String id;
  final String name;
  final String inviteCode;
  final String createdBy;
  final DateTime createdAt;
  final bool isActive;
  final int memberCount;
  final String category; // 'home', 'trip', 'friends', 'office', 'other'
  final String? icon;

  const HouseholdModel({
    required this.id,
    required this.name,
    required this.inviteCode,
    required this.createdBy,
    required this.createdAt,
    this.isActive = true,
    this.memberCount = 1,
    this.category = 'home',
    this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'inviteCode': inviteCode,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
      'memberCount': memberCount,
      'category': category,
      if (icon != null) 'icon': icon,
    };
  }

  factory HouseholdModel.fromMap(String id, Map<String, dynamic> map) {
    DateTime createdAtDate;
    if (map['createdAt'] is Timestamp) {
      createdAtDate = (map['createdAt'] as Timestamp).toDate();
    } else if (map['createdAt'] is String) {
      createdAtDate = DateTime.tryParse(map['createdAt']) ?? DateTime.now();
    } else {
      createdAtDate = DateTime.now();
    }

    return HouseholdModel(
      id: id,
      name: map['name'] ?? '',
      inviteCode: map['inviteCode'] ?? '',
      createdBy: map['createdBy'] ?? '',
      createdAt: createdAtDate,
      isActive: map['isActive'] ?? true,
      memberCount: map['memberCount'] ?? 1,
      category: map['category'] ?? 'home',
      icon: map['icon'],
    );
  }

  HouseholdModel copyWith({
    String? id,
    String? name,
    String? inviteCode,
    String? createdBy,
    DateTime? createdAt,
    bool? isActive,
    int? memberCount,
    String? category,
    String? icon,
  }) {
    return HouseholdModel(
      id: id ?? this.id,
      name: name ?? this.name,
      inviteCode: inviteCode ?? this.inviteCode,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      memberCount: memberCount ?? this.memberCount,
      category: category ?? this.category,
      icon: icon ?? this.icon,
    );
  }
}
