import 'package:flutter/material.dart';

import '../../constants.dart';

class BetaBadge extends StatelessWidget {
  const BetaBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: greyColor,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 3.0,
        horizontal: 8.0,
      ),
      child: Text(
        'Beta',
        style: TextStyle(
          fontSize: 11.0,
          fontWeight: FontWeight.w600,
          color: whiteColor,
        ),
      ),
    );
  }
}
