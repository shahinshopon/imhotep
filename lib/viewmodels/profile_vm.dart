import 'package:flutter/material.dart';
import 'package:imhotep/models/archived_comment_model.dart';
import 'package:imhotep/models/contest_badge_model.dart';
import 'package:imhotep/models/maat_warrior_config_model.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

import '../enums/state_type.dart';
import '../helpers/dialog_provider.dart';
import '../screens/conversation_screen.dart';
import '../services/firebase/database/maat_warrior_provider.dart';

class ProfileVm extends BaseVm {
  final BuildContext context;
  ProfileVm(this.context);

  int _followers = 0;
  bool _followed = false;

  List<PeamanSavedFeed>? get savedFeeds =>
      context.watch<List<PeamanSavedFeed>?>();
  List<ArchivedComment>? get archivedComments =>
      context.watch<List<ArchivedComment>?>();
  List<PeamanFollowing>? get followings =>
      context.watch<List<PeamanFollowing>?>();
  ContestBadge? get contestBadge => context.watch<ContestBadge?>();
  MaatWarriorConfig get maatWarriorConfig => context.watch<MaatWarriorConfig>();
  List<PeamanBlockedUser> get blockedUsers =>
      context.watch<List<PeamanBlockedUser>>();

  int get followers => _followers;
  bool get followed => _followed;

  // init function
  void onInit(
    final PeamanUser friend,
    final List<PeamanFollowing> _followings,
  ) {
    _followed = _followings.map((e) => e.uid).contains(friend.uid);
    _followers = friend.followers;
    updateStateType(StateType.idle);
  }

  // goto conversation screen
  void gotoConversationScreen(final PeamanUser friend) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConversationScreen(
          friend: friend,
        ),
      ),
    );
  }

  // follow user
  void followUser(
    final PeamanUser appUser,
    final PeamanUser friend,
  ) async {
    if (stateType == StateType.idle) {
      // update maat warrior points
      final _maatWarriorConfig = context.read<MaatWarriorConfig>();
      if (_maatWarriorConfig.followUserPoints > 0) {
        MaatWarriorProvider.updateMaatWarriorPoints(
          uid: appUser.uid!,
          points: _maatWarriorConfig.followUserPoints,
        );
      }
      //
      updateStateType(StateType.busy);
      await PUserProvider.followUser(
        uid: appUser.uid!,
        friendId: friend.uid!,
      );
      await PUserProvider.acceptFollowRequest(
        uid: friend.uid!,
        friendId: appUser.uid!,
      );
      updateStateType(StateType.idle);
      _updateFollowed(true);
      _updateFollowers(++_followers);
    }
  }

  // follow user
  void unfollowUser(
    final PeamanUser appUser,
    final PeamanUser friend,
  ) async {
    if (stateType == StateType.idle) {
      updateStateType(StateType.busy);
      await PUserProvider.unfollowUser(
        uid: appUser.uid!,
        friendId: friend.uid!,
      );
      updateStateType(StateType.idle);
      _updateFollowed(false);
      _updateFollowers(--_followers);
    }
  }

  // update value of followers
  void _updateFollowers(final int newVal) {
    if (_followers >= 0) {
      _followers = newVal;
      notifyListeners();
    }
  }

  // update value of followed
  void _updateFollowed(final bool newVal) {
    _followed = newVal;
    notifyListeners();
  }

  // block user
  void blockUser(
    final PeamanUser appUser,
    final PeamanUser friend,
  ) {
    DialogProvider(context).showAlertDialog(
      title: 'Are you sure you want to block ${friend.name} ?',
      description:
          "Doing this will prevent you from receiving any messages from this user.",
      onPressedPositiveBtn: () {
        showToast('Blocked ${friend.name}');
        PUserProvider.blockUser(
          uid: appUser.uid!,
          friendId: friend.uid!,
        );
      },
    );
  }

  // unblock user
  void unblockUser(
    final PeamanUser appUser,
    final PeamanUser friend,
  ) async {
    showToast('Unblocked ${friend.name}');
    PUserProvider.unblockUser(
      uid: appUser.uid!,
      friendId: friend.uid!,
    );
  }
}
