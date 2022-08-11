import 'package:flutter/material.dart';

class MaatWarriorBadgeContainer extends StatefulWidget {
  const MaatWarriorBadgeContainer({ Key? key }) : super(key: key);

  @override
  _MaatWarriorBadgeContainerState createState() => _MaatWarriorBadgeContainerState();
}

class _MaatWarriorBadgeContainerState extends State<MaatWarriorBadgeContainer> {
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        ClipPath(
            clipper: MyClipper(),
            child: Container(
                decoration: BoxDecoration(
                     color: Colors.orange.shade300,
                    borderRadius: BorderRadius.circular(24)),
                
              width: MediaQuery.of(context).size.height,
              height: 250.0,
             
            ),
      ),
      ]
    
  );
}
  }
  class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0, size.height - 150);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 170);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}