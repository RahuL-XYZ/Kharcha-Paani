import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kharcha_paani/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/route_names.dart';

class EmptyHouseholdView extends StatelessWidget {
  const EmptyHouseholdView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.home_work_outlined,
                size: 54,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              AppLocalizations.of(context)!.homeNoHouseholdsTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.homeNoHouseholdsDesc,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.push(RouteNames.createHousehold),
                icon: const Icon(Icons.add_home_outlined),
                label: Text(AppLocalizations.of(context)!.homeCreateHouseholdBtn),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.push(RouteNames.joinHousehold),
                icon: const Icon(Icons.group_add_outlined),
                label: Text(AppLocalizations.of(context)!.homeJoinHouseholdBtn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
