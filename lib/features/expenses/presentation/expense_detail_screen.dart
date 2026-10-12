import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kharcha_paani/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/expense_model.dart';
import '../../../models/household_member_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../household/providers/household_provider.dart';
import '../providers/expense_provider.dart';
import 'add_edit_expense_screen.dart';
import '../../../core/widgets/shimmer/skeletons/expense_shimmers.dart';
import '../../../core/widgets/common_app_bar.dart';
import 'widgets/expense_detail_tab.dart';
import 'widgets/expense_report_tab.dart';

class ExpenseDetailScreen extends ConsumerWidget {
  final String householdId;
  final String expenseId;

  const ExpenseDetailScreen({
    super.key,
    required this.householdId,
    required this.expenseId,
  });

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    ExpenseModel expense,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.expDeleteTitle),
        content: Text(
          AppLocalizations.of(context)!.expDeleteDesc(expense.title, CurrencyFormatter.formatRupees(expense.amount)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppLocalizations.of(context)!.hhCancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.negative,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(AppLocalizations.of(context)!.hhDeleteBtn),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await ref
          .read(expenseControllerProvider.notifier)
          .deleteExpense(householdId: householdId, expenseId: expenseId);

      if (success && context.mounted) {
        ref.invalidate(householdExpensesStreamProvider(householdId));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.expDeletedSuccess),
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync =
        ref.watch(householdExpensesStreamProvider(householdId));
    final membersAsync =
        ref.watch(householdMembersStreamProvider(householdId));
    final currentUserId = ref.watch(currentUserIdProvider) ?? '';

    return expensesAsync.when(
      data: (expenses) {
        final expense = expenses.where((e) => e.id == expenseId).firstOrNull;
        if (expense == null) {
          return Scaffold(
            appBar: CommonAppBar(titleText: AppLocalizations.of(context)!.expDetailTitle),
            body: Center(child: Text(AppLocalizations.of(context)!.expNotFound)),
          );
        }

        final members = membersAsync.asData?.value ?? <HouseholdMemberModel>[];

        final canEdit = expense.createdBy == currentUserId ||
            expense.paidBy == currentUserId;

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: CommonAppBar(
              titleText: AppLocalizations.of(context)!.expDetailTitle,
              actions: [
                if (canEdit) ...[
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: AppLocalizations.of(context)!.expEditTooltip,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddEditExpenseScreen(
                            householdId: householdId,
                            initialExpense: expense,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: AppColors.negative),
                    tooltip: AppLocalizations.of(context)!.expDeleteTooltip,
                    onPressed: () => _confirmDelete(context, ref, expense),
                  ),
                ],
                const SizedBox(width: 8),
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Details'),
                  Tab(text: 'Report'),
                ],
                indicatorWeight: 3,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            body: TabBarView(
              children: [
                // ── Tab 1: Details (existing content) ──
                ExpenseDetailTab(
                  expense: expense,
                  members: members,
                  currentUserId: currentUserId,
                ),

                // ── Tab 2: Report (new donut chart) ──
                ExpenseReportTab(
                  expense: expense,
                  members: members,
                  currentUserId: currentUserId,
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.expDetailTitle)),
        body: const ExpenseDetailShimmer(),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: $err')),
      ),
    );
  }
}

