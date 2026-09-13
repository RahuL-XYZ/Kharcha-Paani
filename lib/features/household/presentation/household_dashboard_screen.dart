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
import 'household_members_screen.dart';
import 'widgets/group_activity_section.dart';
import 'widgets/group_expense_list_section.dart';
import 'widgets/group_header_summary_card.dart';
import 'widgets/group_switcher_modal.dart';
import 'widgets/member_balance_list_section.dart';
import 'widgets/member_breakdown_modal.dart';
import 'widgets/spending_insights_section.dart';
import 'widgets/who_owes_whom_section.dart';

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
            appBar: AppBar(title: const Text('Household')),
            body: const Center(child: Text('Household not found.')),
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
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long),
                label: 'Expenses',
              ),
              NavigationDestination(
                icon: Icon(Icons.account_balance_wallet_outlined),
                selectedIcon: Icon(Icons.account_balance_wallet),
                label: 'Balances',
              ),
              NavigationDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart),
                label: 'Analytics',
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: $err')),
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'All Groups',
          onPressed: () => context.go(RouteNames.home),
        ),
        title: InkWell(
          onTap: () => GroupSwitcherModal.show(context, householdId),
          borderRadius: BorderRadius.circular(10),
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
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${household.memberCount} members',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•  #${household.inviteCode}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
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
            tooltip: 'View Members',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      HouseholdMembersScreen(householdId: householdId),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Group Options',
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
              const PopupMenuItem(
                value: 'switch',
                child: Row(
                  children: [
                    Icon(Icons.swap_horiz_rounded, size: 20),
                    SizedBox(width: 12),
                    Text('Switch Group'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'invite',
                child: Row(
                  children: [
                    Icon(Icons.qr_code_rounded, size: 20),
                    SizedBox(width: 12),
                    Text('Invite Friends'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'leave',
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app_rounded, size: 20, color: AppColors.negative),
                    SizedBox(width: 12),
                    Text('Leave Group', style: TextStyle(color: AppColors.negative)),
                  ],
                ),
              ),
              if (isOwner)
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.negative),
                      SizedBox(width: 12),
                      Text('Delete Group', style: TextStyle(color: AppColors.negative)),
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
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
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
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
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
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
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
        label: const Text('Add Expense'),
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
        title: const Text('Leave Group?'),
        content: Text(
          'Are you sure you want to leave "$name"? You will no longer have access to this group\'s expenses and balances.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
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
            child: const Text('Leave', style: TextStyle(color: AppColors.negative)),
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
        title: const Text('Delete Group?'),
        content: Text(
          'Are you sure you want to delete "$name"? This group will be archived and hidden for all members.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
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
            child: const Text('Delete', style: TextStyle(color: AppColors.negative)),
          ),
        ],
      ),
    );
  }
}
