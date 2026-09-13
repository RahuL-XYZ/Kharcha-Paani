import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_constants.dart';

class HouseholdMemberModel {
  final String id; // Matches userId
  final String name;
  final String role; // 'owner' or 'member'
  final DateTime joinedAt;
  final String? email;

  const HouseholdMemberModel({
    required this.id,
    required this.name,
    this.role = AppConstants.roleMember,
    required this.joinedAt,
    this.email,
  });

  bool get isOwner => role == AppConstants.roleOwner;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role,
      'joinedAt': Timestamp.fromDate(joinedAt),
      if (email != null) 'email': email,
    };
  }

  factory HouseholdMemberModel.fromMap(String id, Map<String, dynamic> map) {
    DateTime joinedAtDate;
    if (map['joinedAt'] is Timestamp) {
      joinedAtDate = (map['joinedAt'] as Timestamp).toDate();
    } else if (map['joinedAt'] is String) {
      joinedAtDate = DateTime.tryParse(map['joinedAt']) ?? DateTime.now();
    } else {
      joinedAtDate = DateTime.now();
    }

    return HouseholdMemberModel(
      id: id,
      name: map['name'] ?? '',
      role: map['role'] ?? AppConstants.roleMember,
      joinedAt: joinedAtDate,
      email: map['email'],
    );
  }

  HouseholdMemberModel copyWith({
    String? id,
    String? name,
    String? role,
    DateTime? joinedAt,
    String? email,
  }) {
    return HouseholdMemberModel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      email: email ?? this.email,
    );
  }
}
