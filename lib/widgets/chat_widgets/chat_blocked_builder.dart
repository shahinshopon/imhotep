import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';
import 'package:peaman/peaman.dart';

class ChatBlockedBuilder extends StatelessWidget {
  final PeamanUser friend;
  final Function()? onPressedUnblock;
  final bool friendBlocked;
  const ChatBlockedBuilder({
    Key? key,
    required this.friend,
    this.onPressedUnblock,
    this.friendBlocked = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: blueColor,
      ),
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (friendBlocked)
            GestureDetector(
              onTap: onPressedUnblock,
              behavior: HitTestBehavior.opaque,
              child: Text(
                "Unblock ",
                style: TextStyle(
                  fontSize: 12.0,
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Text(
            friendBlocked
                ? "${friend.name} to continue conversation"
                : "You can't reply to this conversation at the moment",
            style: TextStyle(
              fontSize: 12.0,
              color: whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
