import 'package:flutter/material.dart';
import 'package:imhotep/widgets/common_widgets/user_fetcher.dart';
import 'package:peaman/peaman.dart';

import 'followers_following_list_item.dart';

enum _ListType {
  followers,
  following,
}

class FollowersFollowingList extends StatelessWidget {
  final _ListType type;
  final List<PeamanFollower>? followers;
  final List<PeamanFollowing>? following;
  final Function(PeamanUser)? onFollow;
  final Function(PeamanUser)? onUnfollow;

  const FollowersFollowingList.followers({
    Key? key,
    required this.followers,
    required this.following,
    this.onFollow,
  })  : type = _ListType.followers,
        this.onUnfollow = null,
        super(key: key);

  const FollowersFollowingList.following({
    Key? key,
    required this.following,
    this.onUnfollow,
  })  : type = _ListType.following,
        onFollow = null,
        followers = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == _ListType.followers
        ? _followersBuilder()
        : _followingBuilder();
  }

  Widget _followersBuilder() {
    return ListView.builder(
      itemCount: followers?.length ?? 0,
      itemBuilder: (context, index) {
        final _follower = followers![index];

        return UserFetcher.singleFuture(
          userFuture: PUserProvider.getUserById(uid: _follower.uid!).first,
          singleBuilder: (user) {
            return FollowersFollowingListItem.followers(
              user: user,
              alreadyFollowing: (following ?? [])
                      .indexWhere((element) => element.uid == user.uid) !=
                  -1,
              onFollow: onFollow,
            );
          },
        );
      },
    );
  }

  Widget _followingBuilder() {
    return ListView.builder(
      itemCount: following?.length ?? 0,
      itemBuilder: (context, index) {
        final _following = following![index];

        return UserFetcher.singleFuture(
          userFuture: PUserProvider.getUserById(uid: _following.uid!).first,
          singleBuilder: (user) {
            return FollowersFollowingListItem.following(
              user: user,
              onUnfollow: onUnfollow,
            );
          },
        );
      },
    );
  }
}
