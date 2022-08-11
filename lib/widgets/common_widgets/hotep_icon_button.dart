import 'package:flutter/material.dart';

class HotepIconButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final Color? bgColor;
  final double size;
  final Function()? onPressed;
  const HotepIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.iconColor,
    this.bgColor,
    this.size = 50.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor ?? Colors.white,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            color: iconColor ?? Color(0xff302f35),
          ),
        ),
      ),
    );
  }
}
