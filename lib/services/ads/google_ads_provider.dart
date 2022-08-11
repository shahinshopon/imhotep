import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:imhotep/enums/subscription_type.dart';
import 'package:imhotep/models/ad_config.dart';
import 'package:imhotep/models/app_user_extra_data_model.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

class GoogleAdsProvider {
  static final _ref = Peaman.ref;

  // load interstial ad
  static void loadInterstitialAd({
    required final BuildContext context,
    final Function(Ad)? onAdLoaded,
    final Function(LoadAdError)? onAdFailedToLoad,
  }) async {
    final _currentDate = DateTime.now();
    final _adConfig = context.read<AdConfig>();
    final _appUser = context.read<PeamanUser>();
    final _appUserExtraData = AppUserExtraData.fromJson(
      _appUser.extraData,
    );
    final _nextAdDate = DateTime.fromMillisecondsSinceEpoch(
      _appUserExtraData.nextAdAt,
    );

    var _adsWatched = _appUserExtraData.adsWatched;
    if (_adsWatched >= _adConfig.maxGoogleAdsPerDay &&
        (_currentDate.isAtSameMomentAs(_nextAdDate) ||
            _currentDate.isAfter(_nextAdDate))) {
      _adsWatched = 0;
    }

    final _showAd =
        _appUserExtraData.subscriptionType == SubscriptionType.level3
            ? false
            : _adsWatched < _adConfig.maxGoogleAdsPerDay &&
                (_currentDate.isAtSameMomentAs(_nextAdDate) ||
                    _currentDate.isAfter(_nextAdDate));

    if (!_showAd) return;

    InterstitialAd.load(
      adUnitId: _adConfig.interstitialId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.show();

          PUserProvider.updateUserData(
            uid: _appUser.uid!,
            data: {'ads_watched': PeamanDatabaseHelper.fieldValueIncrement(1)},
          );
          if (_appUserExtraData.adsWatched ==
              (_adConfig.maxGoogleAdsPerDay - 1)) {
            final _newNextAdsDate = DateTime(
              _currentDate.year,
              _currentDate.month,
              _currentDate.day,
            ).add(Duration(days: 1));
            PUserProvider.updateUserData(
              uid: _appUser.uid!,
              data: {'next_ad_at': _newNextAdsDate.millisecondsSinceEpoch},
            );
          } else {
            final _newNextAdsDate = DateTime(
              _currentDate.year,
              _currentDate.month,
              _currentDate.day,
              _currentDate.hour,
              _currentDate.minute,
            ).add(Duration(
              milliseconds: _adConfig.minDurationToShowAds,
            ));
            PUserProvider.updateUserData(
              uid: _appUser.uid!,
              data: {'next_ad_at': _newNextAdsDate.millisecondsSinceEpoch},
            );
          }
          print('Succes: Loading interstitial ad');
          onAdLoaded?.call(ad);
        },
        onAdFailedToLoad: (err) {
          print(err);
          print('Error!!!: Loading interstitial ad');
          onAdFailedToLoad?.call(err);
        },
      ),
    );
  }

  // ad config from firestore
  static AdConfig _adConfigFromFirestore(final dynamic snap) {
    return AdConfig.fromJson(snap.data() ?? {});
  }

  // stream of ad config
  static Stream<AdConfig> get adConfig {
    return _ref
        .collection('configs')
        .doc('ads_config')
        .snapshots()
        .map(_adConfigFromFirestore);
  }
}
