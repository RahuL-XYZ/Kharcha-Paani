import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Common AppBar widget used across the application.
/// In light mode, uses a clean white background with dark text.
/// In dark mode, uses the dark surface color.
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final String? titleText;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;
  final double? elevation;
  final Color? backgroundColor;

  const CommonAppBar({
    super.key,
    this.title,
    this.titleText,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.bottom,
    this.centerTitle = false,
    this.elevation,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appBarBg = backgroundColor ??
        (isDark ? AppColors.surfaceDark : Colors.white);
    final fgColor = isDark ? Colors.white : AppColors.textPrimaryLight;

    return AppBar(
      title: title ?? (titleText != null ? Text(titleText!) : null),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      bottom: bottom,
      centerTitle: centerTitle,
      elevation: elevation ?? 0,
      scrolledUnderElevation: 1,
      backgroundColor: appBarBg,
      foregroundColor: fgColor,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
      iconTheme: IconThemeData(color: fgColor),
      actionsIconTheme: IconThemeData(color: fgColor),
      titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: fgColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
