import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import '../../models/text_info.dart';

class ImageText extends StatelessWidget {
  final TextInfo textInfo;
  const ImageText({
    Key? key,
    required this.textInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: textInfo.bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        child: Linkify(
          text: textInfo.text,
          textAlign: textInfo.textAlign,
          style: TextStyle(
            fontSize: textInfo.fontSize,
            fontWeight: textInfo.fontWeight,
            fontStyle: textInfo.fontStyle,
            color: textInfo.color,
          ),
        ),
      ),
    );
  }
}
