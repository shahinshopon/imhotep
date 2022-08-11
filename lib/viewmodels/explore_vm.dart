import 'package:flutter/material.dart';
import 'package:imhotep/models/editor_access_config_mode.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

class ExploreVm extends BaseVm {
  final BuildContext context;
  ExploreVm(this.context);

  int _currentTabIndex = 0;
  final ScrollController _scrollController = ScrollController();

  List<PeamanFeed>? get allFeeds => context.watch<List<PeamanFeed>?>();
  List<PeamanMoment>? get allMoments => context.watch<List<PeamanMoment>?>();
  EditorAccessConfig get editorConfig => context.watch<EditorAccessConfig>();
  int get currentTabIndex => _currentTabIndex;
  ScrollController get scrollController => _scrollController;

  // scroll list to top
  void scrollListToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeOut,
    );
  }

  // update value of currentTabIndex
  void updateCurrentTabIndex(final int newVal) {
    _currentTabIndex = newVal;
    notifyListeners();
  }
}
