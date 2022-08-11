import 'package:flutter/material.dart';
import 'package:imhotep/viewmodels/shop_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';

import '../enums/state_type.dart';
import '../widgets/common_widgets/hotep_searchbar.dart';
import '../widgets/shop_widgets/categories_list.dart';

class ViewBooksEbooksScreen extends StatelessWidget {
  const ViewBooksEbooksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VMProvider<ShopVm>(
      vm: ShopVm(context),
      builder: (context, vm, appVm, appUser) {
        final _categories = vm.searchActive
            ? vm
                .getCategories(vm.products, onlyBooksEbooks: true)
                .where(
                  (element) => element.toUpperCase().contains(
                        vm.searchController.text.trim().toUpperCase(),
                      ),
                )
                .toList()
            : vm.getCategories(vm.products, onlyBooksEbooks: true);
        return Scaffold(
          body: SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  HotepSearchBar(
                    hintText: 'Search categories...',
                    controller: vm.searchController,
                    onChanged: (val) => vm.createDebounce(),
                    trailing: vm.searchActive
                        ? _cancelSearchBuilder(
                            context,
                            vm.clearController,
                          )
                        : null,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Expanded(
                    child: vm.stateType == StateType.busy
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : CategoriesList(
                            categories: _categories,
                            fromBooksAndEbooks: true,
                          ),
                  ),
                ],
              ),
            ),
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
