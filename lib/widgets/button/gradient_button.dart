// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';

class GradientButton extends StatefulWidget {
  final String name;
  final gradientcolor1;
  final gradientcolor2;
  final textColor;
  final width;
  final height;
  final double fontSize;
  final Function() function;
  final double radius;
  const GradientButton(
      this.name,
      this.gradientcolor1,
      this.gradientcolor2,
      this.textColor,
      this.width,
      this.height,
      this.fontSize,
      this.function,
      this.radius,
      {Key? key})
      : super(key: key);

  @override
  _GradientButtonState createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.function,
      child: Container(
        height: MediaQuery.of(context).size.height / widget.height,
        width: MediaQuery.of(context).size.width / widget.width,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(color: blueColor, spreadRadius: 1, blurRadius: 1)
          ],
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [widget.gradientcolor1, widget.gradientcolor2]),
          borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                      color: widget.textColor,
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
