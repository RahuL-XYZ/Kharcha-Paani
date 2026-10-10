import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kharcha_paani/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../models/household_member_model.dart';

class DynamicSplitSection extends StatefulWidget {
  final List<HouseholdMemberModel> members;
  final List<String> selectedParticipantIds;
  final String splitType;
  final Map<String, double> splitAmounts;
  final double totalExpenseAmount;
  final String currentUserId;
  final ValueChanged<String> onSplitTypeChanged;
  final ValueChanged<Map<String, double>> onSplitAmountsChanged;
  final ValueChanged<List<String>> onParticipantsChanged;

  const DynamicSplitSection({
    super.key,
    required this.members,
    required this.selectedParticipantIds,
    required this.splitType,
    required this.splitAmounts,
    required this.totalExpenseAmount,
    required this.currentUserId,
    required this.onSplitTypeChanged,
    required this.onSplitAmountsChanged,
    required this.onParticipantsChanged,
  });

  @override
  State<DynamicSplitSection> createState() => _DynamicSplitSectionState();
}

class _DynamicSplitSectionState extends State<DynamicSplitSection> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    for (final id in widget.selectedParticipantIds) {
      final value = widget.splitAmounts[id] ?? 0.0;
      _controllers[id] = TextEditingController(
        text: value == 0.0 ? '' : (value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1)),
      );
    }
  }

  @override
  void didUpdateWidget(DynamicSplitSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    for (final id in widget.selectedParticipantIds) {
      final value = widget.splitAmounts[id] ?? 0.0;
      final newText = value == 0.0 ? '' : (value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1));
      
      if (!_controllers.containsKey(id)) {
        _controllers[id] = TextEditingController(text: newText);
      } else {
        if (_controllers[id]!.text != newText && double.tryParse(_controllers[id]!.text) != value) {
          _controllers[id]!.text = newText;
        }
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _toggleMember(String memberId) {
    final updated = List<String>.from(widget.selectedParticipantIds);
    if (updated.contains(memberId)) {
      if (updated.length > 1) {
        updated.remove(memberId);
      }
    } else {
      updated.add(memberId);
    }
    
    final newSplitAmounts = Map<String, double>.from(widget.splitAmounts);
    newSplitAmounts.removeWhere((key, _) => !updated.contains(key));
    
    if (widget.splitType != AppConstants.splitTypeEqual) {
       for (final id in updated) {
          if (!newSplitAmounts.containsKey(id)) {
            newSplitAmounts[id] = widget.splitType == AppConstants.splitTypeShares ? 1.0 : 0.0;
          }
       }
    }
    
    widget.onParticipantsChanged(updated);
    widget.onSplitAmountsChanged(newSplitAmounts);
  }

  void _selectAll() {
    final updated = widget.members.map((m) => m.id).toList();
    final newSplitAmounts = Map<String, double>.from(widget.splitAmounts);
    if (widget.splitType != AppConstants.splitTypeEqual) {
       for (final id in updated) {
          if (!newSplitAmounts.containsKey(id)) {
            newSplitAmounts[id] = widget.splitType == AppConstants.splitTypeShares ? 1.0 : 0.0;
          }
       }
    }
    widget.onParticipantsChanged(updated);
    widget.onSplitAmountsChanged(newSplitAmounts);
  }

  void _updateAmount(String userId, double value) {
    final updated = Map<String, double>.from(widget.splitAmounts);
    updated[userId] = value;
    
    // Auto-balance if there are exactly 2 participants
    if (widget.selectedParticipantIds.length == 2 && widget.splitType == AppConstants.splitTypeExact) {
      final otherUserId = widget.selectedParticipantIds.firstWhere((id) => id != userId);
      final remaining = widget.totalExpenseAmount - value;
      updated[otherUserId] = remaining > 0 ? remaining : 0.0;
    }
    
    widget.onSplitAmountsChanged(updated);
  }
  
  void _updateSplitType(String newType) {
    final newSplitAmounts = <String, double>{};
    if (newType != AppConstants.splitTypeEqual) {
      for (final id in widget.selectedParticipantIds) {
        if (newType == AppConstants.splitTypeShares) {
          newSplitAmounts[id] = 1.0;
        } else {
           newSplitAmounts[id] = widget.totalExpenseAmount / widget.selectedParticipantIds.length;
        }
      }
    }
    widget.onSplitTypeChanged(newType);
    widget.onSplitAmountsChanged(newSplitAmounts);
  }

  double _calculateTotalAllocated() {
    return widget.splitAmounts.values.fold(0.0, (sum, val) => sum + val);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SegmentedButton<String>(
            segments: <ButtonSegment<String>>[
              ButtonSegment<String>(
                value: AppConstants.splitTypeEqual,
                label: const Text('='),
                tooltip: AppLocalizations.of(context)!.expSplitEqual,
              ),
              ButtonSegment<String>(
                value: AppConstants.splitTypeExact,
                label: const Text('₹'),
                tooltip: AppLocalizations.of(context)!.expSplitExact,
              ),
              ButtonSegment<String>(
                value: AppConstants.splitTypeShares,
                label: const Text('⚖️'),
                tooltip: AppLocalizations.of(context)!.expSplitShares,
              ),
            ],
            selected: {widget.splitType},
            onSelectionChanged: (set) {
              if (set.isNotEmpty) {
                 _updateSplitType(set.first);
              }
            },
            style: SegmentedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.expSplitBetween(widget.selectedParticipantIds.length, widget.members.length),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            if (widget.splitType == AppConstants.splitTypeEqual)
              TextButton(
                onPressed: widget.selectedParticipantIds.length == widget.members.length
                    ? () {
                        widget.onParticipantsChanged([widget.currentUserId]);
                      }
                    : _selectAll,
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
                child: Text(widget.selectedParticipantIds.length == widget.members.length ? AppLocalizations.of(context)!.expSelectOnlyMe : AppLocalizations.of(context)!.expSelectAll),
              ),
          ],
        ),
        const SizedBox(height: 8),

        if (widget.splitType == AppConstants.splitTypeEqual)
          _buildEqualSplitView(isDark)
        else
          _buildDynamicSplitView(isDark),
      ],
    );
  }

  Widget _buildEqualSplitView(bool isDark) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.members.map((member) {
        final isSelected = widget.selectedParticipantIds.contains(member.id);
        final isMe = member.id == widget.currentUserId;

        return FilterChip(
          selected: isSelected,
          showCheckmark: true,
          label: Text(
            isMe ? '${member.name} ${AppLocalizations.of(context)!.expYouSuffix}' : member.name,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13,
              color: isSelected
                  ? AppColors.onPrimary // Dark slate text on light lime background
                  : isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
            ),
          ),
          selectedColor: AppColors.primaryLight,
          checkmarkColor: AppColors.onPrimary, // Also change checkmark to match text
          backgroundColor: isDark
              ? AppColors.surfaceVariantDark
              : AppColors.surfaceVariantLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: isSelected
                  ? AppColors.primary
                  : isDark
                      ? AppColors.borderDark
                      : AppColors.borderLight,
            ),
          ),
          onSelected: (_) => _toggleMember(member.id),
        );
      }).toList(),
    );
  }

  Widget _buildDynamicSplitView(bool isDark) {
    double allocated = _calculateTotalAllocated();
    bool isValid = false;
    String statusText = '';
    
    if (widget.splitType == AppConstants.splitTypeExact) {
       isValid = (allocated - widget.totalExpenseAmount).abs() < 0.01;
       double remaining = widget.totalExpenseAmount - allocated;
       if (isValid) {
          statusText = AppLocalizations.of(context)!.expAllocFully(widget.totalExpenseAmount.toStringAsFixed(2));
       } else if (remaining > 0) {
          statusText = AppLocalizations.of(context)!.expAllocRemaining(remaining.toStringAsFixed(2));
       } else {
          statusText = AppLocalizations.of(context)!.expAllocOver(remaining.abs().toStringAsFixed(2));
       }
     } else if (widget.splitType == AppConstants.splitTypeShares) {
       isValid = allocated > 0;
       statusText = AppLocalizations.of(context)!.expAllocShares(allocated.toInt());
    }

    final activeMembers = widget.members.where((m) => widget.selectedParticipantIds.contains(m.id)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isValid ? AppColors.primary.withValues(alpha: 0.1) : AppColors.negativeLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isValid ? AppColors.primary : AppColors.negative,
              width: 1,
            )
          ),
          child: Text(
            statusText,
            style: TextStyle(
              color: isValid ? (isDark ? AppColors.primaryLight : AppColors.primaryDark) : AppColors.negative,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        
        ...activeMembers.map((member) {
          final isMe = member.id == widget.currentUserId;
          final value = widget.splitAmounts[member.id] ?? 0.0;
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: isMe
                      ? AppColors.primaryLight
                      : isDark
                          ? AppColors.surfaceVariantDark
                          : Colors.grey.shade200,
                  child: Text(
                    member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
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
                Expanded(
                  child: Text(
                    isMe ? '${member.name} ${AppLocalizations.of(context)!.expYouSuffix}' : member.name,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                _buildInputControls(member.id, value),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildInputControls(String userId, double value) {
    if (widget.splitType == AppConstants.splitTypeShares) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            visualDensity: VisualDensity.compact,
            color: value > 0 ? AppColors.primary : Colors.grey,
            onPressed: value > 0 ? () => _updateAmount(userId, value - 1) : null,
          ),
          SizedBox(
            width: 24,
            child: Text(
              value.toInt().toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            visualDensity: VisualDensity.compact,
            color: AppColors.primary,
            onPressed: () => _updateAmount(userId, value + 1),
          ),
        ],
      );
    }
    
    return SizedBox(
      width: 100,
      child: TextFormField(
        controller: _controllers[userId],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          prefixText: widget.splitType == AppConstants.splitTypeExact ? '₹ ' : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onChanged: (val) {
          final parsed = double.tryParse(val) ?? 0.0;
          _updateAmount(userId, parsed);
        },
      ),
    );
  }
}
