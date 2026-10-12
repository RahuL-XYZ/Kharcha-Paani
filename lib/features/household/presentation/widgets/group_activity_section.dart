import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/expense_categories.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../services/expense_calculation_service.dart';

class GroupActivitySection extends StatelessWidget {
  final List<GroupActivityItem> activities;

  const GroupActivitySection({
    super.key,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (activities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(
                Icons.history_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Recent Group Activity',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Latest expenses, settlements, and member updates.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
        ),
        const SizedBox(height: 12),

        // Timeline Feed
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.take(6).length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final item = activities[index];

            IconData icon;
            Color iconColor;

            switch (item.type) {
              case GroupActivityType.expenseAdded:
                final cat = item.category != null
                    ? ExpenseCategories.getById(item.category!)
                    : null;
                icon = cat?.icon ?? Icons.receipt_long_rounded;
                iconColor = cat?.color ?? AppColors.primary;
                break;
              case GroupActivityType.settlementCompleted:
                icon = Icons.handshake_rounded;
                iconColor = AppColors.positive;
                break;
              case GroupActivityType.memberJoined:
                icon = Icons.person_add_rounded;
                iconColor = AppColors.secondary;
                break;
            }

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceVariantDark
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(icon, size: 18, color: iconColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormatter.formatRelative(item.timestamp),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  if (item.amountPaise != null)
                    Text(
                      item.description,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
