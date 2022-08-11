import 'package:flutter/material.dart';

class BadgeContainer extends StatefulWidget {
  const BadgeContainer({Key? key}) : super(key: key);

  @override
  _BadgeContainerState createState() => _BadgeContainerState();
}

class _BadgeContainerState extends State<BadgeContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ClipPath(
        clipper: MyClipper(),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.brown, borderRadius: BorderRadius.circular(24)),
          width: MediaQuery.of(context).size.height,
          height: 250.0,
        ),
      ),
    ]);
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0, size.height - 150);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 170);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
