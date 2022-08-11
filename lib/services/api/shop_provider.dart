import 'package:dio/dio.dart';
import 'package:imhotep/models/product_model.dart';
import 'package:imhotep/models/shopify_product.dart';

const _websiteProducts = 'https://mrimhotep.org/wp-json/api/v1/products';
const _shopifyProducts =
    'https://montu-team.myshopify.com/admin/api/2022-01/products.json';

class ShopProvider {
  // fetch products
  static Future<List<Product>> getProductsFromWebsite() async {
    final _products = <Product>[];
    try {
      final _dio = Dio(BaseOptions(contentType: 'application/json'));

      final _res = await _dio.get(_websiteProducts);
      final _data = List<Map<String, dynamic>>.from(_res.data ?? []);

      _data.forEach((e) {
        final _product = Product.fromJson(e);
        _products.add(_product);
      });
    } catch (e) {
      print(e);
      print('Error!!!: Getting products from website');
    }
    return _products;
  }

  // fetch products
  static Future<List<ShopifyProduct>> getProductsFromShopify() async {
    final _products = <ShopifyProduct>[];
    try {
      final _dio = Dio(BaseOptions(contentType: 'application/json'));
      final _res = await _dio.get(
        _shopifyProducts,
        options: Options(
          headers: {
            'X-Shopify-Access-Token': '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'
          },
        ),
      );
      final _data = List<Map<String, dynamic>>.from(
        (_res.data ?? {})['products'] ?? [],
      );

      _data.forEach((e) {
        final _product = ShopifyProduct.fromJson(e);
        _products.add(_product);
      });
    } catch (e) {
      print(e);
      print('Error!!!: Getting products from shopify');
    }
    return _products;
  }
}
