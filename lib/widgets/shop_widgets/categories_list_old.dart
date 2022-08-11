import 'package:flutter/material.dart';
import 'package:imhotep/widgets/shop_widgets/categories_list_item_old.dart';

class CategoriesList extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String)? onPressedCategory;
  const CategoriesList({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    this.onPressedCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _list = ['All', ...categories];

    return Container(
      height: 35.0,
      child: ListView.builder(
        itemCount: _list.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final _item = _list[index];

          if (_item == 'All') {
            return Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: CategoriesListItem(
                category: 'All',
                onPressed: onPressedCategory,
                active: _item == selectedCategory,
              ),
            );
          }

          return CategoriesListItem(
            category: _item,
            onPressed: onPressedCategory,
            active: _item == selectedCategory,
          );
        },
      ),
    );
  }
}
