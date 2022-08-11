import 'package:flutter/material.dart';

import '../profile_empty_builder.dart';

class ShoppingArchiveTab extends StatelessWidget {
  final List<dynamic> shoppings;
  const ShoppingArchiveTab({
    Key? key,
    required this.shoppings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (shoppings.isEmpty) {
      return ProfileEmptyBuilder(
        imgUrl: 'assets/Groupshop.png',
        description:
            'This is your shopping archive.\n Once you start to purchase producsts\n You can track your orders here.',
      );
    }
    return Container();
  }
}
