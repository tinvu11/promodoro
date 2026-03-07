import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

import '../../../configs/di.dart';
import '../../../utils/ads/consent_manager.dart';
import 'glass_box.dart';

class BannerAdWidget extends StatefulWidget {
  final double paddingHorizontal;
  final double paddingVertical;
  final bool isPremium;

  const BannerAdWidget({
    super.key,
    this.paddingHorizontal = 0,
    required this.isPremium,
    this.paddingVertical = 0,
  });

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget>
    with AutomaticKeepAliveClientMixin {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _hasFailed = false;
  Orientation? _orientation;
  final _amplitude = DI.sl<Amplitude>();

  // final _adUnitId = Platform.isAndroid
  //     ? const String.fromEnvironment('ANDROID_BANNER_AD_UNIT_ID')
  //     : const String.fromEnvironment('IOS_BANNER_AD_UNIT_ID');
  //
  final _adUnitId = "ca-app-pub-3940256099942544/6300978111";

  @override
  void initState() {
    super.initState();
    if (!widget.isPremium) {
      _initializeAds();
    }
  }

  void _initializeAds() {
    ConsentManager.gatherConsent((consentError) {
      if (consentError != null) {
        debugPrint(
          "Consent error: ${consentError.errorCode}: ${consentError.message}",
        );
      }
      // Luôn thử load lại ad sau khi consent hoàn tất (cả success lẫn error)
      // vì lần _loadAd() đầu có thể đã fail do consent chưa sẵn sàng
      if (mounted && !_isLoaded) {
        _bannerAd?.dispose();
        _loadAd();
      }
    });
    _loadAd();
  }

  // void _loadAd() async {
  //   setState(() {
  //     _hasFailed = false;
  //     _isLoaded = false;
  //   });

  //   if (!await ConsentManager.canRequestAds()) {
  //     if (mounted) {
  //       setState(() => _hasFailed = true);
  //     }
  //     return;
  //   }
  //   if (!mounted) return;

  //   final screenWidth = MediaQuery.of(context).size.width;
  //   final adWidth = (screenWidth - widget.paddingHorizontal * 2).truncate();

  //   final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
  //     adWidth,
  //   );
  //   if (size == null) {
  //     if (mounted) {
  //       setState(() => _hasFailed = true);
  //     }
  //     return;
  //   }

  //   _bannerAd = BannerAd(
  //     adUnitId: _adUnitId,
  //     size: size,
  //     request: const AdRequest(),
  //     listener: BannerAdListener(
  //       onAdLoaded: (ad) => setState(() {
  //         debugPrint("Banner ad loaded");
  //         _bannerAd = ad as BannerAd;
  //         _isLoaded = true;
  //         _amplitude.track(BaseEvent("banner_ad_loaded"));
  //       }),
  //       onAdFailedToLoad: (ad, err) {
  //         _amplitude.track(BaseEvent("banner_ad_error"));
  //         FirebaseAnalytics.instance.logEvent(
  //           name: "banner_ad_error",
  //           parameters: {"error": err.toString()},
  //         );
  //         ad.dispose();
  //         if (mounted) {
  //           setState(() {
  //             _hasFailed = true;
  //           });
  //         }
  //       },
  //     ),
  //   )..load();
  // }
  void _loadAd() async {
    if (!mounted) return;

    // Reset trạng thái để hiện Shimmer
    setState(() {
      _hasFailed = false;
      _isLoaded = false;
    });

    // Kiểm tra quyền Consent (Cái này quan trọng hơn kiểm tra mạng)
    if (!await ConsentManager.canRequestAds()) {
      if (mounted) setState(() => _hasFailed = true);
      return;
    }

    // Tính toán kích thước (Nên để trong try-catch nếu cần)
    final screenWidth = MediaQuery.of(context).size.width;
    final adWidth = (screenWidth - widget.paddingHorizontal * 2).truncate();
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      adWidth,
    );

    if (size == null) {
      if (mounted) setState(() => _hasFailed = true);
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _isLoaded = true;
          });
          _amplitude.track(BaseEvent("banner_ad_loaded"));
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          if (mounted) {
            setState(() {
              _hasFailed =
                  true; // Dù lỗi mạng hay lỗi server thì đều coi là failed
            });
          }
          // Log lỗi để bạn theo dõi trên Firebase
          FirebaseAnalytics.instance.logEvent(
            name: "banner_ad_error",
            parameters: {
              "error": err.message,
            }, // err.message rõ nghĩa hơn err.toString()
          );
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.isPremium || _hasFailed) {
      return const SizedBox.shrink();
    }

    if (_bannerAd == null || !_isLoaded) {
      return _buildShimmerPlaceholder();
    }

    final adWidth = _bannerAd!.size.width.toDouble();
    final adHeight = _bannerAd!.size.height.toDouble();

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: widget.paddingVertical,
        horizontal: widget.paddingHorizontal,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GlassBox(
            borderRadius: 12,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ad label
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(11),
                      topRight: Radius.circular(11),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 12,
                        color: Colors.white.withOpacity(0.4),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Sponsored',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.4),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                // Banner ad
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(11),
                    bottomRight: Radius.circular(11),
                  ),
                  child: SizedBox(
                    width: adWidth,
                    height: adHeight,
                    child: AdWidget(ad: _bannerAd!),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newOrientation = MediaQuery.of(context).orientation;
    if (_orientation != newOrientation) {
      if (_orientation != null) {
        _bannerAd?.dispose();
        _loadAd();
      }
      _orientation = newOrientation;
    }
  }

  Widget _buildShimmerPlaceholder() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: widget.paddingVertical,
        horizontal: widget.paddingHorizontal,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.white.withOpacity(0.25),
        highlightColor: Colors.white.withOpacity(0.35),
        child: Container(
          // Bạn nên ước lượng chiều cao trung bình của banner (thường là 50-60dp)
          // Hoặc nếu đã tính được adHeight từ bước _loadAd thì dùng luôn
          height: 0,
          decoration: BoxDecoration(
            color: Colors.black, // Màu nền của shimmer
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
