import 'package:flutter/material.dart';
import 'package:imhotep/models/ad_config.dart';
import 'package:imhotep/models/admin_model.dart';
import 'package:imhotep/models/archived_comment_model.dart';
import 'package:imhotep/models/contest_badge_model.dart';
import 'package:imhotep/models/contest_model.dart';
import 'package:imhotep/models/custom_ad_model.dart';
import 'package:imhotep/models/custom_notification_model.dart';
import 'package:imhotep/models/inapp_alert_model.dart';
import 'package:imhotep/models/maat_warrior_config_model.dart';
import 'package:imhotep/models/product_model.dart';
import 'package:imhotep/models/shopify_product.dart';
import 'package:imhotep/models/stripe_subscription_model.dart';
import 'package:imhotep/models/user_subscription_model.dart';
import 'package:imhotep/services/ads/google_ads_provider.dart';
import 'package:imhotep/services/api/shop_provider.dart';
import 'package:imhotep/services/firebase/database/contest_provider.dart';
import 'package:imhotep/services/firebase/database/custom_ads_provider.dart';
import 'package:imhotep/services/firebase/database/custom_notification_provider.dart';
import 'package:imhotep/services/firebase/database/editor_access_provider.dart';
import 'package:imhotep/services/firebase/database/inapp_alert_provider.dart';
import 'package:imhotep/services/firebase/database/maat_warrior_provider.dart';
import 'package:imhotep/services/firebase/database/user_provider.dart';
import 'package:imhotep/services/firebase/functions/payment_provider.dart';
import 'package:imhotep/viewmodels/temp_imgs_vm.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

import 'models/ad_config.dart';
import 'models/editor_access_config_mode.dart';

class WrapperBuilder extends StatelessWidget {
  final Widget Function(BuildContext) builder;
  const WrapperBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _appUser = context.watch<PeamanUser?>();

    if (_appUser != null && _appUser.uid != null) {
      return MultiProvider(
        providers: [
          StreamProvider<Admin?>(
            create: (_) => UserProvider.admin,
            lazy: false,
            initialData: null,
          ),
          StreamProvider<MaatWarriorConfig>(
            create: (_) => MaatWarriorProvider.getMaatWarriorConfig,
            lazy: false,
            initialData: MaatWarriorConfig(),
          ),
          StreamProvider<EditorAccessConfig>(
            create: (_) => EditorAccessProvider.editorAccessConfig,
            lazy: false,
            initialData: EditorAccessConfig(),
          ),
          StreamProvider<AdConfig>(
            create: (_) => GoogleAdsProvider.adConfig,
            lazy: false,
            initialData: AdConfig(),
          ),
          StreamProvider<List<Contest>?>(
            create: (_) => ContestProvider.contests,
            lazy: false,
            initialData: null,
          ),
          StreamProvider<InAppAlert?>(
            create: (_) => InAppAlertProvider.inAppAlert,
            lazy: false,
            initialData: null,
          ),
          StreamProvider<List<StripeSubscription>>(
            create: (_) => PaymentProvider.subscriptions,
            lazy: false,
            initialData: <StripeSubscription>[],
          ),
          StreamProvider<UserSubscription?>(
            create: (_) => PaymentProvider.getUserSubscription(
              uid: _appUser.uid!,
            ),
            lazy: false,
            initialData: null,
          ),
          ChangeNotifierProvider<TempImgVM>(
            create: (_) => TempImgVM(context),
          ),
          StreamProvider<PeamanUser>(
            create: (_) => PUserProvider.getUserById(
              uid: _appUser.uid!,
            ),
            lazy: false,
            initialData: PeamanUser(uid: _appUser.uid),
          ),
          StreamProvider<List<PeamanChat>?>(
            create: (_) => PChatProvider.getUserChats(
              uid: _appUser.uid!,
            ),
            lazy: false,
            initialData: null,
          ),
          StreamProvider<List<PeamanFollower>?>(
            create: (_) => PUserProvider.getUserFollowers(
              uid: _appUser.uid!,
            ),
            lazy: false,
            initialData: null,
          ),
          StreamProvider<List<PeamanFollowing>?>(
            create: (_) => PUserProvider.getUserFollowings(
              uid: _appUser.uid!,
            ),
            lazy: false,
            initialData: null,
          ),
          StreamProvider<List<PeamanBlockedUser>?>(
            create: (_) => PUserProvider.getUserBlockedUsers(
              uid: _appUser.uid!,
            ),
            lazy: false,
            initialData: null,
          ),
          StreamProvider<List<PeamanSavedFeed>?>(
            create: (_) => PFeedProvider.getUserSavedFeeds(
              uid: _appUser.uid!,
            ),
            lazy: false,
            initialData: null,
          ),
          StreamProvider<List<ArchivedComment>?>(
            create: (_) => ArchivedComment.getArchivedComments(
              uid: _appUser.uid!,
            ),
            lazy: false,
            initialData: null,
          ),
          StreamProvider<List<PeamanNotification>?>(
            create: (_) => PNotificationProvider.getUserNotifications(
              uid: _appUser.uid!,
            ),
            lazy: false,
            initialData: null,
          ),
          StreamProvider<List<PeamanFeed>?>(
            create: (_) => PFeedProvider.getFeeds(),
            lazy: false,
            initialData: null,
          ),
          StreamProvider<List<PeamanMoment>?>(
            create: (_) => PFeedProvider.getMoments(),
            lazy: false,
            initialData: null,
          ),
          StreamProvider<ContestBadge?>(
            create: (_) => ContestProvider.contestBadge(
              ownerId: _appUser.uid!,
            ),
            initialData: null,
          ),
          StreamProvider<List<CustomAd>>(
            create: (_) => CustomAdsProvider.customAds,
            lazy: false,
            initialData: <CustomAd>[],
          ),
          StreamProvider<List<CustomNotification>>(
            create: (_) => CustomNotificationProvider.customNotifications,
            initialData: <CustomNotification>[],
          ),
          FutureProvider<List<Product>>(
            create: (_) => ShopProvider.getProductsFromWebsite(),
            lazy: false,
            initialData: [],
          ),
          FutureProvider<List<ShopifyProduct>>(
            create: (_) => ShopProvider.getProductsFromShopify(),
            lazy: false,
            initialData: [],
          ),
        ],
        builder: (context, child) => builder(context),
      );
    }
    return builder(context);
  }
}
