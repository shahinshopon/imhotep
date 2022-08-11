import 'package:flutter/material.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

import '../models/maat_warrior_config_model.dart';
import '../services/firebase/database/maat_warrior_provider.dart';

class NotificationItemVm extends BaseVm {
  final BuildContext context;
  NotificationItemVm(this.context);

  List<PeamanFollowing>? get following =>
      context.watch<List<PeamanFollowing>?>();

  // follow back user
  void followBack(final String uid, final String friendId) async {
    // update maat warrior points
    final _maatWarriorConfig = context.read<MaatWarriorConfig>();
    if (_maatWarriorConfig.followUserPoints > 0) {
      MaatWarriorProvider.updateMaatWarriorPoints(
        uid: uid,
        points: _maatWarriorConfig.followUserPoints,
      );
    }
    //
    await PUserProvider.followUser(
      uid: uid,
      friendId: friendId,
    );
    await PUserProvider.acceptFollowRequest(
      uid: friendId,
      friendId: uid,
    );
  }
}
