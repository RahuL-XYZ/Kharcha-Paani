import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routing/route_names.dart';
import '../../analytics/presentation/monthly_analytics_screen.dart';
import '../../auth/providers/auth_provider.dart';
import '../../balances/presentation/balances_screen.dart';
import '../../balances/presentation/settle_up_screen.dart';
import '../../balances/providers/balance_provider.dart';
import '../../expenses/presentation/add_edit_expense_screen.dart';
import '../../expenses/presentation/expense_detail_screen.dart';
import '../../expenses/presentation/expense_history_screen.dart';
import '../../expenses/providers/expense_provider.dart';
import '../../settlements/providers/settlement_provider.dart';
import '../providers/household_provider.dart';
import 'widgets/group_activity_section.dart';
import 'widgets/group_expense_list_section.dart';
import 'widgets/group_header_summary_card.dart';
import 'widgets/group_switcher_modal.dart';
import 'widgets/member_balance_list_section.dart';
import 'widgets/member_breakdown_modal.dart';
import 'widgets/spending_insights_section.dart';
import 'widgets/who_owes_whom_section.dart';
import 'package:kharcha_paani/l10n/app_localizations.dart';
import '../../../core/widgets/shimmer/skeletons/household_dashboard_shimmer.dart';
import '../../../core/widgets/shimmer/shimmer_placeholders.dart';
import '../../../core/widgets/shimmer/app_shimmer.dart';
import '../../../core/widgets/common_app_bar.dart';

class HouseholdDashboardScreen extends ConsumerStatefulWidget {
  final String householdId;

  const HouseholdDashboardScreen({
    super.key,
    required this.householdId,
  });

  @override
  ConsumerState<HouseholdDashboardScreen> createState() =>
      _HouseholdDashboardScreenState();
}

class _HouseholdDashboardScreenState
    extends ConsumerState<HouseholdDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final householdAsync =
        ref.watch(householdDetailStreamProvider(widget.householdId));

    return householdAsync.when(
      data: (household) {
        if (household == null) {
          return Scaffold(
            appBar: CommonAppBar(titleText: AppLocalizations.of(context)!.hhDashboardHouseholdTitle),
            body: Center(child: Text(AppLocalizations.of(context)!.hhDashboardHouseholdNotFound)),
          );
        }

        final List<Widget> screens = [
          _DashboardOverviewTab(
            household: household,
            onSelectTab: (idx) {
              setState(() {
                _currentIndex = idx;
              });
            },
          ),
          ExpenseHistoryScreen(householdId: widget.householdId),
          BalancesScreen(householdId: widget.householdId),
          MonthlyAnalyticsScreen(householdId: widget.householdId),
        ];

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (idx) {
              setState(() {
                _currentIndex = idx;
              });
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.dashboard_outlined),
                selectedIcon: const Icon(Icons.dashboard),
                label: AppLocalizations.of(context)!.hhDashboardTab,
              ),
              NavigationDestination(
                icon: const Icon(Icons.receipt_long_outlined),
                selectedIcon: const Icon(Icons.receipt_long),
                label: AppLocalizations.of(context)!.hhDashboardExpensesTab,
              ),
              NavigationDestination(
                icon: const Icon(Icons.account_balance_wallet_outlined),
                selectedIcon: const Icon(Icons.account_balance_wallet),
                label: AppLocalizations.of(context)!.hhDashboardBalancesTab,
              ),
              NavigationDestination(
                icon: const Icon(Icons.bar_chart_outlined),
                selectedIcon: const Icon(Icons.bar_chart),
                label: AppLocalizations.of(context)!.hhDashboardAnalyticsTab,
              ),
            ],
          ),
        );
      },
      loading: () => const HouseholdDashboardShimmer(),
      error: (err, _) => Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.hhError(''))),
        body: Center(child: Text(AppLocalizations.of(context)!.hhError(err.toString()))),
      ),
    );
  }
}

class _DashboardOverviewTab extends ConsumerWidget {
  final dynamic household;
  final ValueChanged<int> onSelectTab;

  const _DashboardOverviewTab({
    required this.household,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final householdId = household.id as String;
    final summaryAsync = ref.watch(householdSummaryProvider(householdId));
    final expensesAsync =
        ref.watch(householdExpensesStreamProvider(householdId));
    final membersAsync =
        ref.watch(householdMembersStreamProvider(householdId));
    final debtsAsync = ref.watch(simplifiedDebtsProvider(householdId));
    final balancesAsync = ref.watch(householdBalancesProvider(householdId));
    final insightsAsync = ref.watch(groupSpendingInsightsProvider(householdId));
    final activityAsync = ref.watch(groupActivityProvider(householdId));
    final currentUserId = ref.watch(currentUserIdProvider) ?? '';

    final members = membersAsync.asData?.value ?? [];
    final isOwner = household.createdBy == currentUserId;

    return Scaffold(
      appBar: CommonAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: AppLocalizations.of(context)!.hhDashboardAllGroups,
          onPressed: () => context.go(RouteNames.home),
        ),
        title: InkWell(
          onTap: () => GroupSwitcherModal.show(context, householdId),
          borderRadius: BorderRadius.circular(5),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        household.name,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.white),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.homeMemberCount(household.memberCount),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11, color: Colors.white70),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•  #${household.inviteCode}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_outlined),
            tooltip: AppLocalizations.of(context)!.hhDashboardViewMembers,
            onPressed: () {
              context.push(RouteNames.members.replaceAll(':id', householdId));
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: AppLocalizations.of(context)!.hhDashboardGroupOptions,
            onSelected: (val) async {
              if (val == 'switch') {
                GroupSwitcherModal.show(context, householdId);
              } else if (val == 'invite') {
                context.push(
                  RouteNames.inviteCode,
                  extra: {
                    'householdId': household.id,
                    'householdName': household.name,
                    'inviteCode': household.inviteCode,
                  },
                );
              } else if (val == 'leave') {
                _confirmLeave(context, ref, household.id, household.name);
              } else if (val == 'delete') {
                _confirmDelete(context, ref, household.id, household.name);
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'switch',
                child: Row(
                  children: [
                    const Icon(Icons.swap_horiz_rounded, size: 20),
                    const SizedBox(width: 12),
                    Text(AppLocalizations.of(context)!.hhDashboardSwitchGroup),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'invite',
                child: Row(
                  children: [
                    const Icon(Icons.qr_code_rounded, size: 20),
                    const SizedBox(width: 12),
                    Text(AppLocalizations.of(context)!.hhDashboardInviteFriends),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'leave',
                child: Row(
                  children: [
                    const Icon(Icons.exit_to_app_rounded, size: 20, color: AppColors.negative),
                    const SizedBox(width: 12),
                    Text(AppLocalizations.of(context)!.hhDashboardLeaveGroup, style: const TextStyle(color: AppColors.negative)),
                  ],
                ),
              ),
              if (isOwner)
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.negative),
                      const SizedBox(width: 12),
                      Text(AppLocalizations.of(context)!.hhDashboardDeleteGroup, style: const TextStyle(color: AppColors.negative)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(householdExpensesStreamProvider(householdId));
          ref.invalidate(householdMembersStreamProvider(householdId));
          ref.invalidate(householdSettlementsStreamProvider(householdId));
          ref.invalidate(householdBalancesProvider(householdId));
          ref.invalidate(householdSummaryProvider(householdId));
          ref.invalidate(simplifiedDebtsProvider(householdId));
          ref.invalidate(groupSpendingInsightsProvider(householdId));
          ref.invalidate(groupActivityProvider(householdId));
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // 1. Group Header & Your Net Balance Summary Card
            summaryAsync.when(
              data: (summary) => GroupHeaderSummaryCard(
                household: household,
                summary: summary,
                onSettleUp: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SettleUpScreen(householdId: householdId),
                    ),
                  );
                },
                onAddExpense: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AddEditExpenseScreen(householdId: householdId),
                    ),
                  );
                },
              ),
              loading: () => const AppShimmer(
                child: ShimmerCard(height: 200, borderRadius: 24),
              ),
              error: (err, _) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 24),

            // 2. Who Owes Whom / Settlement Section
            debtsAsync.when(
              data: (debts) => WhoOwesWhomSection(
                debts: debts,
                members: members,
                currentUserId: currentUserId,
                onSettleTransfer: (fromUser, toUser, amount) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SettleUpScreen(
                        householdId: householdId,
                        initialFromUser: fromUser,
                        initialToUser: toUser,
                        initialAmount: amount,
                      ),
                    ),
                  );
                },
              ),
              loading: () => const AppShimmer(
                child: ShimmerCard(height: 120, borderRadius: 20),
              ),
              error: (err, _) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 24),

            // 3. Member Balance List (with tap-to-inspect pairwise breakdown)
            balancesAsync.when(
              data: (balances) => MemberBalanceListSection(
                members: members,
                balances: balances,
                currentUserId: currentUserId,
                onTapMember: (member) {
                  MemberBreakdownModal.show(
                    context,
                    householdId: householdId,
                    member: member,
                    currentUserId: currentUserId,
                    onSettle: (fromUser, toUser, amount) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SettleUpScreen(
                            householdId: householdId,
                            initialFromUser: fromUser,
                            initialToUser: toUser,
                            initialAmount: amount,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              loading: () => const SizedBox.shrink(),
              error: (err, _) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 24),

            // 4. Spending Insights
            insightsAsync.when(
              data: (insights) => SpendingInsightsSection(
                insights: insights,
                onOpenAnalytics: () => onSelectTab(3),
              ),
              loading: () => const SizedBox.shrink(),
              error: (err, _) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 24),

            // 5. Group Expenses
            expensesAsync.when(
              data: (expenses) => GroupExpenseListSection(
                expenses: expenses,
                members: members,
                currentUserId: currentUserId,
                onViewAll: () => onSelectTab(1),
                onTapExpense: (expense) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExpenseDetailScreen(
                        householdId: householdId,
                        expenseId: expense.id,
                      ),
                    ),
                  );
                },
                onAddExpense: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AddEditExpenseScreen(householdId: householdId),
                    ),
                  );
                },
              ),
              loading: () => const AppShimmer(
                child: Column(
                  children: [
                    ExpenseTileSkeleton(),
                    SizedBox(height: 10),
                    ExpenseTileSkeleton(),
                  ],
                ),
              ),
              error: (err, _) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 24),

            // 6. Recent Group Activity
            activityAsync.when(
              data: (activities) => GroupActivitySection(
                activities: activities,
              ),
              loading: () => const SizedBox.shrink(),
              error: (err, _) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditExpenseScreen(householdId: householdId),
            ),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: Text(AppLocalizations.of(context)!.hhAddExpenseBtn),
      ),
    );
  }

  void _confirmLeave(
    BuildContext context,
    WidgetRef ref,
    String householdId,
    String name,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.hhLeaveGroupTitle),
        content: Text(
          AppLocalizations.of(context)!.hhLeaveGroupDesc(name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context)!.hhCancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref
                  .read(householdControllerProvider.notifier)
                  .leaveHousehold(householdId: householdId);
              if (success && context.mounted) {
                context.go(RouteNames.home);
              }
            },
            child: Text(AppLocalizations.of(context)!.hhLeaveBtn, style: const TextStyle(color: AppColors.negative)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String householdId,
    String name,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.hhDeleteGroupTitle),
        content: Text(
          AppLocalizations.of(context)!.hhDeleteGroupDesc(name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context)!.hhCancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref
                  .read(householdControllerProvider.notifier)
                  .deleteHousehold(householdId: householdId);
              if (success && context.mounted) {
                context.go(RouteNames.home);
              }
            },
            child: Text(AppLocalizations.of(context)!.hhDeleteBtn, style: const TextStyle(color: AppColors.negative)),
          ),
        ],
      ),
    );
  }
}

