import 'package:flutter/material.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

import '../models/maat_warrior_config_model.dart';
import '../services/firebase/database/maat_warrior_provider.dart';

class FollowersFollowingVm extends BaseVm {
  final BuildContext context;
  FollowersFollowingVm(this.context);

  List<PeamanFollower>? get followers => context.watch<List<PeamanFollower>?>();
  List<PeamanFollowing>? get following =>
      context.watch<List<PeamanFollowing>?>();

  // follow user
  void followUser(
    final PeamanUser appUser,
    final PeamanUser friend,
  ) async {
    // update maat warrior points
    final _maatWarriorConfig = context.read<MaatWarriorConfig>();
    if (_maatWarriorConfig.followUserPoints > 0) {
      MaatWarriorProvider.updateMaatWarriorPoints(
        uid: appUser.uid!,
        points: _maatWarriorConfig.followUserPoints,
      );
    }
    //
    await PUserProvider.followUser(
      uid: appUser.uid!,
      friendId: friend.uid!,
    );
    await PUserProvider.acceptFollowRequest(
      uid: friend.uid!,
      friendId: appUser.uid!,
    );
  }

  // unfollow user
  void unfollowUser(
    final PeamanUser appUser,
    final PeamanUser friend,
  ) async {
    await PUserProvider.unfollowUser(
      uid: appUser.uid!,
      friendId: friend.uid!,
    );
  }
}
