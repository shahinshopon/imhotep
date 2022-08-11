import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  final Widget icon;
  final Widget? overlayWidget;
  final EdgeInsetsGeometry? padding;
  final Color bgColor;
  final BoxShadow? shadow;
  final Function()? onPressed;
  const RoundIconButton({
    Key? key,
    required this.icon,
    this.overlayWidget,
    this.bgColor = Colors.white,
    this.padding,
    this.shadow,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
              boxShadow: [
                shadow ??
                    BoxShadow(
                      color: Colors.transparent,
                    )
              ],
            ),
            padding: padding ?? const EdgeInsets.all(12.0),
            child: icon,
          ),
          Positioned(
            right: 0.0,
            top: -10.0,
            child: overlayWidget ?? SizedBox(),
          ),
        ],
      ),
    );
  }
}
