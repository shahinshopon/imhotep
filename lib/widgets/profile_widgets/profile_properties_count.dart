import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../screens/followers_following_screen.dart';

class ProfilePropertiesCount extends StatelessWidget {
  final int articlesViewed;
  final int repliesReceived;
  final int likeableComments;
  final int followers;
  final int following;
  const ProfilePropertiesCount({
    Key? key,
    this.articlesViewed = 0,
    this.repliesReceived = 0,
    this.likeableComments = 0,
    this.followers = 0,
    this.following = 0,
  }) : super(key: key);

  void _gotoFollowers(final BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FollowersFollowingScreen.followers(),
      ),
    );
  }

  void _gotoFollowing(final BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FollowersFollowingScreen.following(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // _itemBuilder(
        //   count: articlesViewed,
        //   title: 'Articles\nviewed',
        // ),
        // _divider(),
        _itemBuilder(
          count: repliesReceived,
          title: 'Replies\nreceived',
        ),
        _divider(),
        _itemBuilder(
          count: likeableComments,
          title: 'Likeable\ncomments',
        ),
        _divider(),
        _itemBuilder(
          count: followers,
          title: 'Followers\n',
          blue: true,
          onPressed: () => _gotoFollowers(context),
        ),
        _divider(),
        _itemBuilder(
          count: following,
          title: 'Follows\n',
          blue: true,
          onPressed: () => _gotoFollowing(context),
        ),
      ],
    );
  }

  Widget _itemBuilder({
    required final int count,
    required final String title,
    final bool blue = false,
    final Function()? onPressed,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: blue ? blueColor : blackColor,
              fontSize: 18.0,
            ),
          ),
          Center(
            child: Text(
              title,
              style: TextStyle(
                color: blue ? blueColor : blackColor,
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 3.0,
      height: 50.0,
      color: greyColor.withOpacity(0.2),
    );
  }
}
