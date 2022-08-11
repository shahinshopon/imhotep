import 'package:flutter/material.dart';
import 'package:imhotep/helpers/common_helper.dart';
import 'package:imhotep/helpers/dialog_provider.dart';
import 'package:imhotep/helpers/dynamic_link_navigation_helper.dart';
import 'package:imhotep/helpers/notification_navigation_helper.dart';
import 'package:imhotep/models/app_user_extra_data_model.dart';
import 'package:imhotep/models/inapp_alert_model.dart';
import 'package:imhotep/services/firebase/dynamic_link/dynamic_link_provider.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:imhotep/widgets/inapp_alert_widgets/inapp_alert_dialog_content.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

import '../models/maat_warrior_config_model.dart';
import '../services/firebase/database/maat_warrior_provider.dart';

class HomeVm extends BaseVm {
  final BuildContext context;
  HomeVm(this.context);

  List<PeamanFeed> get allFeeds => context.watch<List<PeamanFeed>>();
  List<PeamanChat> get chats => context.watch<List<PeamanChat>?>() ?? [];

  // init function
  void onInit(final PeamanUser appUser) {
    _handlePushNotification(appUser);
    _handleDynamicLink(appUser);
    _handleMaatWarriorDialog(appUser);
    _handleInAppAlertDialog(appUser);
    _visitAppPoints(appUser);
  }

  void _handlePushNotification(final PeamanUser appUser) {
    PNotificationProvider.initializePushNotification(
      uid: appUser.uid!,
    );
    PNotificationProvider.onReceivedPushNotification(
      onPushNotification: (message) async {
        NotificationNavigationHelper(context).navigate(
          data: message.data,
        );
      },
    );
  }

  void _handleDynamicLink(final PeamanUser appUser) {
    DynamicLinkProvider.onReceivedDynamicLink(
      onReceivedLink: (uri) => DynamicLinkNavigationHelper(
        context,
      ).navigate(uri: uri),
    );
  }

  void _handleMaatWarriorDialog(final PeamanUser appUser) {
    final _appUserExtraData = AppUserExtraData.fromJson(appUser.extraData);

    if (!_appUserExtraData.notifiedMaatWarrior &&
        CommonHelper.isMaatWarrior(context)) {
      Future.delayed(Duration(milliseconds: 6000), () {
        DialogProvider(context).showBadgeDialog(
          badgeUrl: 'assets/images/maat_warrior_badge.png',
        );
        PUserProvider.updateUserData(
          uid: appUser.uid!,
          data: {'notified_maat_warrior': true},
        );
      });
    }
  }

  void _handleInAppAlertDialog(final PeamanUser appUser) {
    final _currentDate = DateTime.now();
    final _appUserExtraData = AppUserExtraData.fromJson(appUser.extraData);
    final _inAppAlert = context.read<InAppAlert?>();

    final _deactivated = _inAppAlert?.deactivated ?? false;
    final _dontShowAlert =
        _inAppAlert?.id == _appUserExtraData.dontShowInAppAlertId;
    final _expired = _inAppAlert == null
        ? true
        : _currentDate.isAfter(
            DateTime.fromMillisecondsSinceEpoch(_inAppAlert.expiresAt),
          );

    if (!_deactivated && !_dontShowAlert && !_expired) {
      Future.delayed(Duration(milliseconds: 6000), () {
        DialogProvider(context).showNormalDialog(
          widget: InAppAlertDialogContent(
            inAppAlert: _inAppAlert!,
            onDontShowAgain: (val) {
              PUserProvider.updateUserData(
                uid: appUser.uid!,
                data: {'dont_show_in_app_alert_id': val ? _inAppAlert.id : ''},
              );
            },
          ),
        );
      });
    }
  }

  void _visitAppPoints(final PeamanUser appUser) {
    // update maat warrior points
    final _maatWarriorConfig = context.read<MaatWarriorConfig>();
    if (_maatWarriorConfig.visitAppPoints > 0) {
      MaatWarriorProvider.updateMaatWarriorPoints(
        uid: appUser.uid!,
        points: _maatWarriorConfig.visitAppPoints,
      );
    }
    //
  }
}
