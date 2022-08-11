import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:peaman/peaman.dart';

import '../../../models/feed_extra_data_model.dart';

class DynamicLinkProvider {
  static final _dynamicLink = FirebaseDynamicLinks.instance;

  // create link for sharing posts
  static Future<String?> createPostShareLink({
    required final String uid,
    required final PeamanFeed feed,
    final bool premium = false,
  }) async {
    try {
      final _feedExtraData = FeedExtraData.fromJson(feed.extraData);
      final _article = _feedExtraData.article;

      final _feedId =
          feed.type == PeamanFeedType.other ? _article!.id : feed.id;
      final _description = premium
          ? 'Unlock this post by becoming premium.'
          : feed.type == PeamanFeedType.other
              ? _article?.title
              : feed.caption;
      final _photo = premium
          ? 'https://firebasestorage.googleapis.com/v0/b/iamhotep-5adf2.appspot.com/o/other%2Fpremium_post_cover.jpg?alt=media&token=522e1d87-1582-4207-b9e0-37b09197579f'
          : feed.type == PeamanFeedType.other
              ? _article?.photos.first
              : feed.photos.first;

      if (_feedId == null || _description == null || _photo == null) {
        throw Future.error('Some details were null');
      }

      final DynamicLinkParameters _parameters = DynamicLinkParameters(
        uriPrefix: 'https://mrimhotep.com',
        link: Uri.parse(
          "https://mrimhotepapp.com/posts?id=$_feedId&uid=$uid",
        ),
        androidParameters: const AndroidParameters(
          packageName: 'com.mrimhotep.app',
          minimumVersion: 1,
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: 'Mr. Imhotep',
          description: _description,
          imageUrl: Uri.parse(_photo),
        ),
      );

      final _dynamicUrl = await _dynamicLink.buildShortLink(_parameters);
      final _link = _dynamicUrl.shortUrl.toString();

      print('Success: Creating post share link $_link');
      return _link;
    } catch (e) {
      print(e);
      print('Error!!!: Creating post share link');
    }

    return null;
  }

  // handle link when the app is opened from the link
  static Future<void> onReceivedDynamicLink({
    required final Function(Uri) onReceivedLink,
  }) async {
    final PendingDynamicLinkData? _data = await _dynamicLink.getInitialLink();

    _handleDynamicLink(
      data: _data,
      onReceivedLink: onReceivedLink,
    );

    _dynamicLink.onLink.listen(
      (data) => _handleDynamicLink(
        data: data,
        onReceivedLink: onReceivedLink,
      ),
    );
  }

  static void _handleDynamicLink({
    required PendingDynamicLinkData? data,
    required Function(Uri)? onReceivedLink,
  }) async {
    final _deepLink = data?.link;

    if (_deepLink != null) {
      print('Incoming dynamic link: $_deepLink');
      onReceivedLink?.call(_deepLink);
    }
  }
}
