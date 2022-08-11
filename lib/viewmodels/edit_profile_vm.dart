import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:peaman/peaman.dart';

class EditProfileVm extends BaseVm {
  final BuildContext context;
  EditProfileVm(this.context);

  File? _profileImg;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String _country = '';

  File? get profileImg => _profileImg;
  TextEditingController get nameController => _nameController;
  String get country => _country;
  TextEditingController get bioController => _bioController;

  // initial function
  void onInit(final PeamanUser appUser) {
    _initializeValues(appUser);
  }

  // initialize values
  void _initializeValues(final PeamanUser appUser) {
    _nameController.text = appUser.name ?? '';
    _country = appUser.country ?? '';
    _bioController.text = appUser.bio ?? '';
    _profileImg = File('${appUser.photoUrl}_firebase_img123');

    notifyListeners();
  }

  // update user profile
  void updateProfile(final PeamanUser? appUser) async {
    FocusScope.of(context).unfocus();
    if (_nameController.text.trim() == '') {
      showToast('Name must be provided!');
      return;
    }
    updateStateType(StateType.busy);
    var _imgUrl = _profileImg?.path.replaceAll('firebase_img123', '');
    if (!(_profileImg?.path.contains('firebase_img123') ?? false)) {
      _imgUrl = await PStorageProvider.uploadFile(
        'profile_imgs/${appUser?.uid}',
        _profileImg!,
      );
    }
    await PUserProvider.updateUserData(
      uid: appUser!.uid!,
      data: {
        'name': _nameController.text.trim(),
        'country': _country,
        'bio': _bioController.text.trim(),
        'photo_url': _imgUrl,
      },
    );
    showToast('Updated profile successfully');
    updateStateType(StateType.idle);
  }

  // pick image from gallery
  void pickImgFromGallery() async {
    final _pickedImg = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (_pickedImg != null) {
      final _newImg = File(_pickedImg.path);
      updateProfileImg(_newImg);
    }
  }

  // update value of profileImg
  void updateProfileImg(final File newVal) {
    _profileImg = newVal;
    notifyListeners();
  }

  // update value of country
  void updateCountry(final String newVal) {
    _country = newVal;
    notifyListeners();
  }
}
