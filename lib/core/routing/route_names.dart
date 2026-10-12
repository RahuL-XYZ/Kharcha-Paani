class RouteNames {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';

  static const String home = '/home';
  static const String createHousehold = '/create-household';
  static const String joinHousehold = '/join-household';
  static const String inviteCode = '/invite-code';

  static const String householdDashboard = '/household/:id';
  static const String addExpense = '/household/:id/add-expense';
  static const String editExpense = '/household/:id/edit-expense/:expenseId';
  static const String expenseDetail = '/household/:id/expense/:expenseId';
  static const String settleUp = '/household/:id/settle-up';
  static const String settlements = '/household/:id/settlements';
  static const String members = '/household/:id/members';
  static const String expenseHistory = '/household/:id/expenses';
  static const String analytics = '/household/:id/analytics';

  static const String profile = '/profile';
  static const String settings = '/settings';
}
