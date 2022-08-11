import 'package:flutter/material.dart';
import 'package:imhotep/screens/friend_profile_screen.dart';
import 'package:imhotep/widgets/common_widgets/avatar_builder.dart';
import 'package:peaman/peaman.dart';

import '../../constants.dart';
import '../button/gradient_button.dart';

class ChatUserDetails extends StatelessWidget {
  final PeamanUser chatUser;
  const ChatUserDetails({
    Key? key,
    required this.chatUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          AvatarBuilder.image(
            chatUser.photoUrl,
            size: 80.0,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            '${chatUser.name}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: blueColor,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            '${chatUser.bio}',
            style: TextStyle(
              color: blackColor,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.0,
          ),
          GradientButton(
            'View Profile',
            bluegradientColor,
            yellowgradientColor,
            whiteColor,
            2.7,
            20,
            14,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FriendProfileScreen(
                  friend: chatUser,
                ),
              ),
            ),
            50.0,
          ),
        ],
      ),
    );
  }
}
