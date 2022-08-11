import 'package:flutter/material.dart';
import 'package:imhotep/widgets/feed_widgets/feeds_list_item.dart';
import 'package:peaman/peaman.dart';

import '../constants.dart';

class ViewSingleFeedScreen extends StatelessWidget {
  final String? feedId;
  final PeamanFeed? feed;
  const ViewSingleFeedScreen({
    Key? key,
    this.feedId,
    this.feed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          'Post',
          style: TextStyle(
            color: blackColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: feed != null
            ? FeedListItem.normal(
                feed: feed!,
                inView: true,
              )
            : feedId != null
                ? StreamBuilder<PeamanFeed>(
                    stream: PFeedProvider.getSingleFeedById(
                      feedId: feedId!,
                    ),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snap.hasData) {
                        final _feed = snap.data!;
                        return FeedListItem.normal(
                          feed: _feed,
                          inView: true,
                        );
                      }
                      return Container();
                    },
                  )
                : Container(),
      ),
    );
  }
}
