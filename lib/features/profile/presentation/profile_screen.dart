import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/app_logo.dart';
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
        title: const Text('Edit Name'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your name',
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Name cannot be empty';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx, controller.text.trim());
              }
            },
            child: const Text('Save'),
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
          const SnackBar(
            content: Text('Profile updated successfully!'),
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
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out of Kharcha Paani?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.negative,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Log Out'),
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
      appBar: AppBar(
        title: const Text('Profile & Settings'),
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
                    backgroundColor: AppColors.primary,
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
                          child: const Text(
                            'Edit Name',
                            style: TextStyle(
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

          // // Appearance Section Header
          // Text(
          //   'Appearance',
          //   style: Theme.of(context).textTheme.titleSmall?.copyWith(
          //         fontWeight: FontWeight.w700,
          //       ),
          // ),
          // const SizedBox(height: 8),

          // // Theme Selector Tile
          // Card(
          //   child: Padding(
          //     padding: const EdgeInsets.all(16),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Row(
          //           children: [
          //             const Icon(Icons.palette_outlined,
          //                 color: AppColors.primary, size: 22),
          //             const SizedBox(width: 12),
          //             const Text(
          //               'Theme Mode',
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w700,
          //                 fontSize: 15,
          //               ),
          //             ),
          //           ],
          //         ),
          //         const SizedBox(height: 14),
          //         SegmentedButton<ThemeMode>(
          //           segments: const [
          //             ButtonSegment(
          //               value: ThemeMode.system,
          //               icon: Icon(Icons.brightness_auto, size: 16),
          //               label: Text('System'),
          //             ),
          //             ButtonSegment(
          //               value: ThemeMode.light,
          //               icon: Icon(Icons.light_mode_outlined, size: 16),
          //               label: Text('Light'),
          //             ),
          //             ButtonSegment(
          //               value: ThemeMode.dark,
          //               icon: Icon(Icons.dark_mode_outlined, size: 16),
          //               label: Text('Dark'),
          //             ),
          //           ],
          //           selected: {themeMode},
          //           onSelectionChanged: (set) {
          //             ref
          //                 .read(themeModeProvider.notifier)
          //                 .setThemeMode(set.first);
          //           },
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 24),

          // // About & App Info Section
          Text(
            'About',
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
                  title: const Text('About Kharcha Paani'),
                  subtitle: const Text('Version 1.0.0 • Roommate Expense Sharing'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: AppConstants.appName,
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2026 Kharcha Paani. All rights reserved.',
                      applicationIcon: const AppLogo(size: 40),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.security_outlined, color: AppColors.primary),
                  title: const Text('Security & Calculations'),
                  subtitle: const Text('Integer paise precision • Zero float errors'),
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
              label: const Text('Log Out'),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
