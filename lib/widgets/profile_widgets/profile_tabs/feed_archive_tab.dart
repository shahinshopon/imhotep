import 'package:flutter/material.dart';
import 'package:imhotep/widgets/feed_widgets/feeds_list_item.dart';
import 'package:peaman/peaman.dart';
import '../profile_empty_builder.dart';

class FeedArchiveTab extends StatelessWidget {
  final List<PeamanSavedFeed>? savedFeeds;
  const FeedArchiveTab({
    Key? key,
    required this.savedFeeds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (savedFeeds == null) {
      return Center(child: CircularProgressIndicator());
    }
    if (savedFeeds!.isEmpty) {
      return ProfileEmptyBuilder(
        imgUrl: 'assets/Groupfvrt.png',
        description:
            'This is your archive.\nOnce you start to save,\nyou can track your record here',
      );
    }

    return _feedsListBuilder();
  }

  Widget _feedsListBuilder() {
    return GridView.builder(
      itemCount: savedFeeds?.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
      ),
      itemBuilder: (context, index) {
        final _savedFeed = savedFeeds![index];
        return StreamBuilder<PeamanFeed>(
          stream: PFeedProvider.getSingleFeedById(
            feedId: _savedFeed.id!,
          ),
          builder: (context, snap) {
            if (snap.hasData) {
              final _feed = snap.data!;

              if (_feed.id != null) {
                return FeedListItem.grid(feed: _feed);
              }
            }
            return Container();
          },
        );
      },
    );
  }
}
