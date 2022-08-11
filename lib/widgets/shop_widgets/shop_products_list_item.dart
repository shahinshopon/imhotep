import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:imhotep/models/product_model.dart';
import 'package:imhotep/screens/view_single_product_screen.dart';
import 'package:imhotep/widgets/common_widgets/hotep_button.dart';
import '../../constants.dart';

enum _Type {
  normal,
  grid,
}

class ShopProductsListItem extends StatelessWidget {
  final Product product;
  final _Type type;

  ShopProductsListItem.normal({
    Key? key,
    required this.product,
  })  : type = _Type.normal,
        super(key: key);

  ShopProductsListItem.grid({
    Key? key,
    required this.product,
  })  : type = _Type.grid,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == _Type.normal
        ? _normalItemBuilder(context)
        : _gridItemBuilder(context);
  }

  Widget _normalItemBuilder(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ViewSingleProductScreen(
                    product: product,
                  ),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: greyColorshade200,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(product.displayPhoto),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  color: blueColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 5.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        HotepButton.filled(
                          value: 'View Product',
                          color: whiteColor,
                          textStyle: TextStyle(
                            color: blueColor,
                            fontSize: 16.0,
                          ),
                          borderRadius: 10.0,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 20.0,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ViewSingleProductScreen(
                                  product: product,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 25,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                color: blueColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 10.0,
              ),
              child: Text(
                '\$${product.price}',
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gridItemBuilder(final BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ViewSingleProductScreen(
              product: product,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: greyColorshade200,
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              product.displayPhoto,
            ),
            fit: BoxFit.cover,
          ),
        ),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.all(10.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           color: blueColor,
        //           borderRadius: BorderRadius.circular(20.0),
        //         ),
        //         padding: const EdgeInsets.symmetric(
        //           horizontal: 10.0,
        //           vertical: 5.0,
        //         ),
        //         child: Text(
        //           '\$${product.price}',
        //           style: TextStyle(
        //             color: whiteColor,
        //             fontSize: 12.0,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
