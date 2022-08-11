import 'package:flutter/material.dart';

import '../../constants.dart';

class CategoriesListItem extends StatelessWidget {
  final String category;
  final Function(String)? onPressed;
  final bool active;

  const CategoriesListItem({
    Key? key,
    required this.category,
    this.active = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed?.call(category),
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: active ? blueColor : Colors.transparent,
            border: active ? null : Border.all(color: greyColor),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 20.0,
          ),
          child: Center(
            child: Text(
              category,
              style: TextStyle(
                color: active ? whiteColor : greyColor,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
