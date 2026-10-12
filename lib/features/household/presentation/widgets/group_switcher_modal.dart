import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../models/household_model.dart';
import '../../../balances/providers/balance_provider.dart';
import '../../providers/household_provider.dart';
import '../../../../core/widgets/shimmer/app_shimmer.dart';
import '../../../../core/widgets/shimmer/shimmer_placeholders.dart';

class GroupSwitcherModal extends ConsumerWidget {
  final String currentHouseholdId;

  const GroupSwitcherModal({
    super.key,
    required this.currentHouseholdId,
  });

  static void show(BuildContext context, String currentHouseholdId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => GroupSwitcherModal(currentHouseholdId: currentHouseholdId),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'trip':
        return Icons.flight_takeoff_rounded;
      case 'friends':
        return Icons.celebration_rounded;
      case 'office':
        return Icons.work_outline_rounded;
      case 'couple':
        return Icons.favorite_border_rounded;
      case 'home':
      default:
        return Icons.home_outlined;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'trip':
        return const Color(0xFF00B8D9);
      case 'friends':
        return const Color(0xFFFF8B00);
      case 'office':
        return const Color(0xFF6554C0);
      case 'couple':
        return const Color(0xFFFF5630);
      case 'home':
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final householdsAsync = ref.watch(userHouseholdsStreamProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(height: 16),

            // Modal Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Switch Group',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      context.go(RouteNames.home);
                    },
                    icon: const Icon(Icons.grid_view_rounded, size: 16),
                    label: const Text('All Groups'),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 16),

            // Groups List
            Flexible(
              child: householdsAsync.when(
                data: (households) {
                  if (households.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('No groups found.'),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: households.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final household = households[index];
                      final isSelected = household.id == currentHouseholdId;
                      final catIcon = _getCategoryIcon(household.category);
                      final catColor = _getCategoryColor(household.category);

                      return _GroupTile(
                        household: household,
                        isSelected: isSelected,
                        catIcon: catIcon,
                        catColor: catColor,
                        onTap: () {
                          Navigator.pop(context);
                          if (!isSelected) {
                            context.pushReplacement('/household/${household.id}');
                          }
                        },
                      );
                    },
                  );
                },
                loading: () => const AppShimmer(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ShimmerCard(height: 64, borderRadius: 16),
                        SizedBox(height: 10),
                        ShimmerCard(height: 64, borderRadius: 16),
                      ],
                    ),
                  ),
                ),
                error: (err, _) => Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Error: $err'),
                ),
              ),
            ),

            const Divider(height: 16),

            // Bottom Actions: Create / Join
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        context.push(RouteNames.createHousehold);
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Create New'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        context.push(RouteNames.joinHousehold);
                      },
                      icon: const Icon(Icons.group_add_outlined, size: 18),
                      label: const Text('Join Room'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupTile extends ConsumerWidget {
  final HouseholdModel household;
  final bool isSelected;
  final IconData catIcon;
  final Color catColor;
  final VoidCallback onTap;

  const _GroupTile({
    required this.household,
    required this.isSelected,
    required this.catIcon,
    required this.catColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(householdSummaryProvider(household.id));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isSelected
          ? (isDark ? AppColors.surfaceVariantDark : AppColors.primaryLight)
          : (isDark ? AppColors.surfaceVariantDark.withValues(alpha: 0.5) : AppColors.surfaceVariantLight),
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.borderDark : AppColors.borderLight),
              width: isSelected ? 1.8 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: catColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(catIcon, color: catColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      household.name,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        fontSize: 15,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${household.memberCount} members • #${household.inviteCode}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Net status
              summaryAsync.maybeWhen(
                data: (s) {
                  final net = s.netBalancePaise;
                  if (net == 0) {
                    return isSelected
                        ? const Icon(Icons.check_circle, color: AppColors.primary, size: 20)
                        : const SizedBox.shrink();
                  }
                  final isOwed = net > 0;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isOwed ? AppColors.positiveLight : AppColors.negativeLight,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          isOwed ? '+₹${(net / 100).toStringAsFixed(0)}' : '-₹${(-net / 100).toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isOwed ? AppColors.positive : AppColors.negative,
                          ),
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                      ],
                    ],
                  );
                },
                orElse: () => isSelected
                    ? const Icon(Icons.check_circle, color: AppColors.primary, size: 20)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
