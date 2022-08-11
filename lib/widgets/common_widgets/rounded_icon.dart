import 'package:flutter/material.dart';

class RoundedIcon extends StatelessWidget {
  final Widget icon;
  final double size;
  const RoundedIcon({
    Key? key,
    required this.icon,
    this.size = 50.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.8),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Center(child: icon),
    );
  }
}
