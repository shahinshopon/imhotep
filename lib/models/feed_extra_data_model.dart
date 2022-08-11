import 'package:imhotep/enums/feed_subscription_type.dart';
import 'package:imhotep/models/article_model.dart';

class FeedExtraData {
  final Article? article;
  final String? dynamicLink;
  final FeedSubscriptionType subscriptionType;
  final int adPosition;

  FeedExtraData({
    this.article,
    this.dynamicLink,
    this.subscriptionType = FeedSubscriptionType.free,
    this.adPosition = -1,
  });

  static FeedExtraData fromJson(final Map<String, dynamic> data) {
    return FeedExtraData(
      article: Article.fromJson(data),
      dynamicLink: data['dynamic_link'],
      subscriptionType:
          FeedSubscriptionType.values[data['subscription_type'] ?? 0],
      adPosition: data['ad_position'] ?? -1,
    );
  }
}
