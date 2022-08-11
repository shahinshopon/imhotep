import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imhotep/enums/state_type.dart';

class BaseVm extends ChangeNotifier {
  StateType _stateType = StateType.idle;
  StateType get stateType => _stateType;

  // update value of stateType
  void updateStateType(final StateType newVal) {
    _stateType = newVal;
    notifyListeners();
  }

  // show a toast message to user
  void showToast(final String msg) async {
    await Fluttertoast.showToast(msg: msg);
  }
}
