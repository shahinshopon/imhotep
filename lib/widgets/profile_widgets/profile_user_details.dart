import 'package:flutter/material.dart';
import 'package:imhotep/enums/subscription_type.dart';
import 'package:imhotep/helpers/common_helper.dart';
import 'package:imhotep/widgets/common_widgets/avatar_builder.dart';
import 'package:peaman/peaman.dart';
import '../../constants.dart';
import '../../screens/settings_screen.dart';
import '../common_widgets/admin_badge.dart';
import '../common_widgets/verified_user_badge.dart';

class ProfileUserDetails extends StatelessWidget {
  final PeamanUser appUser;
  final Widget? suffix;
  ProfileUserDetails({
    Key? key,
    required this.appUser,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 10.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarBuilder.image(
            '${appUser.photoUrl}',
            size: 80.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appUser.admin
                    ? AdminBadge()
                    : Container(
                        height: 10.0,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${appUser.name}'.length > 28
                              ? '${appUser.name?.substring(0, 28)}...'
                              : '${appUser.name}',
                          style: TextStyle(
                            color: blueColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        if (CommonHelper.subscriptionType(context,
                                user: appUser) ==
                            SubscriptionType.level3)
                          VerifiedUserBadge(),
                      ],
                    ),
                    suffix ??
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SettingsScreen(),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.settings_outlined,
                          ),
                        )
                  ],
                ),
                if (appUser.country?.trim().isNotEmpty ?? false)
                  Text(
                    '${appUser.country}',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: blackColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  '${appUser.bio}',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: blackColor,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
