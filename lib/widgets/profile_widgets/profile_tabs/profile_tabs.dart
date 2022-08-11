import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imhotep/models/archived_comment_model.dart';
import 'package:imhotep/models/archived_feed_model.dart';
import 'package:imhotep/widgets/profile_widgets/profile_tabs/comment_archive_tab.dart';
import 'package:imhotep/widgets/profile_widgets/profile_tabs/feed_archive_tab.dart';
import 'package:imhotep/widgets/profile_widgets/profile_tabs/feed_timeline_tab.dart';
import 'package:peaman/peaman.dart';
import '../../../constants.dart';
import 'liked_feed_tab.dart';

enum _Type {
  personal,
  friend,
}

class ProfileTabs extends StatefulWidget {
  final List<ArchivedComment>? comments;
  final List<PeamanSavedFeed>? savedFeeds;
  final List<PeamanFeed>? allFeeds;
  final String friendId;
  final _Type type;

  const ProfileTabs.personal({
    Key? key,
    required this.comments,
    required this.savedFeeds,
    required this.allFeeds,
  })  : type = _Type.personal,
        friendId = '',
        super(key: key);

  const ProfileTabs.friend({
    Key? key,
    required this.friendId,
  })  : type = _Type.friend,
        comments = null,
        savedFeeds = null,
        allFeeds = null,
        super(key: key);

  @override
  State<ProfileTabs> createState() => _ProfileTabsState();
}

class _ProfileTabsState extends State<ProfileTabs> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.type == _Type.friend ? 2 : 3,
      child: Column(
        children: [
          widget.type == _Type.friend
              ? _friendTabBarBuilder(context)
              : _personalTabBarBuilder(context),
          Container(
            width: MediaQuery.of(context).size.width,
            constraints: BoxConstraints(
              minHeight: 400.0,
            ),
            child: widget.type == _Type.friend
                ? _friendTabViewBuilder()
                : _personalTabViewBuilder(),
          ),
        ],
      ),
    );
  }

  Widget _personalTabBarBuilder(BuildContext context) {
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
          child: Image.asset(
            'assets/Groupcomment.png',
            height: 27.0,
            color: _currentTab == 0 ? blackColor : null,
          ),
        ),
        Tab(
          child: Image.asset(
            'assets/Groupstar.png',
            height: 27.0,
            color: _currentTab == 1 ? blackColor : null,
          ),
        ),
        Tab(
          child: SvgPicture.asset(
            'assets/svgs/explore_tab.svg',
            height: 25.0,
            color: _currentTab == 2 ? blackColor : greyColor,
          ),
        ),
      ],
    );
  }

  Widget _friendTabBarBuilder(BuildContext context) {
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
          child: Image.asset(
            'assets/Groupcomment.png',
            height: 27.0,
          ),
        ),
        Tab(
          icon: Icon(
            Icons.thumb_up_alt_outlined,
            size: 30.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _personalTabViewBuilder() {
    switch (_currentTab) {
      case 0:
        return CommentArchiveTab(comments: widget.comments);
      case 1:
        return FeedArchiveTab(savedFeeds: widget.savedFeeds);
      case 2:
        return FeedTimelineTab(allFeeds: widget.allFeeds);
      default:
        return CommentArchiveTab(comments: widget.comments);
    }
  }

  Widget _friendTabViewBuilder() {
    switch (_currentTab) {
      case 0:
        return StreamBuilder<List<ArchivedComment>>(
          stream: ArchivedComment.getArchivedComments(
            uid: widget.friendId,
          ),
          builder: (context, snap) {
            if (snap.hasData) {
              final _comments = snap.data ?? [];
              return CommentArchiveTab(comments: _comments);
            }
            return CommentArchiveTab(comments: null);
          },
        );
      case 1:
        return StreamBuilder<List<LikedFeed>>(
          stream: LikedFeed.getLikedFeeds(
            uid: widget.friendId,
          ),
          builder: (context, snap) {
            if (snap.hasData) {
              final _likedFeeds = snap.data ?? [];
              return LikedFeedTab(likedFeeds: _likedFeeds);
            }
            return LikedFeedTab(likedFeeds: null);
          },
        );

      default:
        return CommentArchiveTab(comments: []);
    }
  }
}
