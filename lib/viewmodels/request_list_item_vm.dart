import 'package:flutter/material.dart';
import 'package:imhotep/enums/friend_request_state_type.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

import '../models/maat_warrior_config_model.dart';
import '../services/firebase/database/maat_warrior_provider.dart';

class RequestListItemVm extends BaseVm {
  final BuildContext context;
  RequestListItemVm(this.context);

  FriendRequestStateType _friendRequestStateType = FriendRequestStateType.none;
  FriendRequestStateType get friendRequestStateType => _friendRequestStateType;

  // init function
  void onInit({
    final bool acceptedRequest = false,
  }) {
    if (acceptedRequest)
      _updateFriendRequestStateType(FriendRequestStateType.accepted);
  }

  // accept follow request
  void acceptFollowRequest(final PeamanUser appUser, final PeamanUser friend) {
    PUserProvider.acceptFollowRequest(uid: appUser.uid!, friendId: friend.uid!);
    _updateFriendRequestStateType(FriendRequestStateType.accepted);
  }

  // follow back
  void followBack(final PeamanUser appUser, final PeamanUser friend) {
    // update maat warrior points
    final _maatWarriorConfig = context.read<MaatWarriorConfig>();
    if (_maatWarriorConfig.followUserPoints > 0) {
      MaatWarriorProvider.updateMaatWarriorPoints(
        uid: appUser.uid!,
        points: _maatWarriorConfig.followUserPoints,
      );
    }
    //
    PUserProvider.followBackUser(uid: appUser.uid!, friendId: friend.uid!);
    _updateFriendRequestStateType(FriendRequestStateType.followedBack);
  }

  // update value of friendRequestStateType
  void _updateFriendRequestStateType(final FriendRequestStateType newVal) {
    _friendRequestStateType = newVal;
    notifyListeners();
  }
}
