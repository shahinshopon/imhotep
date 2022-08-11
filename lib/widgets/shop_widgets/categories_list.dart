import 'package:flutter/material.dart';
import 'package:imhotep/widgets/shop_widgets/categories_list_item.dart';

class CategoriesList extends StatelessWidget {
  final List<String> categories;
  final bool scroll;
  final int crossAxisCount;
  final bool fromBooksAndEbooks;
  const CategoriesList({
    Key? key,
    required this.categories,
    this.crossAxisCount = 2,
    this.scroll = true,
    this.fromBooksAndEbooks = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: !scroll,
      physics: scroll
          ? AlwaysScrollableScrollPhysics()
          : NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        childAspectRatio: 4 / 5,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final _category = categories[index];

        return CategoriesListItem(
          category: _category,
          fromBooksAndEbooks: fromBooksAndEbooks,
        );
      },
    );
  }
}
