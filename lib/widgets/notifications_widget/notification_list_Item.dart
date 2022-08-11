import 'package:flutter/material.dart';
import 'package:imhotep/enums/notification_type.dart';
import 'package:imhotep/helpers/common_helper.dart';
import 'package:imhotep/viewmodels/notification_item_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/common_widgets/avatar_builder.dart';
import 'package:imhotep/widgets/common_widgets/hotep_button.dart';
import 'package:imhotep/widgets/common_widgets/user_fetcher.dart';
import 'package:peaman/peaman.dart';
import '../../constants.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../helpers/notification_navigation_helper.dart';

class NotificationListItem extends StatefulWidget {
  final PeamanNotification notification;
  const NotificationListItem({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  State<NotificationListItem> createState() => _NotificationListItemState();
}

class _NotificationListItemState extends State<NotificationListItem> {
  Future<PeamanUser>? _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = PUserProvider.getUserById(
      uid: widget.notification.senderId!,
    ).first;
  }

  @override
  Widget build(BuildContext context) {
    return UserFetcher.singleFuture(
      userFuture: _userFuture,
      singleBuilder: (user) {
        final _user = user;

        return VMProvider<NotificationItemVm>(
          vm: NotificationItemVm(context),
          builder: (context, vm, appVm, appUser) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    NotificationNavigationHelper(context).navigate(
                      data: widget.notification.extraData,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                      bottom: 25.0,
                    ),
                    child: Row(
                      children: [
                        AvatarBuilder.image(
                          _user.photoUrl,
                          size: 60.0,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.notification.title,
                                      style: TextStyle(
                                        color: blackColor,
                                      ),
                                    ),
                                    if (widget.notification.body
                                        .trim()
                                        .isNotEmpty)
                                      Text(
                                        CommonHelper.limitedText(
                                          widget.notification.body,
                                          limit: 70,
                                        ),
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      timeago.format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          widget.notification.createdAt!,
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontSize: 10.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                  ],
                                ),
                              ),
                              _subContentBuilder(appUser!, vm),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _subContentBuilder(
    final PeamanUser appUser,
    final NotificationItemVm vm,
  ) {
    Widget _widget = Container();
    final _type =
        NotificationType.values[widget.notification.extraData['type'] ?? 0];

    switch (_type) {
      case NotificationType.startedFollowing:
        return _followBtnBuilder(appUser, vm);
      default:
    }

    return _widget;
  }

  Widget _followBtnBuilder(
    final PeamanUser appUser,
    final NotificationItemVm vm,
  ) {
    final _following = vm.following ?? [];
    final _alreadyFollowing = _following
        .map((e) => e.uid)
        .toList()
        .contains(widget.notification.senderId!);

    if (_alreadyFollowing) return Container();

    return HotepButton.bordered(
      padding: const EdgeInsets.all(0.0),
      value: 'Follow',
      textStyle: TextStyle(
        fontSize: 12.0,
        color: blueColor,
      ),
      borderRadius: 10.0,
      width: 60.0,
      height: 30.0,
      onPressed: () => vm.followBack(
        appUser.uid!,
        widget.notification.senderId!,
      ),
    );
  }
}
