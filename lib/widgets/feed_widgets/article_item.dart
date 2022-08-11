import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/models/feed_extra_data_model.dart';
import 'package:peaman/peaman.dart';

class ArticleItem extends StatelessWidget {
  final PeamanFeed feed;
  const ArticleItem({
    Key? key,
    required this.feed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _feedExtraData = FeedExtraData.fromJson(feed.extraData);
    final _article = _feedExtraData.article;

    if (_article == null) return Container();

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: greyColorshade200,
        image: DecorationImage(
          image: CachedNetworkImageProvider(_article.photos.first),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
