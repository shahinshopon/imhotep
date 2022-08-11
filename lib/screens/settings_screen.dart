import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/helpers/common_helper.dart';
import 'package:imhotep/helpers/dialog_provider.dart';
import 'package:imhotep/screens/create_ads_screen.dart';
import 'package:imhotep/screens/create_custom_notification_screen.dart';
import 'package:imhotep/screens/create_in_app_alert_screen.dart';
import 'package:imhotep/screens/edit_profile_screen.dart';
import 'package:imhotep/screens/auth_screen.dart';
import 'package:imhotep/screens/manage_subscription_screen.dart';
import 'package:imhotep/screens/policy_screen.dart';
import 'package:imhotep/screens/subscription_screen.dart';
import 'package:imhotep/services/firebase/functions/article_provider.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

import '../models/user_subscription_model.dart';
import 'blocked_users_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  void logout() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return AuthScreen();
      }),
    );
  }

  void next() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return EditProfile();
    }));
  }

  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    final _appUser = context.watch<PeamanUser>();
    final _userSubscription = context.watch<UserSubscription?>();
    final _hasAdminOrEditorAccess = CommonHelper.canUpdateArticles(context) ||
        CommonHelper.canCreateCustomAd(context) ||
        CommonHelper.canCreateCustomNotification(context) ||
        CommonHelper.canCreateInAppAlert(context);
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
          'Settings',
          style: TextStyle(
            color: blackColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              onTap: next,
              title: SettingTile(text: 'Edit Profile'),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => _userSubscription == null
                        ? SubscriptionScreen()
                        : ManageSubscription(),
                  ),
                );
              },
              title: SettingTile(
                text: _userSubscription == null
                    ? 'Subscriptions'
                    : 'Manage Your Subscriptions',
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) {
                      return BlockedUsersScreen();
                    },
                  ),
                );
              },
              title: SettingTile(text: 'Blocked Users'),
            ),
            Divider(),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PolicyScreen(
                      title: 'Privacy Policy',
                      htmlFilePath: 'assets/file/privacy_policy.html',
                    ),
                  ),
                );
              },
              title: SettingTile(text: 'Privacy Policy'),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PolicyScreen(
                      title: 'Copyright Policy',
                      htmlFilePath: 'assets/file/copyright_policy.html',
                    ),
                  ),
                );
              },
              title: SettingTile(text: 'Copyright Policy'),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PolicyScreen(
                      title: 'Terms Of Service',
                      htmlFilePath: 'assets/file/terms_and_condition.html',
                    ),
                  ),
                );
              },
              title: SettingTile(text: 'Terms Of Service'),
            ),
            Divider(),
            ListTile(
              onTap: () {
                DialogProvider(context).showAlertDialog(
                  title: 'Are you sure you want to sign out ?',
                  description: '',
                  onPressedPositiveBtn: () {
                    PNotificationProvider.resetPushNotification(
                      uid: _appUser.uid!,
                    );
                    PAuthProvider.logOut();
                  },
                );
              },
              title: SettingTile(text: 'Sign Out'),
            ),
            Divider(),
            if (_hasAdminOrEditorAccess)
              Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    '${_appUser.admin ? 'Admin' : 'Editor'} Access',
                    style: TextStyle(
                      color: blueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  if (CommonHelper.canUpdateArticles(context))
                    ListTile(
                      onTap: () async {
                        await ArticleProvider.updateArticles();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Successfully updated articles'),
                          ),
                        );
                      },
                      title: SettingTile(
                        text: 'Update Articles',
                      ),
                    ),
                  if (CommonHelper.canCreateCustomAd(context))
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreateAdsScreen(),
                          ),
                        );
                      },
                      title: SettingTile(
                        text: 'Create Custom Ad',
                      ),
                    ),
                  if (CommonHelper.canCreateCustomNotification(context))
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreateCustomNotificationScreen(),
                          ),
                        );
                      },
                      title: SettingTile(
                        text: 'Create Custom Notification',
                      ),
                    ),
                  if (CommonHelper.canCreateInAppAlert(context))
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreateInAppAlertScreen(),
                          ),
                        );
                      },
                      title: SettingTile(
                        text: 'Create In-App Alerts',
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
