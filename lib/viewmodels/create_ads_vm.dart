import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/helpers/dialog_provider.dart';
import 'package:imhotep/models/custom_ad_model.dart';
import 'package:imhotep/services/firebase/database/custom_ads_provider.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

class CreateAdsVm extends BaseVm {
  final BuildContext context;
  CreateAdsVm(this.context);

  File? _imgFile;
  TextEditingController _linkController = TextEditingController();
  TextEditingController _priorityController = TextEditingController();
  CustomAd? _adToEdit;
  ScrollController _scrollController = ScrollController();

  File? get imgFile => _imgFile;
  List<CustomAd> get customAds => context.watch<List<CustomAd>>();
  TextEditingController get linkController => _linkController;
  TextEditingController get priorityController => _priorityController;
  CustomAd? get adToEdit => _adToEdit;
  ScrollController get scrollController => _scrollController;

  // create ads
  void createAds(final PeamanUser appUser) async {
    FocusScope.of(context).unfocus();
    final _currentDate = DateTime.now();
    if (_linkController.text.trim().isEmpty)
      return showToast('Please enter link!');
    if (_imgFile == null) return showToast('Please upload a picture!');

    updateStateType(StateType.busy);
    final _imgUrl = await PStorageProvider.uploadFile(
      'custom_ads_imgs/${appUser.uid}/${_currentDate.millisecondsSinceEpoch}',
      _imgFile!,
    );

    if (_imgUrl == null)
      return showToast('An Unexpected error occured! Try again later');

    final _priority = _priorityController.text.trim().isEmpty
        ? '1.0'
        : _priorityController.text.trim();
    final _customAd = CustomAd(
      photoUrl: _imgUrl,
      link: _linkController.text.trim(),
      priority: double.parse(_priority),
    );

    await CustomAdsProvider.createCustomAd(customAd: _customAd);
    updateStateType(StateType.idle);
    clearValues();
    showToast('Ad created successfully!');
  }

  // edit ads
  void editAds(final PeamanUser appUser) async {
    FocusScope.of(context).unfocus();
    final _currentDate = DateTime.now();
    if (_linkController.text.trim().isEmpty)
      return showToast('Please enter link!');
    if (_imgFile == null) return showToast('Please upload a picture!');

    updateStateType(StateType.busy);
    var _imgUrl = _imgFile!.path.replaceAll('_firebaseImg123', '');

    if (!_imgFile!.path.contains('_firebaseImg123')) {
      final _url = await PStorageProvider.uploadFile(
        'custom_ads_imgs/${appUser.uid}/${_currentDate.millisecondsSinceEpoch}',
        _imgFile!,
      );

      if (_url == null)
        return showToast('An Unexpected error occured! Try again later');

      _imgUrl = _url;
    }

    final _priority = _priorityController.text.trim().isEmpty
        ? '1.0'
        : _priorityController.text.trim();
    final _customAd = CustomAd(
      id: _adToEdit!.id!,
      photoUrl: _imgUrl,
      link: _linkController.text.trim(),
      priority: double.parse(_priority),
    );

    await CustomAdsProvider.updateCustomAd(
      customAdId: _adToEdit!.id!,
      data: _customAd.toJson(),
    );
    updateStateType(StateType.idle);
    clearValues();
    updateAdToEdit(null);
    showToast('Ad updated successfully!');
  }

  // delete ads
  void deleteAds(final CustomAd customAd) {
    DialogProvider(context).showAlertDialog(
      title: 'Are you sure you want to delete?',
      description: 'This action is permanent and cannot be undone!',
      onPressedPositiveBtn: () {
        CustomAdsProvider.deleteCustomAd(
          customAdId: customAd.id!,
        );
      },
    );
  }

  // initialize values
  void initializeValues() {
    if (_adToEdit != null) {
      _imgFile = File('${_adToEdit!.photoUrl}_firebaseImg123');
      _linkController.text = _adToEdit!.link;
      _priorityController.text = '${_adToEdit!.priority}';

      notifyListeners();
    }
  }

  // clear values
  void clearValues() {
    _imgFile = null;
    _linkController.clear();
    _priorityController.clear();

    notifyListeners();
  }

  // upload photo
  void uploadPhoto() async {
    final _pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (_pickedFile != null) {
      final _file = File(_pickedFile.path);
      updateImgFile(_file);
    }
  }

  // update value of imgFile
  void updateImgFile(final File newVal) {
    _imgFile = newVal;
    notifyListeners();
  }

  // update adToEdit
  void updateAdToEdit(final CustomAd? newVal) {
    _adToEdit = newVal;
    notifyListeners();
  }
}
