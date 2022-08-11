import 'dart:async';

import 'package:flutter/material.dart';
import 'package:imhotep/models/product_model.dart';
import 'package:imhotep/models/shopify_product.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:provider/provider.dart';

import '../enums/state_type.dart';

class ShopVm extends BaseVm {
  final BuildContext context;
  ShopVm(this.context);

  Timer? _debounce;
  bool _searchActive = false;
  final TextEditingController _searchController = TextEditingController();
  List<String> _categories = [];
  String _selectedCategory = 'All';

  bool get searchActive => _searchActive;
  TextEditingController get searchController => _searchController;
  List<Product> get products => context.watch<List<Product>>();
  List<ShopifyProduct> get shopifyProducts =>
      context.watch<List<ShopifyProduct>>();
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;

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

  // get categories from products
  List<String> getCategories(
    List<Product> prods, {
    final bool onlyBooksEbooks = false,
  }) {
    final _cats = <String>[];
    prods.forEach((e) {
      e.categories.forEach((f) {
        if (!_cats.contains(f)) {
          if (onlyBooksEbooks) {
            if (f == 'Books' || f == 'Ebooks') {
              _cats.add(f);
            }
          } else if (f != 'Ebooks') {
            _cats.add(f);
          }
        }
      });
    });

    _cats.sort((a, b) {
      return a.compareTo(b);
    });

    return _cats;
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

  // update value of categories
  void updateCategories(final List<String> newVal) {
    _categories = newVal;
    notifyListeners();
  }

  // update value of selectedCategory
  void updateSelectedCategory(final String newVal) {
    _selectedCategory = newVal;
    notifyListeners();
  }
}
