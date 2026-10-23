import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../ad_helper.dart';

class InlineNativeAd extends StatefulWidget {
  const InlineNativeAd({super.key});

  @override
  State<InlineNativeAd> createState() => _InlineNativeAdState();
}

class _InlineNativeAdState extends State<InlineNativeAd> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;
  bool _hasAttemptedLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasAttemptedLoad) {
      _hasAttemptedLoad = true;
      _loadAd();
    }
  }

  void _loadAd() {
    if (!AdHelper.isAdsEnabled) return;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    _nativeAd = NativeAd(
      adUnitId: AdHelper.nativeAdUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _nativeAd = ad as NativeAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('NativeAd failed to load: $error');
          ad.dispose();
          setState(() {
            _nativeAd = null;
            _isLoaded = false;
          });
        },
      ),
      // Use the built-in templates to avoid writing native Kotlin/Swift code
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        mainBackgroundColor: isDark ? Colors.grey[900] : Colors.white,
        cornerRadius: 12.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          style: NativeTemplateFontStyle.bold,
          size: 16.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: isDark ? Colors.white : Colors.black,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.bold,
          size: 16.0,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: isDark ? Colors.grey[400] : Colors.grey[700],
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 14.0,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: isDark ? Colors.grey[400] : Colors.grey[700],
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 14.0,
        ),
      ),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AdHelper.isAdsEnabled) {
      return const SizedBox.shrink();
    }

    if (_nativeAd != null && _isLoaded) {
      // The NativeTemplateStyle small usually takes around 90-120px height
      return ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 320, // minimum recommended width
          minHeight: 120,
          maxHeight: 140,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: AdWidget(ad: _nativeAd!),
        ),
      );
    }
    
    // Collapse smoothly if not loaded yet or failed
    return const SizedBox.shrink();
  }
}
