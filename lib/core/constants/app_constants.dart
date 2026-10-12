class AppConstants {
  static const String appName = 'Kharcha Paani';
  static const String appTagline = 'Simple Roommate Expense Sharing';
  static const String currencySymbol = '₹';
  static const String appIconAsset = 'assets/icon/app_icon.png';
  static const String appVersion = '1.0.0';
  static const int inviteCodeLength = 6;
  
  // Split Types
  static const String splitTypeEqual = 'equal';
  static const String splitTypeExact = 'exact';
  static const String splitTypePercentage = 'percentage';
  static const String splitTypeShares = 'shares';

  // Member Roles
  static const String roleOwner = 'owner';
  static const String roleMember = 'member';

  // Settlement Statuses
  static const String settlementCompleted = 'completed';

  // Firestore Collections
  static const String colUsers = 'users';
  static const String colHouseholds = 'households';
  static const String colMembers = 'members';
  static const String colExpenses = 'expenses';
  static const String colSettlements = 'settlements';
}
