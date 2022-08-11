import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/models/product_model.dart';
import 'package:imhotep/screens/view_books_ebooks_screen.dart';
import 'package:imhotep/screens/view_category_products_screen.dart';
import 'package:provider/provider.dart';

class CategoriesListItem extends StatelessWidget {
  final String category;
  final bool fromBooksAndEbooks;
  const CategoriesListItem({
    Key? key,
    required this.category,
    this.fromBooksAndEbooks = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _prods = context.watch<List<Product>>();
    final _prod = _prods.firstWhere((e) => e.categories.contains(category));

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (category == 'Books' && !fromBooksAndEbooks) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ViewBooksEbooksScreen(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ViewCategoryProductsScreen(
                category: category,
                mergeBooksAndEbooks: !fromBooksAndEbooks,
              ),
            ),
          );
        }
      },
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: greyColorshade200,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      _prod.displayPhoto,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              category,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
