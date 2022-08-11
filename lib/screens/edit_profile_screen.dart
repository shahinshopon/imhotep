import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/viewmodels/edit_profile_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';
import '../widgets/common_widgets/hotep_button.dart';
import '../widgets/common_widgets/hotep_text_input.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  abc() {}
  @override
  Widget build(BuildContext context) {
    final _appUser = context.watch<PeamanUser>();
    return VMProvider<EditProfileVm>(
      onInit: (vm) => vm.onInit(_appUser),
      vm: EditProfileVm(context),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          backgroundColor: whiteColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: whiteColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              color: blackColor,
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Edit Profile',
              style: TextStyle(
                color: blackColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: vm.pickImgFromGallery,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: (vm.profileImg?.path.contains(
                                    'firebase_img123',
                                  ) ??
                                  false)
                              ? CachedNetworkImageProvider(
                                  '${vm.profileImg?.path.replaceAll('firebase_img123', '')}',
                                )
                              : FileImage(vm.profileImg!) as ImageProvider,
                          backgroundColor: greyColorshade200,
                        ),
                        Positioned(
                          top: 55,
                          left: 0.0,
                          right: 0.0,
                          child: Center(
                            child: Text(
                              'Change photo',
                              style: TextStyle(
                                color: whiteColor,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    title: HotepTextInput.normal(
                      controller: vm.nameController,
                      hintText: 'Name',
                    ),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        searchAutofocus: true,
                        showPhoneCode: false,
                        onSelect: (Country country) {
                          vm.updateCountry(country.name);
                        },
                      );
                    },
                    title: Text(
                      vm.country == '' ? 'Select your country' : vm.country,
                    ),
                    trailing: vm.country == ''
                        ? null
                        : _cancelSearchBuilder(context, vm),
                  ),
                  Divider(),
                  ListTile(
                    title: HotepTextInput.normal(
                      controller: vm.bioController,
                      hintText: 'Bio',
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        HotepButton.filled(
                          value: 'Save Changes',
                          onPressed: () => vm.updateProfile(appUser),
                          borderRadius: 15.0,
                          padding: const EdgeInsets.all(15.0),
                          loading: vm.stateType == StateType.busy,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _cancelSearchBuilder(
    final BuildContext context,
    final EditProfileVm vm,
  ) {
    return GestureDetector(
      onTap: () {
        vm.updateCountry('');
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Color(0xffD6D5D5).withOpacity(0.7),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.close,
              size: 18.0,
              color: greyColor,
            ),
            SizedBox(
              width: 2.0,
            ),
            Text(
              'Clear',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: greyColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
