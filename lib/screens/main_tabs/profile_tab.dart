import 'package:flutter/material.dart';
import 'package:imhotep/widgets/profile_widgets/profile_main.dart';

class ProfileTab extends StatelessWidget {
  ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: ProfileMain.personal());
  }
}
