import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  AdManager({required this.onAdLoaded});

  late BannerAd bannerAd;
  bool isAdLoaded = false;
  var adUnit = "ca-app-pub-4854114877151545/6692115403";
  final Function(bool) onAdLoaded;

  initBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnit,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          onAdLoaded(true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          // print(error);
        },
      ),
      request: const AdRequest(),
    );
    //loads the banner ad
    bannerAd.load();
  }

  void disposeBannerAd() {
    bannerAd.dispose();
  }

  late InterstitialAd interstitialAd;
  bool isInterstitialAdLoaded = false;

  var adUnitInterstitial = "ca-app-pub-4854114877151545/5810278573";

  initInterstitialAd() {
    InterstitialAd.load(
      adUnitId: adUnitInterstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          // setState(() {
          //   isAdLoaded = true;
          // });
        },
        onAdFailedToLoad: (error) {
          interstitialAd.dispose();
        },
      ),
    );
  }
}
