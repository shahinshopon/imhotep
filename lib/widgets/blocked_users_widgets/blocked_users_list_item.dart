import 'package:flutter/material.dart';
import 'package:imhotep/widgets/common_widgets/hotep_button.dart';
import 'package:imhotep/widgets/common_widgets/user_fetcher.dart';
import 'package:peaman/peaman.dart';

import '../../screens/friend_profile_screen.dart';
import '../common_widgets/avatar_builder.dart';

class BlockedUsersListItem extends StatefulWidget {
  final PeamanBlockedUser blockedUser;
  final Function()? onPressedUnblock;
  final int length;
  const BlockedUsersListItem({
    Key? key,
    required this.blockedUser,
    required this.length,
    this.onPressedUnblock,
  }) : super(key: key);

  @override
  State<BlockedUsersListItem> createState() => _BlockedUsersListItemState();
}

class _BlockedUsersListItemState extends State<BlockedUsersListItem> {
  Stream<PeamanUser>? _userStream;

  @override
  void initState() {
    super.initState();
    _userStream = PUserProvider.getUserById(
      uid: widget.blockedUser.uid!,
    );
  }

  @override
  void didUpdateWidget(covariant BlockedUsersListItem oldWidget) {
    if (oldWidget.length != widget.length) {
      _userStream = PUserProvider.getUserById(
        uid: widget.blockedUser.uid!,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return UserFetcher.singleStream(
      userStream: _userStream,
      singleBuilder: (user) {
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
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => FriendProfileScreen(
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
                  SizedBox(
                    width: 10.0,
                  ),
                  HotepButton.gradient(
                    value: 'Unblock',
                    padding: const EdgeInsets.all(0.0),
                    onPressed: widget.onPressedUnblock,
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
      },
    );
  }
}
