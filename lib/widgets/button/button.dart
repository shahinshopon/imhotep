// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final String name;
  final color;
  final borderColor;
  final textColor;
  final double fontSize;
  final function;
  final width;
  final IconData icn;
  final iconColor;
  const Button(this.name, this.color, this.borderColor, this.textColor,
      this.width, this.fontSize, this.function, this.icn, this.iconColor,
      {Key? key})
      : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.function,
      child: Container(
        height: MediaQuery.of(context).size.height / 16,
        width: MediaQuery.of(context).size.width / widget.width,
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.borderColor,
            width: 2.0,
          ),
          color: widget.color,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icn,
                  color: widget.iconColor,
                ),
                SizedBox(width: 10),
                Text(
                  widget.name,
                  style: TextStyle(
                      color: widget.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: widget.fontSize),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
