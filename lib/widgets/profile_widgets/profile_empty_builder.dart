import 'package:flutter/material.dart';

class ProfileEmptyBuilder extends StatelessWidget {
  final String imgUrl;
  final String description;
  const ProfileEmptyBuilder({
    Key? key,
    required this.imgUrl,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            '$imgUrl',
            height: 60,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '$description',
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
