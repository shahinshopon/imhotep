import 'package:flutter/material.dart';
import 'package:imhotep/widgets/common_widgets/user_list_item.dart';
import 'package:peaman/peaman.dart';

enum _Type {
  expanded,
  rounded,
}

class UsersList extends StatelessWidget {
  final List<PeamanUser> users;
  final bool scroll;
  final Function(PeamanUser)? onPressedUser;
  final Axis scrollDirection;
  final _Type type;

  const UsersList.expanded({
    Key? key,
    required this.users,
    this.scroll = false,
    this.onPressedUser,
  })  : type = _Type.expanded,
        this.scrollDirection = Axis.vertical,
        super(key: key);

  const UsersList.rounded({
    Key? key,
    required this.users,
    this.scroll = false,
    this.onPressedUser,
    this.scrollDirection = Axis.vertical,
  })  : type = _Type.rounded,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: type == _Type.rounded && scrollDirection == Axis.horizontal
          ? 105.0
          : null,
      child: ListView.builder(
        itemCount: users.length,
        shrinkWrap: !scroll,
        scrollDirection: scrollDirection,
        physics: scroll
            ? AlwaysScrollableScrollPhysics()
            : NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final _user = users[index];
          return type == _Type.expanded
              ? UserListItem.expanded(
                  user: _user,
                  onPressed: onPressedUser,
                )
              : UserListItem.rounded(
                  user: _user,
                  onPressed: onPressedUser,
                );
        },
      ),
    );
  }
}
