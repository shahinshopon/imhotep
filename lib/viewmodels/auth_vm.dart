import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:peaman/peaman.dart';
import 'base_vm.dart';

class AuthVm extends BaseVm {
  final BuildContext context;
  AuthVm(this.context);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _loadingGLogin = false;
  XFile? _profileImg;
  String? _country;

  TextEditingController get nameController => _nameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get bioController => _bioController;
  bool get loadingGLogin => _loadingGLogin;
  XFile? get profileImg => _profileImg;
  String? get country => _country;

  // login with email and password
  void loginWithEmailAndPassword() async {
    if (_emailController.text.trim() != '' &&
        _passwordController.text.trim() != '') {
      FocusScope.of(context).unfocus();
      updateStateType(StateType.busy);
      await PAuthProvider.loginWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        onError: (e) {
          _errorHandler(e.code);
          updateStateType(StateType.idle);
        },
      );
    } else {
      showToast('Please fill your email and password to continue!');
    }
  }

  // sign up with email and password
  void signUpWithEmailAndPassword() async {
    final _currentDate = DateTime.now();
    FocusScope.of(context).unfocus();
    if (_nameController.text.trim() != '' &&
        _emailController.text.trim() != '' &&
        _passwordController.text.trim() != '' &&
        _phoneController.text.trim() != '' &&
        _bioController.text.trim() != '') {
      if (_country != null) {
        if (_profileImg != null) {
          updateStateType(StateType.busy);
          final _photoUrl = await PStorageProvider.uploadFile(
            'profile_imgs/${_currentDate.millisecondsSinceEpoch}',
            File(_profileImg!.path),
          );

          final _appUser = PeamanUser(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            bio: _bioController.text.trim(),
            photoUrl: _photoUrl,
            country: _country,
            searchKeys: _getSearchKeys(),
          );

          await PAuthProvider.signUpWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            appUser: _appUser,
            onError: (e) {
              _errorHandler(e.code);
              updateStateType(StateType.idle);
            },
          );
        } else {
          showToast('Please select your profile image to continue!');
        }
      } else {
        showToast('Please select your country to continue!');
      }
    } else {
      showToast('Please fill in all the details to continue!');
    }
  }

  // sign up with gmail
  void signInWithGmail() async {
    updateLoadingGLogin(true);
    PAuthProvider.signInWithGoogle(
      onError: (_) {
        updateLoadingGLogin(false);
      },
    );
  }

  // error handler
  void _errorHandler(final String code) {
    String _description = '';
    print(code);
    switch (code) {
      case 'wrong-password':
        _description =
            'The password you have entered is not correct. Please try again.';
        break;
      case 'weak-password':
        _description =
            'Your password is too short. Please enter a password with atleast 6 characters.';
        break;
      case 'email-already-in-use':
        _description =
            'This email has already been used. Please try again with a different one.';
        break;
      default:
        _description = 'An unexpected error occured! \n[code: $code]';
    }

    Fluttertoast.showToast(msg: _description);
  }

  // update user details
  void updateUserDetails(final PeamanUser existingUser) async {
    final _currentDate = DateTime.now();
    FocusScope.of(context).unfocus();
    if (_nameController.text.trim() != '' &&
        _phoneController.text.trim() != '' &&
        _bioController.text.trim() != '') {
      if (_country != null) {
        if (_profileImg != null) {
          updateLoadingGLogin(true);
          final _photoUrl = await PStorageProvider.uploadFile(
            'profile_imgs/${_currentDate.millisecondsSinceEpoch}',
            File(_profileImg!.path),
          );

          final _appUser = PeamanUser(
            uid: existingUser.uid,
            email: existingUser.email,
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            bio: _bioController.text.trim(),
            photoUrl: _photoUrl,
            country: _country,
            searchKeys: _getSearchKeys(),
          );

          await PUserProvider.updateUserData(
            uid: existingUser.uid!,
            data: _appUser.toJson(),
          );
        } else {
          showToast('Please select your profile image to continue!');
        }
      } else {
        showToast('Please select your country to continue!');
      }
    } else {
      showToast('Please fill in all the details to continue!');
    }
  }

  // logout
  void logOut() {
    PAuthProvider.logOut();
  }

  // get search keys from name and bio
  List<String> _getSearchKeys() {
    var _searchKeys = <String>[];
    final _name = _nameController.text.trim();
    final _bio = _bioController.text.trim();
    final _bios = _bio.split(' ');

    // split letters of name
    for (int i = 0; i < _name.length; i++) {
      final _letter = _name.substring(0, i + 1);
      if (!_searchKeys.contains(_letter.toUpperCase())) {
        _searchKeys.add(_letter.toUpperCase());
      }
    }
    //

    // split letters of bio
    for (int i = 0; i < _bios.length; i++) {
      for (int j = 0; j < _bios[i].length; j++) {
        final _letter = _bios[i].substring(0, j + 1);
        if (!_searchKeys.contains(_letter.toUpperCase())) {
          _searchKeys.add(_letter.toUpperCase());
        }
      }
    }
    //

    return _searchKeys
        .where((element) =>
            element.trim() != '' &&
            element.trim() != ',' &&
            element.trim() != '.')
        .toList();
  }

  // update value of profileImg
  void updateProfileImage(final XFile newVal) {
    _profileImg = newVal;
    notifyListeners();
  }

  // update value of country
  void updateCountry(final String newVal) {
    _country = newVal;
    notifyListeners();
  }

  // update value of loadingGLogin
  void updateLoadingGLogin(final bool newVal) {
    _loadingGLogin = newVal;
    notifyListeners();
  }
}
