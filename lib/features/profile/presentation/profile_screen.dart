import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kharcha_paani/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _editName(
      BuildContext context, WidgetRef ref, String currentName) async {
    final controller = TextEditingController(text: currentName);
    final formKey = GlobalKey<FormState>();

    final updated = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.profileEditName),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.profileFullName,
              hintText: AppLocalizations.of(context)!.profileNameHint,
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return AppLocalizations.of(context)!.profileNameEmptyError;
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context)!.profileCancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx, controller.text.trim());
              }
            },
            child: Text(AppLocalizations.of(context)!.profileSave),
          ),
        ],
      ),
    );

    if (updated != null && updated.isNotEmpty && context.mounted) {
      await ref
          .read(authControllerProvider.notifier)
          .updateProfile(name: updated);
      ref.invalidate(authStateChangesProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.profileUpdatedMsg),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.profileLogoutTitle),
        content: Text(AppLocalizations.of(context)!.profileLogoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppLocalizations.of(context)!.profileCancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.negative,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(AppLocalizations.of(context)!.profileLogoutTitle),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(authControllerProvider.notifier).logout();
      if (context.mounted) {
        context.go(RouteNames.login);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final themeMode = ref.watch(themeModeProvider);

    final name = currentUser?.name ?? 'User';
    final email = currentUser?.email ?? '';
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join().toUpperCase()
        : '?';

    return Scaffold(
      appBar: CommonAppBar(
        titleText: AppLocalizations.of(context)!.profileTitle,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // User Profile Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: const Color(0xFFF5B5C3),
                    foregroundColor: Colors.white,
                    child: Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          email,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _editName(context, ref, name),
                          child: Text(
                            AppLocalizations.of(context)!.profileEditName,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Appearance Section Header
          Text(
            AppLocalizations.of(context)!.profileAppearance,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),

          // Theme Selector Tile
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.palette_outlined,
                          color: AppColors.primary, size: 22),
                      const SizedBox(width: 12),
                      Text(
                        AppLocalizations.of(context)!.profileThemeMode,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SegmentedButton<ThemeMode>(
                    segments: [
                      ButtonSegment(
                        value: ThemeMode.system,
                        icon: const Icon(Icons.brightness_auto, size: 16),
                        label: Text(AppLocalizations.of(context)!.profileThemeSystem),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        icon: const Icon(Icons.light_mode_outlined, size: 16),
                        label: Text(AppLocalizations.of(context)!.profileThemeLight),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        icon: const Icon(Icons.dark_mode_outlined, size: 16),
                        label: Text(AppLocalizations.of(context)!.profileThemeDark),
                      ),
                    ],
                    selected: {themeMode},
                    onSelectionChanged: (set) {
                      ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(set.first);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Language Selector Tile
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.language_outlined,
                          color: AppColors.primary, size: 22),
                      const SizedBox(width: 12),
                      Text(
                        AppLocalizations.of(context)!.profileLanguage,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: 'en',
                        label: Text(AppLocalizations.of(context)!.profileLanguageEn),
                      ),
                      ButtonSegment(
                        value: 'hi',
                        label: Text(AppLocalizations.of(context)!.profileLanguageHi),
                      ),
                    ],
                    selected: {ref.watch(localeProvider)?.languageCode ?? 'en'},
                    onSelectionChanged: (set) {
                      ref.read(localeProvider.notifier).setLocale(Locale(set.first));
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // // About & App Info Section
          Text(
            AppLocalizations.of(context)!.profileAbout,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline, color: AppColors.secondary),
                  title: Text(AppLocalizations.of(context)!.profileAboutApp),
                  subtitle: Text(AppLocalizations.of(context)!.profileAboutSub),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: AppConstants.appName,
                      applicationVersion: AppConstants.appVersion,
                      applicationLegalese: '© 2026 Kharcha Paani. All rights reserved.',
                      applicationIcon: const AppLogo(size: 40),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.verified_outlined, color: AppColors.primary),
                  title: const Text('Version'),
                  trailing: const Text(
                    AppConstants.appVersion,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Log Out Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _confirmLogout(context, ref),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.negative,
                side: const BorderSide(color: AppColors.negative, width: 1.5),
              ),
              icon: const Icon(Icons.logout, size: 18),
              label: Text(AppLocalizations.of(context)!.profileLogoutTitle),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
