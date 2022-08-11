import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:imhotep/models/custom_ad_model.dart';
import 'package:imhotep/viewmodels/create_ads_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/common_widgets/rounded_icon_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../enums/state_type.dart';
import '../widgets/common_widgets/hotep_button.dart';
import '../widgets/common_widgets/hotep_text_input.dart';

class CreateAdsScreen extends StatelessWidget {
  const CreateAdsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VMProvider<CreateAdsVm>(
      vm: CreateAdsVm(context),
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
              'Create Custom Ad',
              style: TextStyle(
                color: blackColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            controller: vm.scrollController,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  _uploadPhotoBuilder(vm),
                  _textInputBuilder(
                    title: 'Add link:',
                    hintText: 'Link',
                    controller: vm.linkController,
                  ),
                  _textInputBuilder(
                    title: 'Add priority:',
                    hintText: 'Priority 1-100',
                    controller: vm.priorityController,
                    textInputType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: HotepButton.filled(
                          value:
                              vm.adToEdit == null ? 'Create Ad' : 'Update Ad',
                          borderRadius: 15.0,
                          padding: const EdgeInsets.all(15.0),
                          loading: vm.stateType == StateType.busy,
                          onPressed: () {
                            if (vm.adToEdit == null) {
                              vm.createAds(appUser!);
                            } else {
                              vm.editAds(appUser!);
                            }
                          },
                        ),
                      ),
                      if (vm.adToEdit != null)
                        SizedBox(
                          width: 10.0,
                        ),
                      if (vm.adToEdit != null)
                        Expanded(
                          child: HotepButton.bordered(
                            value: 'Cancel',
                            borderRadius: 15.0,
                            padding: const EdgeInsets.all(15.0),
                            loading: vm.stateType == StateType.busy,
                            onPressed: () {
                              vm.clearValues();
                              vm.updateAdToEdit(null);
                            },
                          ),
                        ),
                    ],
                  ),
                  if (vm.customAds.isNotEmpty)
                    SizedBox(
                      height: 20.0,
                    ),
                  if (vm.customAds.isNotEmpty) Divider(),
                  if (vm.customAds.isNotEmpty)
                    SizedBox(
                      height: 20.0,
                    ),
                  if (vm.customAds.isNotEmpty) _createAdsList(vm),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _uploadPhotoBuilder(final CreateAdsVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Photo:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff3D4A5A),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        GestureDetector(
          onTap: vm.uploadPhoto,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 200.0,
            decoration: BoxDecoration(
              border: Border.all(
                color: blueColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(10.0),
              image: vm.imgFile == null
                  ? null
                  : DecorationImage(
                      image: vm.imgFile!.path.contains('_firebaseImg123')
                          ? CachedNetworkImageProvider(
                              vm.imgFile!.path.replaceAll(
                                '_firebaseImg123',
                                '',
                              ),
                            )
                          : FileImage(vm.imgFile!) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
            ),
            child: Center(
              child: Icon(
                Icons.upload,
                color: blueColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _textInputBuilder({
    required final String title,
    required final String hintText,
    required final TextEditingController controller,
    final TextInputType textInputType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.0,
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff3D4A5A),
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        HotepTextInput.bordered(
          hintText: hintText,
          controller: controller,
          isExpanded: true,
          textInputType: textInputType,
        ),
      ],
    );
  }

  Widget _createAdsList(final CreateAdsVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Ads: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff3D4A5A),
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: vm.customAds.length,
          itemBuilder: (context, index) {
            final _ad = vm.customAds[index];
            return _createdAdsListItem(vm, _ad);
          },
        ),
      ],
    );
  }

  Widget _createdAdsListItem(final CreateAdsVm vm, final CustomAd ad) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        height: 200.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: blueColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: CachedNetworkImageProvider(ad.photoUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: blackColor.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Text(
                              'Priority: ${ad.priority}',
                              style: TextStyle(
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      RoundIconButton(
                        icon: Icon(
                          Icons.edit_rounded,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        onPressed: () {
                          vm.updateAdToEdit(ad);
                          vm.initializeValues();

                          vm.scrollController.animateTo(
                            0,
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.ease,
                          );
                        },
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      RoundIconButton(
                        icon: Icon(
                          Icons.delete_rounded,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        onPressed: () => vm.deleteAds(ad),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: blackColor.withOpacity(0.6),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Linkify(
                    text: ad.link,
                    onOpen: (link) async {
                      try {
                        await launch(link.url);
                      } catch (e) {
                        print(e);
                      }
                    },
                    linkStyle: TextStyle(color: whiteColor),
                    style: TextStyle(
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
