import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:imhotep/helpers/common_helper.dart';
import 'package:imhotep/widgets/common_widgets/verified_user_badge.dart';
import 'package:peaman/peaman.dart';

import '../../constants.dart';
import '../../enums/subscription_type.dart';

enum _Type {
  expanded,
  rounded,
}

class UserListItem extends StatelessWidget {
  final PeamanUser user;
  final int bioLimit;
  final Function(PeamanUser)? onPressed;
  final _Type type;
  final Widget? photoOverlapWidget;

  const UserListItem.expanded({
    Key? key,
    required this.user,
    this.onPressed,
    this.bioLimit = 100,
    this.photoOverlapWidget,
  })  : type = _Type.expanded,
        super(key: key);

  const UserListItem.rounded({
    Key? key,
    required this.user,
    this.onPressed,
    this.photoOverlapWidget,
  })  : type = _Type.rounded,
        bioLimit = 100,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == _Type.expanded
        ? _expandedBuilder(context)
        : _roundedBuilder(context);
  }

  Widget _expandedBuilder(final BuildContext context) {
    return InkWell(
      onTap: () => onPressed?.call(user),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundColor: greyColorshade300,
              backgroundImage: CachedNetworkImageProvider(
                '${user.photoUrl}',
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${user.name}',
                        style: TextStyle(
                          color: blueColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      if (CommonHelper.subscriptionType(context, user: user) ==
                          SubscriptionType.level3)
                        VerifiedUserBadge(),
                    ],
                  ),
                  Text(
                    CommonHelper.limitedText(
                      user.bio,
                      limit: bioLimit,
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: blackColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundedBuilder(final BuildContext context) {
    return InkWell(
      onTap: () => onPressed?.call(user),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30.0,
                      backgroundColor: greyColorshade200,
                      backgroundImage: CachedNetworkImageProvider(
                        '${user.photoUrl}',
                      ),
                    ),
                    Positioned.fill(
                      child: photoOverlapWidget ?? Container(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  '${CommonHelper.limitedText(
                    user.admin ? user.name : user.name!.split(' ').first,
                    limit: 15,
                  )}',
                  style: TextStyle(
                    color: greyColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
