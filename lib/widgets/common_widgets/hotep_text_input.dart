import 'package:flutter/material.dart';

enum _TextInputType {
  normal,
  bordered,
}

class HotepTextInput extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType textInputType;
  final bool isExpanded;
  final bool requiredCapitalization;
  final Function(String)? onChanged;
  final Function()? onTapped;
  final _TextInputType type;

  HotepTextInput.normal({
    required this.hintText,
    this.controller,
    this.textInputType = TextInputType.text,
    this.isExpanded = false,
    this.requiredCapitalization = true,
    this.onChanged,
    this.onTapped,
  }) : type = _TextInputType.normal;

  HotepTextInput.bordered({
    required this.hintText,
    required this.controller,
    this.textInputType = TextInputType.text,
    this.isExpanded = false,
    this.requiredCapitalization = true,
    this.onChanged,
    this.onTapped,
  }) : type = _TextInputType.bordered;

  @override
  Widget build(BuildContext context) {
    if (type == _TextInputType.normal)
      return TextFormField(
        onTap: onTapped,
        enabled: onTapped == null ? true : false,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
      );
    else
      return GestureDetector(
        onTap: onTapped,
        child: Container(
          color: onTapped == null
              ? Colors.transparent
              : Colors.grey.withOpacity(0.2),
          child: TextFormField(
            onTap: onTapped,
            enabled: onTapped == null ? true : false,
            controller: controller,
            maxLines: isExpanded ? 5 : 1,
            minLines: 1,
            keyboardType: textInputType,
            textCapitalization: requiredCapitalization
                ? TextCapitalization.words
                : TextCapitalization.sentences,
            onChanged: onChanged,
            decoration: InputDecoration(
              labelText: hintText,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0,
                  color: Colors.blue,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0,
                  color: Colors.grey,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: isExpanded ? 15.0 : 10.0,
                horizontal: 10.0,
              ),
            ),
          ),
        ),
      );
  }
}
