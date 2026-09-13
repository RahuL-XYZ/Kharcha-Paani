import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../../household/providers/household_provider.dart';
import '../../settlements/providers/settlement_provider.dart';

class SettleUpScreen extends ConsumerStatefulWidget {
  final String householdId;
  final String? initialFromUser;
  final String? initialToUser;
  final double? initialAmount;

  const SettleUpScreen({
    super.key,
    required this.householdId,
    this.initialFromUser,
    this.initialToUser,
    this.initialAmount,
  });

  @override
  ConsumerState<SettleUpScreen> createState() => _SettleUpScreenState();
}

class _SettleUpScreenState extends ConsumerState<SettleUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late String _fromUserId;
  late String _toUserId;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.initialAmount != null
          ? (widget.initialAmount! % 1 == 0
              ? widget.initialAmount!.toInt().toString()
              : widget.initialAmount!.toString())
          : '',
    );
    _fromUserId = widget.initialFromUser ?? '';
    _toUserId = widget.initialToUser ?? '';
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleSettleUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fromUserId == _toUserId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payer and receiver cannot be the same person.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final double amount = double.parse(_amountController.text.trim());

    FocusScope.of(context).unfocus();
    final success =
        await ref.read(settlementControllerProvider.notifier).recordSettlement(
              householdId: widget.householdId,
              fromUserId: _fromUserId,
              toUserId: _toUserId,
              amount: amount,
            );

    if (success && mounted) {
      ref.invalidate(
          householdSettlementsStreamProvider(widget.householdId));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settlement recorded successfully! 🎉'),
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
    final actionState = ref.watch(settlementControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Settlement'),
      ),
      body: membersAsync.when(
        data: (members) {
          if (members.length < 2) {
            return const Center(
              child: Text('Need at least 2 members to settle balances.'),
            );
          }

          if (_fromUserId.isEmpty) {
            _fromUserId = currentUserId;
          }
          if (_toUserId.isEmpty) {
            final other = members.firstWhere((m) => m.id != _fromUserId,
                orElse: () => members.first);
            _toUserId = other.id;
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Illustration & Hint
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.handshake_outlined,
                              color: AppColors.primary, size: 32),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'Record cash, UPI, or bank transfer payments made between roommates to update balances.',
                              style: TextStyle(
                                color: AppColors.primaryDark,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

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
                      const SizedBox(height: 20),
                    ],

                    // Amount input (Big numeric)
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '₹',
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IntrinsicWidth(
                            child: TextFormField(
                              controller: _amountController,
                              autofocus: widget.initialAmount == null,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              style: const TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.w800,
                              ),
                              decoration: const InputDecoration(
                                hintText: '0',
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Enter amount';
                                }
                                final n = double.tryParse(val.trim());
                                if (n == null || n <= 0) {
                                  return 'Amount must be > 0';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Payer Selector (From)
                    Text(
                      'Payer (Who paid?)',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: members.any((m) => m.id == _fromUserId)
                          ? _fromUserId
                          : members.first.id,
                      items: members.map((m) {
                        final isMe = m.id == currentUserId;
                        return DropdownMenuItem(
                          value: m.id,
                          child: Text(isMe ? '${m.name} (You)' : m.name),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _fromUserId = val);
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // Receiver Selector (To)
                    Text(
                      'Receiver (Who received?)',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: members.any((m) => m.id == _toUserId)
                          ? _toUserId
                          : members.last.id,
                      items: members.map((m) {
                        final isMe = m.id == currentUserId;
                        return DropdownMenuItem(
                          value: m.id,
                          child: Text(isMe ? '${m.name} (You)' : m.name),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _toUserId = val);
                        }
                      },
                    ),
                    const SizedBox(height: 36),

                    // Mark as Paid Button
                    ElevatedButton(
                      onPressed:
                          actionState.isLoading ? null : _handleSettleUp,
                      child: actionState.isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            )
                          : const Text('Mark as Paid'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
