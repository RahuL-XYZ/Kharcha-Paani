import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/expense_categories.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/expense_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../household/providers/household_provider.dart';
import '../providers/expense_provider.dart';
import 'widgets/category_chip_selector.dart';
import 'widgets/dynamic_split_section.dart';

class AddEditExpenseScreen extends ConsumerStatefulWidget {
  final String householdId;
  final ExpenseModel? initialExpense;

  const AddEditExpenseScreen({
    super.key,
    required this.householdId,
    this.initialExpense,
  });

  @override
  ConsumerState<AddEditExpenseScreen> createState() =>
      _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends ConsumerState<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _notesController;

  late String _selectedCategory;
  late String _selectedPaidBy;
  late List<String> _selectedParticipants;
  late DateTime _selectedDate;
  String _selectedSplitType = AppConstants.splitTypeEqual;
  late Map<String, double> _customSplitValues;

  final List<String> _quickSuggestions = [
    'Grocery',
    'Milk',
    'Wi-Fi',
    'Electricity',
    'Cook / Maid',
    'Snacks & Tea',
    'Drinking Water',
    'Party & Dinner',
  ];

  @override
  void initState() {
    super.initState();
    final initial = widget.initialExpense;
    final currentUserId = ref.read(currentUserIdProvider) ?? '';

    _titleController = TextEditingController(text: initial?.title ?? '');
    _amountController = TextEditingController(
      text: initial != null ? (initial.amount % 1 == 0 ? initial.amount.toInt().toString() : initial.amount.toString()) : '',
    );
    _notesController = TextEditingController(text: initial?.notes ?? '');

    _selectedCategory = initial?.category ?? ExpenseCategories.grocery;
    _selectedPaidBy = initial?.paidBy ?? currentUserId;
    _selectedParticipants = initial?.participants != null
        ? List<String>.from(initial!.participants)
        : [];
    _selectedDate = initial?.date ?? DateTime.now();
    _selectedSplitType = initial?.splitType ?? AppConstants.splitTypeEqual;
    _customSplitValues = initial?.splitAmounts != null
        ? Map<String, double>.from(initial!.splitAmounts!)
        : {};
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedParticipants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one roommate to split with.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final double amount = double.parse(_amountController.text.trim());
    
    if (_selectedSplitType != AppConstants.splitTypeEqual) {
      double allocated = _customSplitValues.values.fold(0.0, (sum, val) => sum + val);
      if (_selectedSplitType == AppConstants.splitTypeExact) {
        if ((allocated - amount).abs() > 0.01) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Allocated amount must exactly match total amount.')),
          );
          return;
        }
      } else if (_selectedSplitType == AppConstants.splitTypePercentage) {
        if ((allocated - 100.0).abs() > 0.01) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Allocated percentage must equal 100%.')),
          );
          return;
        }
      } else if (_selectedSplitType == AppConstants.splitTypeShares) {
        if (allocated <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('At least one share must be allocated.')),
          );
          return;
        }
      }
    }

    final currentUserId = ref.read(currentUserIdProvider) ?? '';

    final expense = ExpenseModel(
      id: widget.initialExpense?.id ?? '',
      title: _titleController.text.trim(),
      amount: amount,
      category: _selectedCategory,
      paidBy: _selectedPaidBy.isNotEmpty ? _selectedPaidBy : currentUserId,
      participants: _selectedParticipants,
      splitType: _selectedSplitType,
      splitAmounts: _selectedSplitType == AppConstants.splitTypeEqual ? null : _customSplitValues,
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
      date: _selectedDate,
      createdBy: widget.initialExpense?.createdBy ?? currentUserId,
      createdAt: widget.initialExpense?.createdAt ?? DateTime.now(),
      updatedAt: widget.initialExpense != null ? DateTime.now() : null,
    );

    bool success;
    if (widget.initialExpense != null) {
      success = await ref
          .read(expenseControllerProvider.notifier)
          .updateExpense(
            householdId: widget.householdId,
            expense: expense,
          );
    } else {
      success = await ref.read(expenseControllerProvider.notifier).addExpense(
            householdId: widget.householdId,
            expense: expense,
          );
    }

    if (success && mounted) {
      ref.invalidate(householdExpensesStreamProvider(widget.householdId));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.initialExpense != null
                ? 'Expense updated successfully!'
                : 'Expense added successfully! 🎉',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync =
        ref.watch(householdMembersStreamProvider(widget.householdId));
    final currentUserId = ref.watch(currentUserIdProvider) ?? '';
    final actionState = ref.watch(expenseControllerProvider);
    final isEditing = widget.initialExpense != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Expense' : 'Add Expense'),
      ),
      body: membersAsync.when(
        data: (members) {
          if (_selectedParticipants.isEmpty && members.isNotEmpty) {
            _selectedParticipants = members.map((m) => m.id).toList();
          }
          if (_selectedPaidBy.isEmpty && members.isNotEmpty) {
            _selectedPaidBy = members.any((m) => m.id == currentUserId)
                ? currentUserId
                : members.first.id;
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                // Error message
                if (actionState.errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.negativeLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      actionState.errorMessage!,
                      style: const TextStyle(
                        color: AppColors.negative,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Amount Input (Big Hero Numeric Field)
                Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          '₹',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IntrinsicWidth(
                          child: TextFormField(
                            controller: _amountController,
                            autofocus: !isEditing,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                            ),
                            decoration: const InputDecoration(
                              hintText: '0',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Enter amount';
                              }
                              final num = double.tryParse(val.trim());
                              if (num == null || num <= 0) {
                                return 'Amount must be > 0';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title Input
                TextFormField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Expense Title',
                    hintText: 'e.g. Grocery, Electricity, Wi-Fi',
                    prefixIcon: Icon(Icons.receipt_long_outlined),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Quick suggestions
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _quickSuggestions.map((suggestion) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ActionChip(
                          label: Text(
                            suggestion,
                            style: const TextStyle(fontSize: 12),
                          ),
                          onPressed: () {
                            _titleController.text = suggestion;
                            // Auto map common category
                            if (suggestion == 'Grocery' || suggestion == 'Milk') {
                              setState(() => _selectedCategory = ExpenseCategories.grocery);
                            } else if (suggestion == 'Electricity') {
                              setState(() => _selectedCategory = ExpenseCategories.electricity);
                            } else if (suggestion == 'Wi-Fi') {
                              setState(() => _selectedCategory = ExpenseCategories.internet);
                            } else if (suggestion == 'Party & Dinner') {
                              setState(() => _selectedCategory = ExpenseCategories.food);
                            } else if (suggestion == 'Drinking Water') {
                              setState(() => _selectedCategory = ExpenseCategories.water);
                            } else if (suggestion == 'Cook / Maid') {
                              setState(() => _selectedCategory = ExpenseCategories.cleaning);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Category Selector
                Text(
                  'Category',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                CategoryChipSelector(
                  selectedCategory: _selectedCategory,
                  onSelected: (cat) {
                    setState(() {
                      _selectedCategory = cat;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Paid By Selector
                Text(
                  'Paid by',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: members.any((m) => m.id == _selectedPaidBy)
                          ? _selectedPaidBy
                          : (members.isNotEmpty ? members.first.id : null),
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: members.map((m) {
                        final isMe = m.id == currentUserId;
                        return DropdownMenuItem<String>(
                          value: m.id,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: isMe
                                    ? AppColors.primaryLight
                                    : Colors.grey.shade200,
                                child: Text(
                                  m.name.isNotEmpty ? m.name[0].toUpperCase() : '?',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isMe ? AppColors.primary : Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                isMe ? '${m.name} (You)' : m.name,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedPaidBy = val;
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Dynamic Split Section
                DynamicSplitSection(
                  members: members,
                  selectedParticipantIds: _selectedParticipants,
                  splitType: _selectedSplitType,
                  splitAmounts: _customSplitValues,
                  totalExpenseAmount: double.tryParse(_amountController.text) ?? 0.0,
                  currentUserId: currentUserId,
                  onSplitTypeChanged: (type) {
                    setState(() {
                      _selectedSplitType = type;
                    });
                  },
                  onSplitAmountsChanged: (amounts) {
                    setState(() {
                      _customSplitValues = amounts;
                    });
                  },
                  onParticipantsChanged: (list) {
                    setState(() {
                      _selectedParticipants = list;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Date Picker Tile
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  leading: const Icon(Icons.calendar_today_outlined,
                      color: AppColors.primary),
                  title: const Text(
                    'Date',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    DateFormatter.formatDate(_selectedDate),
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 16),

                // Notes (Optional)
                TextFormField(
                  controller: _notesController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Notes (Optional)',
                    hintText: 'e.g. Bought from Supermarket, Bill #48',
                    prefixIcon: Icon(Icons.notes_outlined),
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                ElevatedButton(
                  onPressed: actionState.isLoading ? null : _handleSubmit,
                  child: actionState.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(isEditing ? 'Save Changes' : 'Add Expense'),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
