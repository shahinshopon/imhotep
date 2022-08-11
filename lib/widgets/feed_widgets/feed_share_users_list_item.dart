import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/screens/friend_profile_screen.dart';
import 'package:imhotep/widgets/common_widgets/hotep_button.dart';
import 'package:imhotep/widgets/common_widgets/user_fetcher.dart';
import 'package:imhotep/widgets/common_widgets/user_list_item.dart';
import 'package:peaman/peaman.dart';

enum _Type {
  expanded,
  rounded,
}

class FeedShareUsersListItem extends StatefulWidget {
  final String userId;
  final Function(PeamanUser)? onPressedSend;
  final _Type type;

  const FeedShareUsersListItem.expanded({
    Key? key,
    required this.userId,
    this.onPressedSend,
  })  : type = _Type.expanded,
        super(key: key);

  const FeedShareUsersListItem.rounded({
    Key? key,
    required this.userId,
    this.onPressedSend,
  })  : type = _Type.rounded,
        super(key: key);

  @override
  State<FeedShareUsersListItem> createState() => _FeedShareUsersListItemState();
}

class _FeedShareUsersListItemState extends State<FeedShareUsersListItem> {
  Future<PeamanUser>? _userFuture;
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    _userFuture = PUserProvider.getUserById(
      uid: widget.userId,
    ).first;
  }

  @override
  Widget build(BuildContext context) {
    return UserFetcher.singleFuture(
      userFuture: _userFuture,
      singleBuilder: (user) {
        return widget.type == _Type.expanded
            ? _expandedBuilder(user)
            : _roundedBuilder(user);
      },
    );
  }

  Widget _expandedBuilder(final PeamanUser user) {
    return Row(
      children: [
        Expanded(
          child: UserListItem.expanded(
            user: user,
            onPressed: (user) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FriendProfileScreen(friend: user),
                ),
              );
            },
          ),
        ),
        HotepButton.gradient(
          value: _sent ? 'Sent' : 'Send',
          padding: const EdgeInsets.all(0.0),
          onPressed: () {
            if (!_sent) {
              setState(() {
                _sent = true;
              });

              Future.delayed(
                Duration(milliseconds: 2000),
                () {
                  setState(() {
                    _sent = false;
                  });
                },
              );
              widget.onPressedSend?.call(user);
            }
          },
        ),
        SizedBox(
          width: 10.0,
        ),
      ],
    );
  }

  Widget _roundedBuilder(final PeamanUser user) {
    return UserListItem.rounded(
      user: user,
      photoOverlapWidget: _sent ? _photoOverlapBuilder() : null,
      onPressed: (user) {
        if (!_sent) {
          setState(() {
            _sent = true;
          });

          Future.delayed(
            Duration(milliseconds: 1000),
            () {
              setState(() {
                _sent = false;
              });
            },
          );
          widget.onPressedSend?.call(user);
        }
      },
    );
  }

  Widget _photoOverlapBuilder() {
    return Container(
      decoration: BoxDecoration(
        color: blueColor.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.check_rounded,
          color: whiteColor,
        ),
      ),
    );
  }
}
