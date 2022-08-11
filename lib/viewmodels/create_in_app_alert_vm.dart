import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/helpers/dialog_provider.dart';
import 'package:imhotep/models/inapp_alert_model.dart';
import 'package:imhotep/services/firebase/database/inapp_alert_provider.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

class CreateInAppAlertVm extends BaseVm {
  final BuildContext context;
  CreateInAppAlertVm(this.context);

  File? _imgFile;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  DateTime? _expiryDate;
  TimeOfDay? _expiryTime;
  InAppAlert? _inAppAlertToEdit;

  InAppAlert? get inAppAlert => context.watch<InAppAlert?>();
  File? get imgFile => _imgFile;
  TextEditingController get titleController => _titleController;
  TextEditingController get descriptionController => _descriptionController;
  ScrollController get scrollController => _scrollController;
  DateTime? get expiryDate => _expiryDate;
  TimeOfDay? get expiryTime => _expiryTime;
  InAppAlert? get inAppAlertToEdit => _inAppAlertToEdit;

  // create alert
  void createAlert(final PeamanUser appUser) async {
    final _currentDate = DateTime.now();

    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty)
      return showToast('Please fill up all the fields!');

    if (_imgFile == null) return showToast('Please select an image!');

    updateStateType(StateType.busy);
    final _imgUrl = await PStorageProvider.uploadFile(
      'in_app_alerts_imgs/${appUser.uid}/${_currentDate.millisecondsSinceEpoch}',
      _imgFile!,
    );

    if (_imgUrl == null)
      return showToast(
        'An unexpected error occured! Please try again later',
      );

    final _date = DateTime(
      _expiryDate!.year,
      _expiryDate!.month,
      _expiryDate!.day,
      _expiryTime!.hour,
      _expiryTime!.minute,
    );

    final _alert = InAppAlert(
      imgUrl: _imgUrl,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      expiresAt: _date.millisecondsSinceEpoch,
    );

    await InAppAlertProvider.createAlert(
      alert: _alert,
      onSuccess: (_) {
        showToast('In-App Alert created successfully!');
        clearValues();
      },
      onError: (e) {
        showToast('An unexpected error occured!');
      },
    );
    updateStateType(StateType.idle);
  }

  // update alert
  void updateAlert(final PeamanUser appUser) async {
    final _currentDate = DateTime.now();

    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty)
      return showToast('Please fill up all the fields!');

    if (_imgFile == null) return showToast('Please select an image!');

    updateStateType(StateType.busy);
    String? _imgUrl = _imgFile!.path;

    if (!_imgFile!.path.contains('_firebaseImg123')) {
      _imgUrl = await PStorageProvider.uploadFile(
        'in_app_alerts_imgs/${appUser.uid}/${_currentDate.millisecondsSinceEpoch}',
        _imgFile!,
      );

      if (_imgUrl == null)
        return showToast(
          'An unexpected error occured! Please try again later',
        );
    }

    final _date = DateTime(
      _expiryDate!.year,
      _expiryDate!.month,
      _expiryDate!.day,
      _expiryTime!.hour,
      _expiryTime!.minute,
    );

    final _alert = InAppAlert(
      id: _inAppAlertToEdit!.id,
      deactivated: _inAppAlertToEdit!.deactivated,
      imgUrl: _imgUrl,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      expiresAt: _date.millisecondsSinceEpoch,
    );

    await InAppAlertProvider.updateAlert(
      alertId: _alert.id!,
      data: _alert.toJson(),
      onSuccess: () {
        showToast('In-App Alert updated successfully!');
        updateInAppAlertToEdit(null);
        clearValues();
      },
      onError: (e) {
        showToast('An unexpected error occured!');
      },
    );
    updateStateType(StateType.idle);
  }

  // deactivate alert
  void deactivateAlert(final InAppAlert alert) {
    InAppAlertProvider.deactivateAlert(
      alertId: alert.id!,
    );
  }

  // activate alert
  void activateAlert(final InAppAlert alert) {
    InAppAlertProvider.activateAlert(
      alertId: alert.id!,
    );
  }

  // delete alert
  void deleteAlert(final InAppAlert alert) {
    DialogProvider(context).showAlertDialog(
      title: 'Are you sure you want to delete the alert ?',
      description: 'The action is permanent and cannot be undone',
      onPressedPositiveBtn: () {
        InAppAlertProvider.deleteAlert(
          alertId: alert.id!,
        );
      },
    );
  }

  // pick image
  void pickImage() async {
    final _pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (_pickedImage != null) {
      final _newImg = File(_pickedImage.path);
      updateImgFile(_newImg);
    }
  }

  // open date picker
  void openDatePicker() async {
    FocusScope.of(context).unfocus();
    final _date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(days: 1095),
      ),
    );

    if (_date != null) {
      updateStartsAtDate(_date);
    }
  }

  // open time picker
  void openTimePicker() async {
    FocusScope.of(context).unfocus();
    final _time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (_time != null) {
      updateStartsAtTime(_time);
    }
  }

  // initialize values
  void initializeValues(final InAppAlert alert) {
    _imgFile = File('${alert.imgUrl}_firebaseImg123');
    _titleController.text = alert.title;
    _descriptionController.text = alert.description;
    _expiryDate = DateTime.fromMillisecondsSinceEpoch(alert.expiresAt);
    _expiryTime = TimeOfDay(
      hour: _expiryDate!.hour,
      minute: _expiryDate!.minute,
    );
    notifyListeners();

    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  // clear values
  void clearValues() {
    _imgFile = null;
    _titleController.clear();
    _descriptionController.clear();
    _expiryDate = null;
    _expiryTime = null;
    notifyListeners();
  }

  // update value of imgFile
  void updateImgFile(final File? newVal) {
    _imgFile = newVal;
    notifyListeners();
  }

  // update value of startsAtDate
  void updateStartsAtDate(final DateTime newVal) {
    _expiryDate = newVal;
    notifyListeners();
  }

  // update value of startsAtTime
  void updateStartsAtTime(final TimeOfDay newVal) {
    _expiryTime = newVal;
    notifyListeners();
  }

  // update value of in-app alert to edit
  void updateInAppAlertToEdit(final InAppAlert? newVal) {
    _inAppAlertToEdit = newVal;
    notifyListeners();
  }
}
