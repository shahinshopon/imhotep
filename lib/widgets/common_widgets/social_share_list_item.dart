import 'package:flutter/material.dart';

import '../../constants.dart';

class SocialShareListItem extends StatelessWidget {
  final String img;
  final String title;
  final Function()? onPressed;
  const SocialShareListItem({
    Key? key,
    required this.img,
    required this.title,
    this.onPressed,
  }) : super(key: key);

  get greyColorshade200 => null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              width: 55.0,
              height: 55.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: greyColorshade200,
                image: DecorationImage(
                  image: AssetImage(
                    img,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              title,
              style: TextStyle(
                color: greyColor,
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
