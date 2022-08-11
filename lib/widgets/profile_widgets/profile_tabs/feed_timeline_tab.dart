import 'package:flutter/material.dart';
import 'package:imhotep/enums/feed_subscription_type.dart';
import 'package:imhotep/models/feed_extra_data_model.dart';
import 'package:imhotep/widgets/feed_widgets/feeds_list.dart';
import 'package:peaman/peaman.dart';
import '../../../constants.dart';

class FeedTimelineTab extends StatefulWidget {
  final List<PeamanFeed>? allFeeds;
  const FeedTimelineTab({
    Key? key,
    required this.allFeeds,
  }) : super(key: key);

  @override
  State<FeedTimelineTab> createState() => _FeedTimelineTabState();
}

class _FeedTimelineTabState extends State<FeedTimelineTab> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.allFeeds == null)
      return Center(
        child: CircularProgressIndicator(),
      );

    final _filteredFeeds = widget.allFeeds!
        .where(
          (e) => _currentTab == 0
              ? true
              : _currentTab == 1
                  ? e.type == PeamanFeedType.image && e.photos.length == 1
                  : _currentTab == 2
                      ? e.type == PeamanFeedType.image && e.photos.length > 1
                      : _currentTab == 3
                          ? e.type == PeamanFeedType.video
                          : _currentTab == 4
                              ? e.type == PeamanFeedType.other
                              : FeedExtraData.fromJson(e.extraData)
                                      .subscriptionType ==
                                  FeedSubscriptionType.paid,
        )
        .toList();

    return DefaultTabController(
      length: 6,
      child: Column(
        children: [
          _tabBarBuilder(),
          FeedsList.grid(
            feeds: _filteredFeeds,
          ),
        ],
      ),
    );
  }

  Widget _tabBarBuilder() {
    return TabBar(
      labelColor: blackColor,
      unselectedLabelColor: greyColorshade400,
      indicatorColor: blackColor,
      labelPadding: const EdgeInsets.all(2.0),
      indicatorPadding: const EdgeInsets.all(2.0),
      onTap: (val) {
        setState(() {
          _currentTab = val;
        });
      },
      tabs: [
        Tab(
          child: Icon(
            Icons.border_all_rounded,
            size: 20.0,
          ),
        ),
        Tab(
          child: Icon(
            Icons.insert_photo_rounded,
            size: 20.0,
          ),
        ),
        Tab(
          child: Icon(
            Icons.style_rounded,
            size: 20.0,
          ),
        ),
        Tab(
          child: Icon(
            Icons.play_arrow_rounded,
          ),
        ),
        Tab(
          child: Icon(
            Icons.description_rounded,
            size: 20.0,
          ),
        ),
        Tab(
          child: Icon(
            Icons.verified_rounded,
            size: 20.0,
          ),
        ),
      ],
    );
  }
}
