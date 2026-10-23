import 'dart:io';
import 'package:flutter/foundation.dart';

class AdHelper {
  /// Master toggle to enable or disable ads throughout the entire app
  static const bool isAdsEnabled = false;

  /// Returns the Adaptive Banner Ad Unit ID
  static String get bannerAdUnitId {
    if (kDebugMode) {
      // Return Google's test ad unit ID for development to prevent account bans
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
    }
    // Return live AdMob ID for production
    return Platform.isAndroid
        ? 'ca-app-pub-4429927409060834/4125985751'
        : 'ca-app-pub-4429927409060834/4125985751'; // Update iOS ID later if needed
  }

  /// Returns the Native Advanced Ad Unit ID
  static String get nativeAdUnitId {
    if (kDebugMode) {
      // Google's test native ad unit ID
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/2247696110'
          : 'ca-app-pub-3940256099942544/3986624511';
    }
    // Return live AdMob ID for production
    return Platform.isAndroid
        ? 'ca-app-pub-4429927409060834/2435384158'
        : 'ca-app-pub-4429927409060834/2435384158'; // Update iOS ID later if needed
  }

  /// Returns the Rewarded Video Ad Unit ID
  static String get rewardedAdUnitId {
    if (kDebugMode) {
      // Google's test rewarded ad unit ID
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'ca-app-pub-3940256099942544/1712485313';
    }
    // Return live AdMob ID for production
    return Platform.isAndroid
        ? 'ca-app-pub-4429927409060834/7490515696'
        : 'ca-app-pub-4429927409060834/7490515696'; // Update iOS ID later if needed
  }
}
