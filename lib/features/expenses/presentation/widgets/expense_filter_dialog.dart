import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/expense_categories.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../models/household_member_model.dart';
import '../../providers/expense_provider.dart';

class ExpenseFilterDialog extends ConsumerStatefulWidget {
  final String householdId;
  final List<HouseholdMemberModel> members;

  const ExpenseFilterDialog({
    super.key,
    required this.householdId,
    required this.members,
  });

  @override
  ConsumerState<ExpenseFilterDialog> createState() =>
      _ExpenseFilterDialogState();
}

class _ExpenseFilterDialogState extends ConsumerState<ExpenseFilterDialog> {
  String? _selectedCategory;
  String? _selectedMemberId;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final currentFilter = ref.read(expenseFilterProvider(widget.householdId));
    _selectedCategory = currentFilter.category;
    _selectedMemberId = currentFilter.memberId;
    _startDate = currentFilter.startDate;
    _endDate = currentFilter.endDate;
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Expenses'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Filter
            const Text(
              'Category',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String?>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('All Categories')),
                ...ExpenseCategories.all.map((c) => DropdownMenuItem(
                      value: c.id,
                      child: Text(c.label),
                    )),
              ],
              onChanged: (val) => setState(() => _selectedCategory = val),
            ),
            const SizedBox(height: 16),

            // Member Filter
            const Text(
              'Member',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String?>(
              initialValue: _selectedMemberId,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('All Members')),
                ...widget.members.map((m) => DropdownMenuItem(
                      value: m.id,
                      child: Text(m.name),
                    )),
              ],
              onChanged: (val) => setState(() => _selectedMemberId = val),
            ),
            const SizedBox(height: 16),

            // Date Range Filter
            const Text(
              'Date Range',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _pickDateRange,
              icon: const Icon(Icons.calendar_today_outlined, size: 16),
              label: Text(
                _startDate != null && _endDate != null
                    ? '${DateFormatter.formatShortDate(_startDate!)} - ${DateFormatter.formatShortDate(_endDate!)}'
                    : 'Select Date Range',
                style: const TextStyle(fontSize: 13),
              ),
            ),
            if (_startDate != null) ...[
              TextButton(
                onPressed: () {
                  setState(() {
                    _startDate = null;
                    _endDate = null;
                  });
                },
                child: const Text('Clear Date Range'),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(expenseFilterProvider(widget.householdId).notifier).state =
                const ExpenseFilterState();
            Navigator.pop(context);
          },
          child: const Text('Reset All'),
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(expenseFilterProvider(widget.householdId).notifier).update(
                  (s) => s.copyWith(
                    category: _selectedCategory,
                    memberId: _selectedMemberId,
                    startDate: _startDate,
                    endDate: _endDate,
                    clearCategory: _selectedCategory == null,
                    clearMember: _selectedMemberId == null,
                    clearDates: _startDate == null,
                  ),
                );
            Navigator.pop(context);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
