import 'package:imhotep/helpers/common_helper.dart';
import 'package:imhotep/models/custom_ad_model.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:flutter/material.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

import '../enums/state_type.dart';
import '../models/maat_warrior_config_model.dart';
import '../services/firebase/database/maat_warrior_provider.dart';

class FeedItemVm extends BaseVm {
  final BuildContext context;
  FeedItemVm(this.context);

  int _views = 0;
  late PeamanFeed _feed;
  CustomAd? _randomAd;

  int get views => _views;
  PeamanFeed get feed => _feed;
  CustomAd? get randomAd => _randomAd;

  // init function
  void onInit({
    required final PeamanFeed thisFeed,
    required final PeamanUser appUser,
    final bool requiredAds = true,
  }) async {
    updateStateType(StateType.busy);
    final _reactionFuture = PFeedProvider.getReactionByOwnerId(
      feedId: thisFeed.id!,
      ownerId: appUser.uid!,
      parent: PeamanReactionParent.feed,
      parentId: thisFeed.id!,
    );
    final _feedSaverFuture = PFeedProvider.getFeedSaverByUid(
      feedId: thisFeed.id!,
      uid: appUser.uid!,
    );
    final _feedViewerFuture = PFeedProvider.getFeedViewerByUid(
      feedId: thisFeed.id!,
      uid: appUser.uid!,
    );

    final _result = await Future.wait([
      _reactionFuture,
      _feedSaverFuture,
      _feedViewerFuture,
    ]);
    final _liked =
        _result.first != null && !(_result.first as PeamanReaction).unreacted;
    final _saved = _result[1] != null;
    final _viewed = _result[2] != null;

    final _myReactionId =
        _result.first == null ? null : (_result.first as PeamanReaction).id;

    _feed = thisFeed.copyWith(extraData: {
      ...thisFeed.extraData,
      'liked': _liked,
      'saved': _saved,
      'viewed': _viewed,
      'like_reaction_id': _myReactionId,
    });

    if (requiredAds) {
      _randomAd = CommonHelper.getRandomCustomAd(
        context: context,
      );
    }

    updateStateType(StateType.idle);
  }

  // view the feed
  void viewFeed(
    final PeamanUser appUser,
    final PeamanFeed feed,
  ) async {
    final _newFeed = _feed.copyWith(
      extraData: {
        ..._feed.extraData,
        'viewed': true,
      },
    );
    updateFeed(_newFeed);
    await PFeedProvider.viewFeed(
      feedId: feed.id!,
      uid: appUser.uid!,
    );

    // update maat warrior points
    final _maatWarriorConfig = context.read<MaatWarriorConfig>();
    if (_maatWarriorConfig.viewPostPoints > 0) {
      MaatWarriorProvider.updateMaatWarriorPoints(
        uid: appUser.uid!,
        points: _maatWarriorConfig.viewPostPoints,
      );
    }
    //
  }

  // update value of feed
  void updateFeed(final PeamanFeed newVal) {
    _feed = newVal;
    notifyListeners();
  }
}
