import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kharcha_paani/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/expense_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../household/providers/household_provider.dart';
import '../providers/expense_provider.dart';
import 'add_edit_expense_screen.dart';
import 'expense_detail_screen.dart';
import 'widgets/expense_filter_dialog.dart';
import '../../../core/ads/widgets/inline_native_ad.dart';
import 'widgets/expense_list_tile.dart';
import '../../../core/ads/widgets/anchored_banner_ad.dart';

class ExpenseHistoryScreen extends ConsumerWidget {
  final String householdId;

  const ExpenseHistoryScreen({
    super.key,
    required this.householdId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredExpenses =
        ref.watch(filteredHouseholdExpensesProvider(householdId));
    final membersAsync =
        ref.watch(householdMembersStreamProvider(householdId));
    final currentUserId = ref.watch(currentUserIdProvider) ?? '';
    final filterState = ref.watch(expenseFilterProvider(householdId));
    final members = membersAsync.asData?.value ?? [];

    // Group filtered expenses by month
    final Map<String, List<ExpenseModel>> monthlyGroups = {};
    for (final exp in filteredExpenses) {
      final key =
          '${exp.date.year}-${exp.date.month.toString().padLeft(2, '0')}';
      monthlyGroups.putIfAbsent(key, () => []).add(exp);
    }

    final sortedMonths = monthlyGroups.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.expHistoryTitle),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: filterState.hasActiveFilters,
              child: const Icon(Icons.filter_list_outlined),
            ),
            tooltip: 'Filter',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => ExpenseFilterDialog(
                  householdId: householdId,
                  members: members,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      bottomNavigationBar: const AnchoredBannerAd(),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.expSearchHint,
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: filterState.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          ref
                              .read(expenseFilterProvider(householdId).notifier)
                              .update((s) => s.copyWith(searchQuery: ''));
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
              ),
              onChanged: (val) {
                ref
                    .read(expenseFilterProvider(householdId).notifier)
                    .update((s) => s.copyWith(searchQuery: val));
              },
            ),
          ),

          // Active filter chip indicators
          if (filterState.hasActiveFilters) ...[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  if (filterState.category != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Chip(
                        label: Text(AppLocalizations.of(context)!.expCatFilter(filterState.category!)),
                        deleteIcon: const Icon(Icons.close, size: 14),
                        onDeleted: () {
                          ref
                              .read(expenseFilterProvider(householdId).notifier)
                              .update((s) => s.copyWith(clearCategory: true));
                        },
                      ),
                    ),
                  if (filterState.memberId != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Chip(
                        label: Text(
                          AppLocalizations.of(context)!.expMemberFilter(members.where((m) => m.id == filterState.memberId).firstOrNull?.name ?? AppLocalizations.of(context)!.expSelected),
                        ),
                        deleteIcon: const Icon(Icons.close, size: 14),
                        onDeleted: () {
                          ref
                              .read(expenseFilterProvider(householdId).notifier)
                              .update((s) => s.copyWith(clearMember: true));
                        },
                      ),
                    ),
                  if (filterState.startDate != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Chip(
                        label: Text(AppLocalizations.of(context)!.expDateFiltered),
                        deleteIcon: const Icon(Icons.close, size: 14),
                        onDeleted: () {
                          ref
                              .read(expenseFilterProvider(householdId).notifier)
                              .update((s) => s.copyWith(clearDates: true));
                        },
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Expense List grouped by month
          Expanded(
            child: filteredExpenses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.receipt_long_outlined,
                            size: 48, color: AppColors.neutral),
                        const SizedBox(height: 12),
                        Text(
                          filterState.hasActiveFilters
                              ? AppLocalizations.of(context)!.expNoMatch
                              : AppLocalizations.of(context)!.expNoExpensesYet,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          filterState.hasActiveFilters
                              ? AppLocalizations.of(context)!.expAdjustFilters
                              : AppLocalizations.of(context)!.expTapToAdd,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    itemCount: sortedMonths.length,
                    itemBuilder: (context, index) {
                      final monthKey = sortedMonths[index];
                      final monthExpenses = monthlyGroups[monthKey] ?? [];
                      final parts = monthKey.split('-');
                      final monthDate = DateTime(
                          int.parse(parts[0]), int.parse(parts[1]));

                      final double monthTotal = monthExpenses.fold(
                          0.0, (sum, item) => sum + item.amount);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Month Header & Total
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 4),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormatter.formatMonthYear(monthDate),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.expTotalAmount(CurrencyFormatter.formatRupees(monthTotal)),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Month Expenses
                          ...monthExpenses.asMap().entries.map((entry) {
                            final i = entry.key;
                            final expense = entry.value;
                            return Column(
                              children: [
                                // Show an inline ad after every 5 expenses
                                if (i > 0 && i % 5 == 0) const InlineNativeAd(),
                                ExpenseListTile(
                                  expense: expense,
                                  members: members,
                                  currentUserId: currentUserId,
                                  onTap: () {
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
                                ),
                              ],
                            );
                          }),
                          const SizedBox(height: 12),
                        ],
                      );
                    },
                  ),
          ),
        ],
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
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.expAddTitle),
      ),
    );
  }
}
