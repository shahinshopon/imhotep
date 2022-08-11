import 'package:flutter/material.dart';
import 'package:imhotep/models/maat_warrior_config_model.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

import '../screens/view_single_feed_screen.dart';
import '../services/firebase/database/maat_warrior_provider.dart';

class DynamicLinkNavigationHelper {
  final BuildContext context;
  DynamicLinkNavigationHelper(this.context);

  void navigate({
    required final Uri uri,
  }) {
    final _isFeedLink = uri.pathSegments.contains('posts');
    if (_isFeedLink) {
      final _feedId = uri.queryParameters['id'];
      final _feedSharerId = uri.queryParameters['uid'];

      if (_feedId != null && _feedSharerId != null) {
        _singleFeedNavigation(_feedId, _feedSharerId);
      }
    }
  }

  // single post navigation
  void _singleFeedNavigation(
    final String feedId,
    final String feedSharerId,
  ) {
    final _maatWarriorConfig = context.read<MaatWarriorConfig>();
    final _appUser = context.read<PeamanUser>();

    if (_appUser.uid != feedSharerId) {
      // update maat warrior points
      if (_maatWarriorConfig.sharePostOutsidePoints > 0) {
        MaatWarriorProvider.updateMaatWarriorPoints(
          points: _maatWarriorConfig.sharePostOutsidePoints,
          uid: feedSharerId,
        );
      }
      //

      // update feed shares count
      PFeedProvider.updateFeed(
        feedId: feedId,
        data: {'shares_count': 1},
        partial: true,
      );
      //
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ViewSingleFeedScreen(
          feedId: feedId,
        ),
      ),
    );
  }
}
