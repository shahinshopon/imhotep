import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';

class AvatarBuilder extends StatelessWidget {
  final String? letter;
  final String? imgUrl;
  final Color? textColor;
  final double size;
  final Color bgColor;
  final bool border;
  final Color borderColor;
  final Function()? onPressed;

  const AvatarBuilder.image(
    this.imgUrl, {
    this.size = 40.0,
    this.bgColor = greyColorshade200,
    this.border = false,
    this.borderColor = blueColor,
    this.onPressed,
  })  : letter = null,
        textColor = null;

  const AvatarBuilder.letter(
    this.letter, {
    this.size = 40.0,
    this.textColor = Colors.white,
    this.bgColor = Colors.grey,
    this.border = false,
    this.borderColor = blueColor,
    this.onPressed,
  }) : imgUrl = null;

  @override
  Widget build(BuildContext context) {
    if (imgUrl != null)
      return GestureDetector(
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: size + 2,
          height: size + 2,
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: !border
                ? null
                : Border.all(
                    color: borderColor,
                    width: 2.0,
                  ),
          ),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              image: DecorationImage(
                image: CachedNetworkImageProvider('${imgUrl}'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    else if (letter != null)
      return GestureDetector(
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              letter!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      );
    else
      return Container(
        width: size + 2,
        height: size + 2,
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: !border
              ? null
              : Border.all(
                  color: borderColor,
                  width: 2.0,
                ),
        ),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
        ),
      );
  }
}
