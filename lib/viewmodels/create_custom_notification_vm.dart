import 'package:flutter/material.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/models/custom_notification_model.dart';
import 'package:imhotep/services/firebase/database/custom_notification_provider.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:provider/provider.dart';

class CreateCustomNotificationVm extends BaseVm {
  final BuildContext context;
  CreateCustomNotificationVm(this.context);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  List<CustomNotification> get customNotifications =>
      context.watch<List<CustomNotification>>();
  TextEditingController get titleController => _titleController;
  TextEditingController get bodyController => _bodyController;

  // send notification
  void sendNotification() async {
    if (_titleController.text.trim().isEmpty ||
        _bodyController.text.trim().isEmpty)
      return showToast('Please fill up all the fields!');

    updateStateType(StateType.busy);
    final _customNotification = CustomNotification(
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
    );

    updateStateType(StateType.busy);
    await CustomNotificationProvider.sendNotification(
      customNotification: _customNotification,
      onSuccess: (_) {
        showToast('Successfully sent notification');
        clearValues();
      },
      onError: (_) {
        showToast('An unexpected error occured! Please try again later');
      },
    );
    updateStateType(StateType.idle);
  }

  void clearValues() {
    _titleController.clear();
    _bodyController.clear();
    notifyListeners();
  }
}
