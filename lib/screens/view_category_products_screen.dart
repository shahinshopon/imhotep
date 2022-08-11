import 'package:flutter/material.dart';
import 'package:imhotep/viewmodels/view_category_products_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/shop_widgets/shop_products_list.dart';

import '../constants.dart';
import '../enums/state_type.dart';
import '../widgets/common_widgets/hotep_searchbar.dart';

class ViewCategoryProductsScreen extends StatelessWidget {
  final String category;
  final bool mergeBooksAndEbooks;
  const ViewCategoryProductsScreen({
    Key? key,
    required this.category,
    this.mergeBooksAndEbooks = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VMProvider<ViewCategoryProductsVm>(
      onDispose: (vm) => vm.onDispose(),
      vm: ViewCategoryProductsVm(context),
      builder: (context, vm, appVm, appUser) {
        final _products = vm.searchActive
            ? vm.products
                .where(
                  (element) {
                    if (mergeBooksAndEbooks && category == 'Books') {
                      return element.categories.contains('Books') ||
                          element.categories.contains('Ebooks');
                    }
                    return element.categories.contains(category);
                  },
                )
                .where(
                  (element) => element.searchKeys.contains(
                    vm.searchController.text.trim().toUpperCase(),
                  ),
                )
                .toList()
            : vm.products.where(
                (element) {
                  if (mergeBooksAndEbooks && category == 'Books') {
                    return element.categories.contains('Books') ||
                        element.categories.contains('Ebooks');
                  }
                  return element.categories.contains(category);
                },
              ).toList();

        final _shopifyProducts = vm.searchActive
            ? vm.shopifyProducts
                .where(
                  (element) => element.searchKeys.contains(
                    vm.searchController.text.trim().toUpperCase(),
                  ),
                )
                .toList()
            : vm.shopifyProducts;
        return Scaffold(
          backgroundColor: whiteColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: whiteColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              color: blackColor,
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              category,
              style: TextStyle(
                color: blackColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              HotepSearchBar(
                hintText: 'Search products...',
                controller: vm.searchController,
                trailing: vm.searchActive
                    ? _cancelSearchBuilder(
                        context,
                        vm.clearController,
                      )
                    : null,
                onChanged: (val) => vm.createDebounce(),
              ),
              SizedBox(
                height: 15.0,
              ),
              Expanded(
                child: vm.stateType == StateType.busy
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ShopProductsList.grid(
                        products: _products,
                        shopifyProducts:
                            category == 'Clothing' ? _shopifyProducts : [],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _cancelSearchBuilder(
    final BuildContext context,
    final Function()? onPressed,
  ) {
    return GestureDetector(
      onTap: () {
        onPressed?.call();
        FocusScope.of(context).requestFocus();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Color(0xffD6D5D5),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        child: Row(
          children: [
            Icon(
              Icons.close,
              size: 18.0,
              color: Color(0xff888888),
            ),
            SizedBox(
              width: 2.0,
            ),
            Text(
              'Cancel',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: Color(0xff888888),
              ),
            )
          ],
        ),
      ),
    );
  }
}
