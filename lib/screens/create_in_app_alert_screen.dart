import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:imhotep/helpers/date_time_helper.dart';
import 'package:imhotep/viewmodels/create_in_app_alert_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/common_widgets/rounded_icon_button.dart';
import 'package:imhotep/widgets/inapp_alert_widgets/inapp_alert_dialog_content.dart';

import '../constants.dart';
import '../enums/state_type.dart';
import '../widgets/common_widgets/hotep_button.dart';
import '../widgets/common_widgets/hotep_text_input.dart';

class CreateInAppAlertScreen extends StatelessWidget {
  const CreateInAppAlertScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VMProvider<CreateInAppAlertVm>(
      vm: CreateInAppAlertVm(context),
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
              'Create In-App Alert',
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
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _uploadPhotoBuilder(vm),
                    _textInputBuilder(
                      title: 'Add Title:',
                      hintText: 'Title',
                      controller: vm.titleController,
                    ),
                    _textInputBuilder(
                      title: 'Add Description:',
                      hintText: 'Description',
                      controller: vm.descriptionController,
                      textInputType: TextInputType.multiline,
                    ),
                    _dateSelectorBuilder(
                      title: 'Add Expiry Date:',
                      subTitle: vm.expiryDate == null
                          ? 'Expiry Date'
                          : DateTimeHelper.getFormattedDate(vm.expiryDate!),
                      onPressed: vm.openDatePicker,
                    ),
                    _dateSelectorBuilder(
                      title: 'Add Expiry Time:',
                      subTitle: vm.expiryTime == null
                          ? 'Expiry Time'
                          : DateTimeHelper.getFormattedTime(vm.expiryTime!),
                      onPressed: vm.openTimePicker,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    if (vm.inAppAlert != null) _yourAlertBuilder(vm),
                    if (vm.inAppAlert != null)
                      SizedBox(
                        height: 20.0,
                      ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(
              10.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: HotepButton.filled(
                    value: vm.inAppAlertToEdit == null
                        ? 'Create Alert'
                        : 'Update Alert',
                    borderRadius: 15.0,
                    padding: const EdgeInsets.all(15.0),
                    loading: vm.stateType == StateType.busy,
                    onPressed: () {
                      if (vm.inAppAlertToEdit == null) {
                        vm.createAlert(appUser!);
                      } else {
                        vm.updateAlert(appUser!);
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                if (vm.inAppAlertToEdit != null)
                  Expanded(
                    child: HotepButton.bordered(
                      value: 'Cancel',
                      borderRadius: 15.0,
                      padding: const EdgeInsets.all(15.0),
                      loading: vm.stateType == StateType.busy,
                      onPressed: () {
                        vm.updateInAppAlertToEdit(null);
                        vm.clearValues();
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _uploadPhotoBuilder(final CreateInAppAlertVm vm) {
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
          onTap: vm.pickImage,
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
          requiredCapitalization: false,
        ),
      ],
    );
  }

  Widget _dateSelectorBuilder({
    required final String title,
    required final String subTitle,
    final Function()? onPressed,
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
        HotepButton.filled(
          value: subTitle,
          onPressed: onPressed,
          color: Colors.green,
          padding: const EdgeInsets.all(0.0),
        ),
      ],
    );
  }

  Widget _yourAlertBuilder(final CreateInAppAlertVm vm) {
    final _inAppAlert = vm.inAppAlert!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.0,
        ),
        Text(
          'Your in-app alert:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff3D4A5A),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: greyColorshade300,
                offset: Offset(2.0, 2.0),
                blurRadius: 10.0,
              ),
            ],
          ),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      RoundIconButton(
                        icon: Icon(
                          Icons.edit_rounded,
                          color: whiteColor,
                        ),
                        bgColor: blackColor.withOpacity(0.6),
                        padding: const EdgeInsets.all(8.0),
                        onPressed: () {
                          vm.updateInAppAlertToEdit(_inAppAlert);
                          vm.initializeValues(_inAppAlert);
                        },
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      RoundIconButton(
                        icon: Icon(
                          Icons.delete_rounded,
                          color: Colors.red,
                        ),
                        bgColor: redAccentColor.withOpacity(0.2),
                        padding: const EdgeInsets.all(8.0),
                        onPressed: () => vm.deleteAlert(_inAppAlert),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      RoundIconButton(
                        icon: Icon(
                          _inAppAlert.deactivated
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          color: whiteColor,
                        ),
                        bgColor: blackColor.withOpacity(0.6),
                        padding: const EdgeInsets.all(8.0),
                        onPressed: () {
                          if (_inAppAlert.deactivated) {
                            vm.activateAlert(_inAppAlert);
                          } else {
                            vm.deactivateAlert(_inAppAlert);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              InAppAlertDialogContent(
                inAppAlert: _inAppAlert,
                fromCreateScreen: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
