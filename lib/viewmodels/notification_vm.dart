import 'package:flutter/material.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

import '../models/app_user_extra_data_model.dart';

class NotificationVm extends BaseVm {
  final BuildContext context;
  NotificationVm(this.context);

  List<PeamanNotification>? get notifications =>
      context.watch<List<PeamanNotification>?>();

  // init function
  void onInit() {
    _updateNewNotification();
  }

  // update new notification count
  void _updateNewNotification() {
    final _appUser = context.read<PeamanUser>();

    if (AppUserExtraData.fromJson(_appUser.extraData).newNotifications != 0) {
      PUserProvider.updateUserData(
        uid: _appUser.uid!,
        data: {
          'new_notifications': 0,
        },
      );
    }
  }
}
