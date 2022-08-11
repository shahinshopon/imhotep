import 'package:flutter/material.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

import '../models/maat_warrior_config_model.dart';
import '../services/firebase/database/maat_warrior_provider.dart';

class ViewSingleArticleVm extends BaseVm {
  final BuildContext context;
  ViewSingleArticleVm(this.context);

  late PeamanFeed _feed;
  bool _initializedFeed = false;

  PeamanFeed get feed => _feed;
  List<PeamanFeed> get allFeeds => context.watch<List<PeamanFeed>>();
  bool get initializedFeed => _initializedFeed;

  // init function
  void onInit({
    required final PeamanFeed thisFeed,
    required final PeamanUser appUser,
  }) {
    _feed = thisFeed;
    _initializedFeed = true;
    notifyListeners();

    viewFeed(appUser, feed);
  }

  // view the feed
  void viewFeed(
    final PeamanUser appUser,
    final PeamanFeed feed,
  ) async {
    final _newFeed = _feed.copyWith(
      viewsCount: _feed.viewsCount + 1,
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
