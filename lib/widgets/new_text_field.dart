import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';

class NewTextField extends StatefulWidget {
  final String text;
  final String hinttext;
  final TextEditingController? controller;
  const NewTextField(
    this.text,
    this.hinttext, {
    this.controller,
    Key? key,
  }) : super(key: key);

  @override
  _NewTextFieldState createState() => _NewTextFieldState();
}

class _NewTextFieldState extends State<NewTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.text,
              style: const TextStyle(
                color: whiteColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              color: whiteColor,
              border: Border.all(color: Colors.transparent),
            ),
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                focusedBorder: InputBorder.none,
                hintText: widget.hinttext,
              ),
            ),
          )
        ],
      ),
    );
  }
}
