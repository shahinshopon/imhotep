import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants.dart';

class MaatWarriorBadge extends StatelessWidget {
  const MaatWarriorBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: SvgPicture.asset(
            'assets/svgs/maat_warrior.svg',
            height: 18.0,
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        Text(
          'Maat Warrior',
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
