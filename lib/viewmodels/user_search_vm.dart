import 'dart:async';

import 'package:flutter/material.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/viewmodels/base_vm.dart';

class UserSearchVm extends BaseVm {
  final BuildContext context;
  UserSearchVm(this.context);

  Timer? _debounce;
  bool _searchActive = false;
  final TextEditingController _searchController = TextEditingController();

  bool get searchActive => _searchActive;
  TextEditingController get searchController => _searchController;

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

  // update value of searchActive
  void _updateSearchActive(final bool newVal) {
    _searchActive = newVal;
    notifyListeners();
  }
}
