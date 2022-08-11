// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';

class ButtonIconLess extends StatefulWidget {
  final String name;
  final color;
  final borderColor;
  final textColor;
  final width;
  final height;
  final double fontSize;
  final function;
  final double radius;
  final bool loading;
  const ButtonIconLess(
    this.name,
    this.color,
    this.borderColor,
    this.textColor,
    this.width,
    this.height,
    this.fontSize,
    this.function,
    this.radius, {
    Key? key,
    this.loading = false,
  }) : super(key: key);

  @override
  _ButtonIconLessState createState() => _ButtonIconLessState();
}

class _ButtonIconLessState extends State<ButtonIconLess> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.function,
      child: Container(
        height: MediaQuery.of(context).size.height / widget.height,
        width: MediaQuery.of(context).size.width / widget.width,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(color: blueColor, spreadRadius: 0.09, blurRadius: 0.5)
          ],
          border: Border.all(
            color: widget.borderColor,
            width: 1.0,
          ),
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.radius),
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
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (widget.loading)
                  SizedBox(
                    width: 20.0,
                  ),
                if (widget.loading)
                  Container(
                    width: 30.0,
                    height: 30.0,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: whiteColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
