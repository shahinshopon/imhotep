import 'package:flutter/material.dart';
import 'package:imhotep/widgets/notifications_widget/notification_list_Item.dart';
import 'package:peaman/peaman.dart';

class NotificationsList extends StatelessWidget {
  final List<PeamanNotification> notifications;
  const NotificationsList({
    Key? key,
    required this.notifications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final _notification = notifications[index];
        final _widget = NotificationListItem(
          notification: _notification,
        );

        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: _widget,
          );
        }

        return _widget;
      },
    );
  }
}
