import 'package:flutter/material.dart';
import 'package:imhotep/models/product_model.dart';
import 'package:imhotep/models/shopify_product.dart';
import 'package:imhotep/widgets/shop_widgets/shop_products_list_item.dart';

enum _Type {
  normal,
  grid,
}

class ShopProductsList extends StatelessWidget {
  final List<Product> products;
  final List<ShopifyProduct> shopifyProducts;
  final _Type type;
  final bool scroll;
  final int crossAxisCount;

  const ShopProductsList.normal({
    Key? key,
    required this.products,
    this.shopifyProducts = const [],
    this.scroll = true,
  })  : type = _Type.normal,
        crossAxisCount = 0,
        super(key: key);

  const ShopProductsList.grid({
    Key? key,
    required this.products,
    this.scroll = true,
    this.crossAxisCount = 2,
    this.shopifyProducts = const [],
  })  : type = _Type.grid,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == _Type.normal ? _normalListBuilder() : _gridListBuilder();
  }

  Widget _normalListBuilder() {
    return ListView.builder(
      itemCount:
          shopifyProducts.isNotEmpty ? shopifyProducts.length : products.length,
      shrinkWrap: !scroll,
      physics: scroll
          ? AlwaysScrollableScrollPhysics()
          : NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var _product = products.length > index ? products[index] : null;

        if (shopifyProducts.isNotEmpty) {
          final _shopifyProduct = shopifyProducts[index];

          _product = Product(
            id: _shopifyProduct.id,
            name: _shopifyProduct.name,
            content: _shopifyProduct.content,
            price: _shopifyProduct.price,
            displayPhoto: _shopifyProduct.displayPhoto,
            photos: _shopifyProduct.photos,
            searchKeys: _shopifyProduct.searchKeys,
            website: _shopifyProduct.website,
          );
        }

        return ShopProductsListItem.normal(
          product: _product!,
        );
      },
    );
  }

  Widget _gridListBuilder() {
    return GridView.builder(
      shrinkWrap: !scroll,
      physics: scroll
          ? AlwaysScrollableScrollPhysics()
          : NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
      ),
      itemCount:
          shopifyProducts.isNotEmpty ? shopifyProducts.length : products.length,
      itemBuilder: (context, index) {
        var _product = products.length > index ? products[index] : null;

        if (shopifyProducts.isNotEmpty) {
          final _shopifyProduct = shopifyProducts[index];

          _product = Product(
            id: _shopifyProduct.id,
            name: _shopifyProduct.name,
            content: _shopifyProduct.content,
            price: _shopifyProduct.price,
            displayPhoto: _shopifyProduct.displayPhoto,
            photos: _shopifyProduct.photos,
            searchKeys: _shopifyProduct.searchKeys,
            website: _shopifyProduct.website,
          );
        }

        return ShopProductsListItem.grid(
          product: _product!,
        );
      },
    );
  }
}
