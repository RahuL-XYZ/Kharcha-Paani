import 'package:flutter/material.dart';
import 'app_colors.dart';

class ExpenseCategoryItem {
  final String id;
  final String label;
  final IconData icon;
  final Color color;

  const ExpenseCategoryItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
  });
}

class ExpenseCategories {
  static const String grocery = 'Grocery';
  static const String rent = 'Rent';
  static const String electricity = 'Electricity';
  static const String water = 'Water';
  static const String internet = 'Internet';
  static const String gas = 'Gas';
  static const String cleaning = 'Cleaning';
  static const String household = 'Household';
  static const String food = 'Food';
  static const String other = 'Other';

  static const List<ExpenseCategoryItem> all = [
    ExpenseCategoryItem(
      id: grocery,
      label: 'Grocery',
      icon: Icons.shopping_cart_outlined,
      color: AppColors.catGrocery,
    ),
    ExpenseCategoryItem(
      id: rent,
      label: 'Rent',
      icon: Icons.home_work_outlined,
      color: AppColors.catRent,
    ),
    ExpenseCategoryItem(
      id: electricity,
      label: 'Electricity',
      icon: Icons.bolt_outlined,
      color: AppColors.catElectricity,
    ),
    ExpenseCategoryItem(
      id: water,
      label: 'Water',
      icon: Icons.water_drop_outlined,
      color: AppColors.catWater,
    ),
    ExpenseCategoryItem(
      id: internet,
      label: 'Internet',
      icon: Icons.wifi_outlined,
      color: AppColors.catInternet,
    ),
    ExpenseCategoryItem(
      id: gas,
      label: 'Gas',
      icon: Icons.local_fire_department_outlined,
      color: AppColors.catGas,
    ),
    ExpenseCategoryItem(
      id: cleaning,
      label: 'Cleaning',
      icon: Icons.cleaning_services_outlined,
      color: AppColors.catCleaning,
    ),
    ExpenseCategoryItem(
      id: household,
      label: 'Household',
      icon: Icons.weekend_outlined,
      color: AppColors.catHousehold,
    ),
    ExpenseCategoryItem(
      id: food,
      label: 'Food & Dining',
      icon: Icons.restaurant_outlined,
      color: AppColors.catFood,
    ),
    ExpenseCategoryItem(
      id: other,
      label: 'Other',
      icon: Icons.category_outlined,
      color: AppColors.catOther,
    ),
  ];

  static ExpenseCategoryItem getById(String id) {
    return all.firstWhere(
      (cat) => cat.id.toLowerCase() == id.toLowerCase(),
      orElse: () => const ExpenseCategoryItem(
        id: other,
        label: 'Other',
        icon: Icons.category_outlined,
        color: AppColors.catOther,
      ),
    );
  }
}
