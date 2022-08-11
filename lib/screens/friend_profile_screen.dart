import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/widgets/profile_widgets/profile_main.dart';
import 'package:peaman/peaman.dart';

class FriendProfileScreen extends StatelessWidget {
  final PeamanUser friend;
  FriendProfileScreen({
    Key? key,
    required this.friend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: IconThemeData(color: blackColor),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ProfileMain.friend(friend: friend),
    );
  }
}
