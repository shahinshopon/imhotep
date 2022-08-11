import 'package:flutter/material.dart';

import '../../constants.dart';

class Spinner extends StatelessWidget {
  final Color color;
  const Spinner({
    Key? key,
    this.color = blueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        color: color,
      ),
    );
  }
}
