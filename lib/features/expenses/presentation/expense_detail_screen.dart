import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/expense_categories.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/expense_model.dart';
import '../../../models/household_member_model.dart';
import '../../../services/expense_calculation_service.dart';
import '../../auth/providers/auth_provider.dart';
import '../../household/providers/household_provider.dart';
import '../providers/expense_provider.dart';
import 'add_edit_expense_screen.dart';

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
        title: const Text('Delete Expense?'),
        content: Text(
          'Are you sure you want to delete "${expense.title}" of ${CurrencyFormatter.formatRupees(expense.amount)}? This will recalculate all balances.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.negative,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
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
          const SnackBar(
            content: Text('Expense deleted successfully'),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return expensesAsync.when(
      data: (expenses) {
        final expense = expenses.where((e) => e.id == expenseId).firstOrNull;
        if (expense == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Expense Details')),
            body: const Center(child: Text('Expense not found')),
          );
        }

        final cat = ExpenseCategories.getById(expense.category);
        final members = membersAsync.asData?.value ?? [];

        final payer = members.firstWhere(
          (m) => m.id == expense.paidBy,
          orElse: () => HouseholdMemberModel(
            id: expense.paidBy,
            name: 'Roommate',
            joinedAt: DateTime.now(),
          ),
        );

        final shares = ExpenseCalculationService.calculateEqualSplit(
          amountPaise: expense.amountPaise,
          participantIds: expense.participants,
        );

        final canEdit = expense.createdBy == currentUserId ||
            expense.paidBy == currentUserId;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Expense Details'),
            actions: [
              if (canEdit) ...[
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Edit',
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
                  tooltip: 'Delete',
                  onPressed: () => _confirmDelete(context, ref, expense),
                ),
              ],
              const SizedBox(width: 8),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              // Hero Receipt Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceVariantDark
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: cat.color.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(cat.icon, color: cat.color, size: 30),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      expense.title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      CurrencyFormatter.formatRupees(expense.amount),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: cat.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        cat.label,
                        style: TextStyle(
                          color: cat.color,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Paid By Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Paid by',
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text(
                          expense.paidBy == currentUserId
                              ? 'You (${payer.name})'
                              : payer.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Date Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Date',
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text(
                          DateFormatter.formatDate(expense.date),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    if (expense.notes != null &&
                        expense.notes!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Notes',
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(width: 20),
                          Flexible(
                            child: Text(
                              expense.notes!,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Split Breakdown Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Split Breakdown',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  if (expense.splitType != 'equal')
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${expense.splitType.toUpperCase()} SPLIT',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Participant share rows
              ...shares.map((share) {
                final participant = members.firstWhere(
                  (m) => m.id == share.userId,
                  orElse: () => HouseholdMemberModel(
                    id: share.userId,
                    name: 'Roommate',
                    joinedAt: DateTime.now(),
                  ),
                );

                final isMe = share.userId == currentUserId;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: isMe
                                  ? AppColors.primaryLight
                                  : isDark
                                      ? AppColors.surfaceVariantDark
                                      : Colors.grey.shade200,
                              child: Text(
                                participant.name.isNotEmpty
                                    ? participant.name[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isMe
                                      ? AppColors.primary
                                      : isDark
                                          ? Colors.white
                                          : Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              isMe
                                  ? '${participant.name} (You)'
                                  : participant.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              CurrencyFormatter.formatPaise(share.amountPaise),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            if (expense.splitType != 'equal' && expense.splitAmounts != null && expense.splitAmounts!.containsKey(share.userId))
                              Text(
                                expense.splitType == 'percentage'
                                    ? '${expense.splitAmounts![share.userId]}%'
                                    : expense.splitType == 'shares'
                                        ? '${expense.splitAmounts![share.userId]?.toInt()} shares'
                                        : 'Exact',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
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
