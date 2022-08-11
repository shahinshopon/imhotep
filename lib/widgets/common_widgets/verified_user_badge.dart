import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';

class VerifiedUserBadge extends StatelessWidget {
  final double size;
  final Color color;
  const VerifiedUserBadge({
    Key? key,
    this.size = 20.0,
    this.color = blueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.verified_rounded,
      color: color,
      size: size,
    );
  }
}
