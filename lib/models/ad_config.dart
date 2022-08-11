class AdConfig {
  final String bannerId;
  final String interstitialId;
  final bool logErrors;
  final bool logErrorsForAll;
  final int maxGoogleAdsPerDay;
  final double chancesToShowCustomAds;
  final int minDurationToShowAds;

  AdConfig({
    this.bannerId = '',
    this.interstitialId = '',
    this.logErrors = false,
    this.logErrorsForAll = false,
    this.maxGoogleAdsPerDay = -1,
    this.chancesToShowCustomAds = 10.0,
    this.minDurationToShowAds = 900000,
  });

  static AdConfig fromJson(final Map<String, dynamic> data) {
    return AdConfig(
      bannerId: data['banner_id'] ?? '',
      interstitialId: data['interstitial_id'] ?? '',
      logErrors: data['log_errors'] ?? false,
      logErrorsForAll: data['log_errors_for_all'] ?? false,
      maxGoogleAdsPerDay: data['max_google_ads_per_day'] ?? -1,
      chancesToShowCustomAds: double.parse(
        '${data['chances_to_show_custom_ads'] ?? 10.0}',
      ),
      minDurationToShowAds: data['min_duration_to_show_ads'] ?? 900000,
    );
  }
}
