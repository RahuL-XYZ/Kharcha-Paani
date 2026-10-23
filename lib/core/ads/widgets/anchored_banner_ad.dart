import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../ad_helper.dart';

class AnchoredBannerAd extends StatefulWidget {
  const AnchoredBannerAd({super.key});

  @override
  State<AnchoredBannerAd> createState() => _AnchoredBannerAdState();
}

class _AnchoredBannerAdState extends State<AnchoredBannerAd> {
  BannerAd? _bannerAd;
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

  Future<void> _loadAd() async {
    if (!AdHelper.isAdsEnabled) return;

    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      debugPrint('Unable to get height of anchored banner.');
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('$ad loaded: ${ad.responseInfo}');
          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
          setState(() {
            _bannerAd = null;
            _isLoaded = false;
          });
        },
      ),
    );

    return _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AdHelper.isAdsEnabled) {
      return const SizedBox.shrink();
    }

    if (_bannerAd != null && _isLoaded) {
      return RepaintBoundary(
        child: Container(
          color: Colors.transparent,
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    }
    
    // Return empty space if ad fails to load (no irritating blank spaces)
    return const SizedBox.shrink();
  }
}
