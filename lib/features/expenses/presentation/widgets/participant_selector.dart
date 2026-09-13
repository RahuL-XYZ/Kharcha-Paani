import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/household_member_model.dart';

class ParticipantSelector extends StatelessWidget {
  final List<HouseholdMemberModel> members;
  final List<String> selectedParticipantIds;
  final ValueChanged<List<String>> onChanged;
  final String currentUserId;

  const ParticipantSelector({
    super.key,
    required this.members,
    required this.selectedParticipantIds,
    required this.onChanged,
    required this.currentUserId,
  });

  void _toggleMember(String memberId) {
    final updated = List<String>.from(selectedParticipantIds);
    if (updated.contains(memberId)) {
      if (updated.length > 1) {
        updated.remove(memberId);
      }
    } else {
      updated.add(memberId);
    }
    onChanged(updated);
  }

  void _selectAll() {
    onChanged(members.map((m) => m.id).toList());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allSelected = selectedParticipantIds.length == members.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Split between (${selectedParticipantIds.length}/${members.length})',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            TextButton(
              onPressed: allSelected
                  ? () {
                      // Keep only current user selected
                      onChanged([currentUserId]);
                    }
                  : _selectAll,
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
              child: Text(allSelected ? 'Select only me' : 'Select all'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: members.map((member) {
            final isSelected = selectedParticipantIds.contains(member.id);
            final isMe = member.id == currentUserId;

            return FilterChip(
              selected: isSelected,
              showCheckmark: true,
              label: Text(
                isMe ? '${member.name} (You)' : member.name,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 13,
                  color: isSelected
                      ? AppColors.textPrimaryDark
                      : isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryDark,
                ),
              ),
              selectedColor: AppColors.primaryLight,
              checkmarkColor: AppColors.primary,
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
        ),
      ],
    );
  }
}
