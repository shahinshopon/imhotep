import 'dart:async';

import 'package:flutter/material.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:peaman/peaman.dart';

class FeedSearchVm extends BaseVm {
  Timer? _debounce;
  Timer? _pause;
  bool _searchActive = false;
  final TextEditingController _searchController = TextEditingController();
  List<PeamanFeed> _randomFeeds = [];

  bool get searchActive => _searchActive;
  TextEditingController get searchController => _searchController;
  List<PeamanFeed> get randomFeeds => _randomFeeds;

  // init function
  void onInit(final List<PeamanFeed> allFeeds) {
    var _allFeeds = <PeamanFeed>[];

    allFeeds.forEach((element) {
      _allFeeds.add(element);
    });

    _allFeeds.shuffle();
    _allFeeds = _allFeeds.sublist(
      0,
      _allFeeds.length >= 50 ? 50 : _allFeeds.length,
    );

    _randomFeeds = _allFeeds;
    notifyListeners();
  }

  // dispose function
  void onDispose() {
    _debounce?.cancel();
    _pause?.cancel();
  }

  // create debounce
  void createDebounce() {
    updateStateType(StateType.busy);
    _updateSearchActive(false);
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () {
      _updateSearchActive(_searchController.text.trim() != '');
      updateStateType(StateType.idle);

      if (_pause?.isActive ?? false) _pause?.cancel();
      _pause = Timer(Duration(milliseconds: 1000), () {
        notifyListeners();
      });
    });
  }

  // update value of searchActive
  void _updateSearchActive(final bool newVal) {
    _searchActive = newVal;
    notifyListeners();
  }
}
