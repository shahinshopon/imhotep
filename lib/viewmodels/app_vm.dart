import 'package:flutter/material.dart';
import 'package:imhotep/models/maat_warrior_config_model.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

class AppVm extends BaseVm {
  List<PeamanFeed> _allFeeds = [];
  List<PeamanFeed> _popularFeeds = [];
  bool _feedsLoaded = false;

  List<PeamanFeed> get allFeeds => _allFeeds;
  List<PeamanFeed> get popularFeeds => _popularFeeds;
  bool get feedsLoaded => _feedsLoaded;

  // get feeds
  void getFeeds(
    final BuildContext context,
    final List<PeamanFeed> feeds,
  ) {
    if (feeds.isNotEmpty) {
      _updateAllFeeds(feeds);
      final _popFeeds = _convertToPopularFeeds(context, feeds);
      _updatePopularFeeds(_popFeeds);
      _updateFeedsLoaded(true);
    }
  }

  // convert allFeeds to popularFeeds
  List<PeamanFeed> _convertToPopularFeeds(
    final BuildContext context,
    final List<PeamanFeed> allFeeds,
  ) {
    final _pFeeds = <PeamanFeed>[];
    allFeeds.forEach((element) {
      _pFeeds.add(element);
    });
    _pFeeds.sort((a, b) => _sortPopularFeeds(context, a, b));
    return _pFeeds;
  }

  // sort function for popularFeeds
  int _sortPopularFeeds(
    final BuildContext context,
    final PeamanFeed a,
    final PeamanFeed b,
  ) {
    final _maatWarriorConfig = context.read<MaatWarriorConfig>();

    return (b.reactionsCount * _maatWarriorConfig.likePostPoints +
            b.commentsCount * _maatWarriorConfig.commentPostPoints +
            b.savesCount * _maatWarriorConfig.savePostPoints +
            b.sharesCount * _maatWarriorConfig.sharePostOutsidePoints +
            b.viewsCount * _maatWarriorConfig.viewPostPoints)
        .compareTo(a.reactionsCount * _maatWarriorConfig.likePostPoints +
            a.commentsCount * _maatWarriorConfig.commentPostPoints +
            a.savesCount * _maatWarriorConfig.savePostPoints +
            a.sharesCount * _maatWarriorConfig.sharePostOutsidePoints +
            a.viewsCount * _maatWarriorConfig.viewPostPoints);
    // return (a.reactionsCount +
    //         a.commentsCount +
    //         a.savesCount +
    //         a.sharesCount +
    //         a.viewsCount)
    //     .compareTo(b.reactionsCount +
    //         b.commentsCount +
    //         b.savesCount +
    //         b.sharesCount +
    //         b.viewsCount);
  }

  // update value of allFeeds
  void _updateAllFeeds(final List<PeamanFeed> newVal) {
    _allFeeds = newVal;
  }

  // update value of popularFeeds
  void _updatePopularFeeds(final List<PeamanFeed> newVal) {
    _popularFeeds = newVal;
  }

  // update value of feedsLoaded
  void _updateFeedsLoaded(final bool newVal) {
    _feedsLoaded = newVal;
  }
}
