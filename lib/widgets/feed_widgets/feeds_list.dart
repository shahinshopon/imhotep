import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:peaman/peaman.dart';
import 'feeds_list_item.dart';

enum _ListType {
  normal,
  grid,
}

class FeedsList extends StatelessWidget {
  final List<PeamanFeed> feeds;
  final bool scroll;
  final _ListType type;
  final int crossAxisCount;
  final bool requiredEditDelete;
  final bool withText;

  const FeedsList.normal({
    Key? key,
    required this.feeds,
    this.scroll = false,
    this.requiredEditDelete = false,
  })  : type = _ListType.normal,
        crossAxisCount = 3,
        withText = false,
        super(key: key);

  const FeedsList.grid({
    Key? key,
    required this.feeds,
    this.scroll = false,
    this.crossAxisCount = 3,
    this.requiredEditDelete = false,
    this.withText = false,
  })  : type = _ListType.grid,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == _ListType.normal ? _normalListBuilder() : _gridListBuilder();
  }

  Widget _normalListBuilder() {
    return ListView.builder(
      itemCount: feeds.length,
      shrinkWrap: !scroll,
      physics: scroll
          ? AlwaysScrollableScrollPhysics()
          : NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final _feed = feeds[index];
        return InViewNotifierWidget(
          id: '$index',
          builder: (context, inView, child) {
            return FeedListItem.normal(
              key: ValueKey(_feed.id),
              feed: _feed,
              requiredEditDelete: requiredEditDelete,
              inView: inView,
            );
          },
        );
      },
    );
  }

  Widget _gridListBuilder() {
    return GridView.builder(
      itemCount: feeds.length,
      shrinkWrap: !scroll,
      physics: scroll
          ? AlwaysScrollableScrollPhysics()
          : NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
      ),
      itemBuilder: (context, index) {
        final _feed = feeds[index];
        return FeedListItem.grid(
          key: ValueKey(_feed.id),
          feed: _feed,
          requiredEditDelete: requiredEditDelete,
          withText: withText,
        );
      },
    );
  }
}
