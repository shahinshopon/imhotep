import 'package:flutter/material.dart';

import '../models/temp_img_model.dart';

class TempImgVM extends ChangeNotifier {
  final BuildContext context;
  TempImgVM(this.context);

  List<TempImg> _tempImgs = [];
  List<TempImg> get tempImgs => _tempImgs;

  // add items to _tempImgsList
  void addItem(final TempImg newTempImg) {
    _tempImgs.add(newTempImg);
    notifyListeners();
  }

  // remove items from _tempImgsList
  void removeItem(final TempImg newTempImg) {
    _tempImgs.remove(newTempImg);
    notifyListeners();
  }
}
