import 'package:flutter/material.dart';
import 'package:imhotep/helpers/dialog_provider.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:intl/intl.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

import '../models/archived_feed_model.dart';
import '../models/maat_warrior_config_model.dart';
import '../screens/comments_screen.dart';
import '../services/firebase/database/maat_warrior_provider.dart';
import '../widgets/feed_widgets/feed_share_bottomsheet.dart';

class FeedActionButtonsVm extends BaseVm {
  final BuildContext context;
  FeedActionButtonsVm(this.context);

  late PeamanFeed _feed;
  bool _initialized = false;

  PeamanFeed get feed => _feed;
  bool get initialized => _initialized;

  // init function
  void onInit({
    required final PeamanFeed thisFeed,
  }) async {
    _feed = thisFeed;
    _initialized = true;

    notifyListeners();
  }

  // format number to display 1K, 1M etc
  String formatNumber(final int num) {
    final _format = NumberFormat.compact().format(num);
    return _format;
  }

  // like the feed
  void likeFeed(
    final PeamanUser appUser, {
    final Function()? onLiked,
  }) {
    _feed = _feed.copyWith(
      reactionsCount: _feed.reactionsCount + 1,
      extraData: {
        ..._feed.extraData,
        'liked': true,
      },
    );
    updateFeed(_feed);

    final _reaction = PeamanReaction(
      id: _feed.extraData['like_reaction_id'],
      feedId: _feed.id,
      ownerId: appUser.uid,
      parent: PeamanReactionParent.feed,
      parentId: _feed.id,
    );
    PFeedProvider.addReaction(
      reaction: _reaction,
      onSuccess: (reaction) {
        _feed = _feed.copyWith(
          extraData: {
            ..._feed.extraData,
            'like_reaction_id': reaction.id,
          },
        );
        updateFeed(_feed);
        onLiked?.call();

        LikedFeed(
          feedId: _feed.id!,
          createdAt: DateTime.now().millisecondsSinceEpoch,
        )..saveLikedFeed(uid: appUser.uid!);
      },
    );

    // update maat warrior points
    if (_feed.extraData['like_reaction_id'] == null) {
      final _maatWarriorConfig = context.read<MaatWarriorConfig>();
      if (_maatWarriorConfig.likePostPoints > 0) {
        MaatWarriorProvider.updateMaatWarriorPoints(
          uid: appUser.uid!,
          points: _maatWarriorConfig.likePostPoints,
        );
      }
    }
    //
  }

  // goto comments screen
  void gotoComments({
    final Function()? onComment,
  }) async {
    final _commentsCount = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CommentsScreen(feed: _feed),
      ),
    );

    if (_commentsCount is int) {
      _feed = _feed.copyWith(
        commentsCount: _feed.commentsCount + _commentsCount,
      );
      updateFeed(_feed);
      onComment?.call();
    }
  }

  // open share bottomsheet
  void openShareBottomSheet({
    final Function()? onShare,
  }) async {
    DialogProvider(context).showBottomSheet(
      widget: FeedShareBottomSheet(
        feed: _feed,
        onShare: () {
          _feed = _feed.copyWith(
            sharesCount: _feed.sharesCount + 1,
          );
          updateFeed(_feed);
          onShare?.call();
        },
      ),
    );
  }

  // unlike the feed
  void unlikeFeed(final PeamanUser appUser) {
    final _myReactionId = _feed.extraData['like_reaction_id'];
    if (_myReactionId != null) {
      _feed = _feed.copyWith(
        reactionsCount: _feed.reactionsCount > 0 ? _feed.reactionsCount - 1 : 0,
        extraData: {
          ..._feed.extraData,
          'liked': false,
        },
      );
      updateFeed(_feed);
      PFeedProvider.removeReaction(
        feedId: _feed.id!,
        parentId: _feed.id!,
        reactionId: _myReactionId!,
      );
    }
  }

  // save the feed
  void saveFeed(final PeamanUser appUser) {
    _feed = _feed.copyWith(
      savesCount: _feed.savesCount + 1,
      extraData: {
        ..._feed.extraData,
        'saved': true,
      },
    );
    updateFeed(_feed);

    PFeedProvider.saveFeed(
      feedId: _feed.id!,
      uid: appUser.uid!,
    );

    // update maat warrior points
    final _maatWarriorConfig = context.read<MaatWarriorConfig>();
    if (_maatWarriorConfig.savePostPoints > 0) {
      MaatWarriorProvider.updateMaatWarriorPoints(
        uid: appUser.uid!,
        points: _maatWarriorConfig.savePostPoints,
      );
    }
    //
  }

  // unsave the feed
  void unsaveFeed(final PeamanUser appUser) {
    _feed = _feed.copyWith(
      savesCount: _feed.savesCount > 0 ? _feed.savesCount - 1 : 0,
      extraData: {
        ..._feed.extraData,
        'saved': false,
      },
    );
    updateFeed(_feed);

    PFeedProvider.unsaveFeed(
      feedId: _feed.id!,
      uid: appUser.uid!,
    );

    // update maat warrior points
    final _maatWarriorConfig = context.read<MaatWarriorConfig>();
    if (_maatWarriorConfig.savePostPoints > 0) {
      MaatWarriorProvider.updateMaatWarriorPoints(
        uid: appUser.uid!,
        points: -_maatWarriorConfig.savePostPoints,
      );
    }
    //
  }

  // update value of feed
  void updateFeed(
    final PeamanFeed newVal, {
    final bool requiredStateChange = true,
  }) {
    _feed = newVal;

    if (requiredStateChange) notifyListeners();
  }
}
