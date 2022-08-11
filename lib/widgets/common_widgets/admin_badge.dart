import 'package:flutter/material.dart';

import '../../constants.dart';

class AdminBadge extends StatelessWidget {
  const AdminBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/admin.png',
          height: 15.0,
        ),
        SizedBox(
          width: 5.0,
        ),
        Text(
          'Admin',
          style: TextStyle(
            color: darkGreyColor,
            fontSize: 12.0,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
