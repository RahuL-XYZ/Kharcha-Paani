import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kharcha_paani/l10n/app_localizations.dart';
import 'core/constants/app_constants.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kharcha_paani/l10n/app_localizations.dart';
import 'core/localization/locale_provider.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with fallback guard
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization notice: $e');
  }

  // Initialize Google Mobile Ads SDK
  try {
    await MobileAds.instance.initialize();
  } catch (e) {
    debugPrint('MobileAds initialization error: $e');
  }

  runApp(
    const ProviderScope(
      child: KharchaPaaniApp(),
    ),
  );
}

class KharchaPaaniApp extends ConsumerWidget {
  const KharchaPaaniApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildTheme(
        brightness: Brightness.light,
      ),
      darkTheme: AppTheme.buildTheme(
        brightness: Brightness.dark,
      ),
      themeMode: themeMode,
      locale: locale,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
