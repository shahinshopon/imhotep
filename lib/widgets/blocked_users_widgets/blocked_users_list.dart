import 'package:flutter/material.dart';
import 'package:peaman/peaman.dart';

import 'blocked_users_list_item.dart';

class BlockedUsersList extends StatelessWidget {
  final List<PeamanBlockedUser> blockedUsers;
  final Function(PeamanBlockedUser)? onPressedUnblock;
  const BlockedUsersList({
    Key? key,
    required this.blockedUsers,
    this.onPressedUnblock,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: blockedUsers.length,
      itemBuilder: (context, index) {
        final _blockedUser = blockedUsers[index];
        return BlockedUsersListItem(
          blockedUser: _blockedUser,
          length: blockedUsers.length,
          onPressedUnblock: () => onPressedUnblock?.call(
            _blockedUser,
          ),
        );
      },
    );
  }
}
