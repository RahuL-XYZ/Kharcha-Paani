import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/expense_categories.dart';

class CategoryChipSelector extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const CategoryChipSelector({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 94,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: ExpenseCategories.all.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final cat = ExpenseCategories.all[index];
          final isSelected =
              cat.id.toLowerCase() == selectedCategory.toLowerCase();

          return InkWell(
            onTap: () => onSelected(cat.id),
            borderRadius: BorderRadius.circular(5),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 80,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? cat.color.withValues(alpha: 0.18)
                    : isDark
                        ? AppColors.surfaceVariantDark
                        : AppColors.surfaceVariantLight,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: isSelected
                      ? cat.color
                      : isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: cat.color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      cat.icon,
                      size: 20,
                      color: cat.color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cat.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? (isDark ? Colors.white : AppColors.textPrimaryLight)
                          : AppColors.textSecondaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
