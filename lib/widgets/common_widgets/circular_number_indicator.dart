import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';

class CircularNumberIndicator extends StatelessWidget {
  final int num;
  final double size;
  final Color backgroundColor;
  const CircularNumberIndicator({
    Key? key,
    required this.num,
    this.size = 7.0,
    this.backgroundColor = redAccentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (num == 0) return Container();
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(size),
      child: Text(
        '$num',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 10.0, color: Colors.white),
      ),
    );
  }
}
