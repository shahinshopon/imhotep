import 'package:flutter/material.dart';
import 'package:imhotep/helpers/date_time_helper.dart';
import 'package:imhotep/models/custom_notification_model.dart';
import 'package:imhotep/viewmodels/create_custom_notification_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';

import '../constants.dart';
import '../enums/state_type.dart';
import '../widgets/common_widgets/hotep_button.dart';
import '../widgets/common_widgets/hotep_text_input.dart';

class CreateCustomNotificationScreen extends StatelessWidget {
  const CreateCustomNotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VMProvider<CreateCustomNotificationVm>(
      vm: CreateCustomNotificationVm(context),
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
              'Create Custom Notification',
              style: TextStyle(
                color: blackColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  _textInputBuilder(
                    title: 'Enter title of the notification:',
                    hintText: 'Notification Title',
                    controller: vm.titleController,
                  ),
                  _textInputBuilder(
                    title: 'Enter body of the notification:',
                    hintText: 'Notification Body',
                    controller: vm.bodyController,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Divider(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _notificationHistoryList(vm),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(
              10.0,
            ),
            child: HotepButton.filled(
              value: 'Create Notification',
              borderRadius: 15.0,
              padding: const EdgeInsets.all(15.0),
              loading: vm.stateType == StateType.busy,
              onPressed: vm.sendNotification,
            ),
          ),
        );
      },
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

  Widget _notificationHistoryList(final CreateCustomNotificationVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notification History: ',
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
          itemCount: vm.customNotifications.length,
          itemBuilder: (context, index) {
            final _notif = vm.customNotifications[index];
            return _notificationHistoryListItem(_notif);
          },
        ),
      ],
    );
  }

  Widget _notificationHistoryListItem(CustomNotification notification) {
    final _createdDate = DateTime.fromMillisecondsSinceEpoch(
      notification.createdAt!,
    );
    final _createdTime = TimeOfDay(
      hour: _createdDate.hour,
      minute: _createdDate.minute,
    );
    final _dateString = DateTimeHelper.getFormattedDate(_createdDate);
    final _timeString = DateTimeHelper.getFormattedTime(_createdTime);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          notification.title,
          style: TextStyle(
            color: blueColor,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        Text(
          notification.body,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(
          '${_dateString} ${_timeString}',
          style: TextStyle(
            fontSize: 12.0,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}
