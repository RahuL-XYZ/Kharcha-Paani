import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/analytics/presentation/monthly_analytics_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/balances/presentation/settle_up_screen.dart';
import '../../features/expenses/presentation/add_edit_expense_screen.dart';
import '../../features/expenses/presentation/expense_detail_screen.dart';
import '../../features/expenses/presentation/expense_history_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/household/presentation/create_household_screen.dart';
import '../../features/household/presentation/household_dashboard_screen.dart';
import '../../features/household/presentation/household_members_screen.dart';
import '../../features/household/presentation/invite_code_screen.dart';
import '../../features/household/presentation/join_household_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/settlements/presentation/settlement_history_screen.dart';
import 'route_names.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  bool _isAuth = false;
  bool _isLoading = true;

  RouterNotifier(this._ref) {
    _ref.listen(authStateChangesProvider, (_, next) {
      _isLoading = next.isLoading;
      _isAuth = next.asData?.value != null;
      notifyListeners();
    }, fireImmediately: true);
  }

  bool get isAuth => _isAuth;
  bool get isLoading => _isLoading;
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: notifier,
    redirect: (context, state) {
      final isAuth = notifier.isAuth;
      final isLoading = notifier.isLoading;

      final isSplash = state.matchedLocation == RouteNames.splash;
      final isAuthRoute = state.matchedLocation == RouteNames.login ||
          state.matchedLocation == RouteNames.register ||
          state.matchedLocation == RouteNames.forgotPassword;

      if (isLoading && isSplash) {
        return null; // Stay on splash while loading
      }

      if (!isAuth && !isAuthRoute && !isSplash) {
        return RouteNames.login;
      }

      if (isAuth && (isAuthRoute || isSplash)) {
        return RouteNames.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.createHousehold,
        builder: (context, state) => const CreateHouseholdScreen(),
      ),
      GoRoute(
        path: RouteNames.joinHousehold,
        builder: (context, state) => const JoinHouseholdScreen(),
      ),
      GoRoute(
        path: RouteNames.inviteCode,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return InviteCodeScreen(
            householdId: extra['householdId'] ?? '',
            householdName: extra['householdName'] ?? '',
            inviteCode: extra['inviteCode'] ?? '',
          );
        },
      ),
      GoRoute(
        path: RouteNames.householdDashboard,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return HouseholdDashboardScreen(householdId: id);
        },
      ),
      GoRoute(
        path: RouteNames.addExpense,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return AddEditExpenseScreen(householdId: id);
        },
      ),
      GoRoute(
        path: RouteNames.expenseDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          final expenseId = state.pathParameters['expenseId'] ?? '';
          return ExpenseDetailScreen(householdId: id, expenseId: expenseId);
        },
      ),
      GoRoute(
        path: RouteNames.settleUp,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return SettleUpScreen(householdId: id);
        },
      ),
      GoRoute(
        path: RouteNames.settlements,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return SettlementHistoryScreen(householdId: id);
        },
      ),
      GoRoute(
        path: RouteNames.members,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return HouseholdMembersScreen(householdId: id);
        },
      ),
      GoRoute(
        path: RouteNames.expenseHistory,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ExpenseHistoryScreen(householdId: id);
        },
      ),
      GoRoute(
        path: RouteNames.analytics,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return MonthlyAnalyticsScreen(householdId: id);
        },
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
