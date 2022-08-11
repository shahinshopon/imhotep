import 'package:imhotep/enums/subscription_type.dart';

class AppUserExtraData {
  final SubscriptionType subscriptionType;
  final int? subscriptionExpiresAt;
  final double maatWarriorPoints;
  final bool notifiedMaatWarrior;
  final int adsWatched;
  final int nextAdAt;
  final String dontShowInAppAlertId;
  final bool disabledVideo;
  final int newNotifications;

  AppUserExtraData({
    this.subscriptionType = SubscriptionType.none,
    this.subscriptionExpiresAt,
    this.maatWarriorPoints = 0,
    this.notifiedMaatWarrior = true,
    this.adsWatched = 0,
    this.nextAdAt = -1,
    this.dontShowInAppAlertId = '',
    this.disabledVideo = false,
    this.newNotifications = 0,
  });

  AppUserExtraData copyWith({
    final bool? editor,
    final SubscriptionType? subscriptionType,
    final int? subscriptionExpiresAt,
    final double? maatWarriorPoints,
    final bool? notifiedMaatWarrior,
    final int? adsWatched,
    final int? nextAdAt,
    final int? lastAdShownAt,
    final String? dontShowInAppAlertId,
    final bool? disabledVideo,
    final int? newNotifications,
  }) {
    return AppUserExtraData(
      subscriptionType: subscriptionType ?? this.subscriptionType,
      subscriptionExpiresAt:
          subscriptionExpiresAt ?? this.subscriptionExpiresAt,
      maatWarriorPoints: maatWarriorPoints ?? this.maatWarriorPoints,
      notifiedMaatWarrior: notifiedMaatWarrior ?? this.notifiedMaatWarrior,
      adsWatched: adsWatched ?? this.adsWatched,
      nextAdAt: nextAdAt ?? this.nextAdAt,
      dontShowInAppAlertId: dontShowInAppAlertId ?? this.dontShowInAppAlertId,
      disabledVideo: disabledVideo ?? this.disabledVideo,
      newNotifications: newNotifications ?? this.newNotifications,
    );
  }

  static AppUserExtraData fromJson(final Map<String, dynamic> data) {
    return AppUserExtraData(
      subscriptionType: SubscriptionType.values[data['subscription_type'] ?? 0],
      subscriptionExpiresAt: data['subscription_expires_at'],
      maatWarriorPoints: (data['maat_warrior_points'] ?? 0.0).toDouble(),
      notifiedMaatWarrior: data['notified_maat_warrior'] ?? false,
      adsWatched: data['ads_watched'] ?? 0,
      nextAdAt: data['next_ad_at'] ?? -1,
      dontShowInAppAlertId: data['dont_show_in_app_alert_id'] ?? '',
      disabledVideo: data['disabled_video'] ?? false,
      newNotifications: data['new_notifications'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final _data = {
      'subscription_type': subscriptionType.index,
      'subscription_expires_at': subscriptionExpiresAt,
      'maat_warrior_points': maatWarriorPoints,
      'notified_maat_warrior': notifiedMaatWarrior,
      'ads_watched': adsWatched,
      'next_ad_at': nextAdAt,
      'dont_show_in_app_alert_id': dontShowInAppAlertId,
      'disabled_video': disabledVideo,
      'new_notifications': newNotifications,
    };

    _data.removeWhere((key, value) => value == null);
    return _data;
  }
}
