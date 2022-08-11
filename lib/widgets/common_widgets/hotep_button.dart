import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';

enum _ButtonStyle {
  filled,
  bordered,
  gradient,
}

class HotepButton extends StatelessWidget {
  final String? value;
  final Color color;
  final TextStyle? textStyle;
  final Color borderColor;
  final Widget? icon;
  final double borderRadius;
  final Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final _ButtonStyle buttonStyle;
  final bool loading;
  final double loaderSize;
  final List<Color> grandientColors;
  final double? width;
  final double? height;

  const HotepButton.filled({
    this.value,
    this.icon,
    this.color = blueColor,
    this.textStyle,
    this.borderRadius = 2.0,
    this.onPressed,
    this.padding,
    this.loading = false,
    this.loaderSize = 20.0,
    this.width,
    this.height,
  })  : buttonStyle = _ButtonStyle.filled,
        grandientColors = const [],
        borderColor = Colors.black;

  const HotepButton.bordered({
    this.value,
    this.icon,
    this.textStyle,
    this.borderColor = blueColor,
    this.borderRadius = 2.0,
    this.onPressed,
    this.padding,
    this.loading = false,
    this.loaderSize = 30.0,
    this.width,
    this.height,
  })  : buttonStyle = _ButtonStyle.bordered,
        grandientColors = const [],
        color = blueColor;

  const HotepButton.gradient({
    this.value,
    this.icon,
    this.textStyle,
    this.borderColor = blueColor,
    this.borderRadius = 2.0,
    this.onPressed,
    this.padding,
    this.loading = false,
    this.loaderSize = 30.0,
    this.width,
    this.height,
    this.grandientColors = const [bluegradientColor, yellowgradientColor],
  })  : buttonStyle = _ButtonStyle.gradient,
        color = blueColor;

  @override
  Widget build(BuildContext context) {
    if (buttonStyle == _ButtonStyle.filled)
      return MaterialButton(
        color: color,
        minWidth: width,
        height: height,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: padding ?? const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        disabledColor: Colors.grey[300],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) icon ?? Container(),
            if (icon != null && value != null)
              SizedBox(
                width: 10.0,
              ),
            if (value != null)
              Text(
                '$value',
                style: textStyle ??
                    TextStyle(
                      color: Colors.white,
                    ),
              ),
            if (loading)
              SizedBox(
                width: 20.0,
              ),
            if (loading)
              Container(
                width: loaderSize,
                height: loaderSize,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
          ],
        ),
        onPressed: onPressed,
      );
    else if (buttonStyle == _ButtonStyle.bordered)
      return MaterialButton(
        minWidth: width,
        height: height,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: padding ?? const EdgeInsets.all(18.0),
        splashColor: borderColor.withOpacity(0.1),
        highlightColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(
            color: borderColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) icon ?? Container(),
            if (icon != null && value != null)
              SizedBox(
                width: 10.0,
              ),
            if (value != null)
              Text(
                '$value',
                style: textStyle ??
                    TextStyle(
                      color: onPressed == null ? Colors.grey : borderColor,
                    ),
              ),
            if (loading)
              SizedBox(
                width: 20.0,
              ),
            if (loading)
              Container(
                width: loaderSize,
                height: loaderSize,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
          ],
        ),
        onPressed: onPressed,
      );
    else
      return GestureDetector(
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: Container(
          constraints: BoxConstraints(
            minWidth: width ?? 60.0,
          ),
          height: height,
          padding: padding ?? const EdgeInsets.all(18.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: grandientColors,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) icon ?? Container(),
                if (icon != null && value != null)
                  SizedBox(
                    width: 10.0,
                  ),
                if (value != null)
                  Text(
                    '$value',
                    style: textStyle ??
                        TextStyle(
                          color: onPressed == null ? Colors.grey : whiteColor,
                        ),
                  ),
                if (loading)
                  SizedBox(
                    width: 10.0,
                  ),
                if (loading)
                  Container(
                    width: loaderSize,
                    height: loaderSize,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
  }
}
