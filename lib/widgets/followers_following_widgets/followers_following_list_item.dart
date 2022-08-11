import 'package:flutter/material.dart';
import 'package:imhotep/widgets/common_widgets/avatar_builder.dart';
import 'package:peaman/peaman.dart';
import '../../constants.dart';
import '../../screens/friend_profile_screen.dart';

enum _ListItemType {
  followers,
  following,
}

class FollowersFollowingListItem extends StatelessWidget {
  final PeamanUser user;
  final _ListItemType type;
  final bool alreadyFollowing;
  final Function(PeamanUser)? onFollow;
  final Function(PeamanUser)? onUnfollow;

  const FollowersFollowingListItem.followers({
    Key? key,
    required this.user,
    this.alreadyFollowing = false,
    this.onFollow,
  })  : type = _ListItemType.followers,
        onUnfollow = null,
        super(key: key);

  const FollowersFollowingListItem.following({
    Key? key,
    required this.user,
    this.onUnfollow,
  })  : alreadyFollowing = false,
        type = _ListItemType.following,
        onFollow = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        top: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    AvatarBuilder.image(
                      '${user.photoUrl}',
                      size: 60.0,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FriendProfileScreen(
                              friend: user,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${user.name}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              if (type == _ListItemType.followers &&
                                  !alreadyFollowing)
                                GestureDetector(
                                  onTap: () => onFollow?.call(user),
                                  behavior: HitTestBehavior.opaque,
                                  child: Text(
                                    'Follow',
                                    style: TextStyle(
                                      color: blueColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              if (type == _ListItemType.following)
                                GestureDetector(
                                  onTap: () => onUnfollow?.call(user),
                                  behavior: HitTestBehavior.opaque,
                                  child: Text(
                                    'Unfollow',
                                    style: TextStyle(
                                      color: redAccentColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Text(
                            (user.bio ?? '').length > 100
                                ? '${user.bio?.substring(0, 100)}...'
                                : '${user.bio}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 15),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 1,
              color: Colors.grey[300],
            ),
          )
        ],
      ),
    );
  }
}
