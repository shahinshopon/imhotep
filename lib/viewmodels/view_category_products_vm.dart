import 'dart:async';

import 'package:flutter/material.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:provider/provider.dart';

import '../enums/state_type.dart';
import '../models/product_model.dart';
import '../models/shopify_product.dart';

class ViewCategoryProductsVm extends BaseVm {
  final BuildContext context;
  ViewCategoryProductsVm(this.context);

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _searchActive = false;

  List<Product> get products => context.watch<List<Product>>();
  List<ShopifyProduct> get shopifyProducts =>
      context.watch<List<ShopifyProduct>>();
  TextEditingController get searchController => _searchController;
  bool get searchActive => _searchActive;

  // dispose function
  void onDispose() {
    _debounce?.cancel();
  }

  // create debounce
  void createDebounce() {
    updateStateType(StateType.busy);
    _updateSearchActive(false);
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () {
      _updateSearchActive(_searchController.text.trim() != '');
      updateStateType(StateType.idle);
    });
  }

  // crear controller
  void clearController() {
    _searchController.clear();
    _updateSearchActive(false);
  }

  // update value of searchActive
  void _updateSearchActive(final bool newVal) {
    _searchActive = newVal;
    notifyListeners();
  }
}
