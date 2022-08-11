import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imhotep/enums/feed_subscription_type.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/enums/subscription_type.dart';
import 'package:imhotep/helpers/common_helper.dart';
import 'package:imhotep/helpers/date_time_helper.dart';
import 'package:imhotep/helpers/dialog_provider.dart';
import 'package:imhotep/models/app_user_extra_data_model.dart';
import 'package:imhotep/models/article_model.dart';
import 'package:imhotep/screens/create_post_screen.dart';
import 'package:imhotep/viewmodels/feed_item_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/common_widgets/edit_delete_selector.dart';
import 'package:imhotep/widgets/common_widgets/hotep_read_more_text.dart';
import 'package:imhotep/widgets/common_widgets/spinner.dart';
import 'package:imhotep/widgets/feed_widgets/premium_feed_cover.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import 'package:timeago/timeago.dart' as time_ago;
import '../../models/feed_extra_data_model.dart';
import '../../screens/view_single_article_screen.dart';
import '../../screens/view_single_feed_screen.dart';
import '../../screens/view_video_screen.dart';
import '../../services/ads/google_ads_provider.dart';
import 'feed_action_buttons.dart';
import 'feed_carousel_slider.dart';

enum _ListItemType {
  normal,
  grid,
}

class FeedListItem extends StatefulWidget {
  final PeamanFeed feed;
  final _ListItemType type;
  final bool requiredEditDelete;
  final bool inView;
  final bool withText;

  const FeedListItem.normal({
    Key? key,
    required this.feed,
    this.requiredEditDelete = false,
    this.inView = false,
  })  : type = _ListItemType.normal,
        withText = false,
        super(key: key);

  const FeedListItem.grid({
    Key? key,
    required this.feed,
    this.requiredEditDelete = false,
    this.withText = false,
  })  : type = _ListItemType.grid,
        inView = false,
        super(key: key);

  @override
  State<FeedListItem> createState() => _FeedListItemState();
}

class _FeedListItemState extends State<FeedListItem> {
  final _videoControllers = <VideoPlayerController>[];

  @override
  Widget build(BuildContext context) {
    final _appUser = context.watch<PeamanUser>();

    return VMProvider<FeedItemVm>(
      vm: FeedItemVm(context),
      onInit: (vm) => vm.onInit(
        thisFeed: widget.feed,
        appUser: _appUser,
        requiredAds: widget.type == _ListItemType.normal,
      ),
      builder: (context, vm, appVm, appUser) {
        if (vm.stateType == StateType.busy) {
          if (widget.type != _ListItemType.grid)
            return Container(
              height: MediaQuery.of(context).size.width,
              child: Spinner(),
            );
          else
            return Container();
        }

        final _feedExtraData = FeedExtraData.fromJson(vm.feed.extraData);
        final _appUserExtraData = AppUserExtraData.fromJson(appUser!.extraData);

        final _notSubscribed =
            _feedExtraData.subscriptionType == FeedSubscriptionType.paid &&
                _appUserExtraData.subscriptionType == SubscriptionType.none;

        return Padding(
          padding: EdgeInsets.only(
            bottom: _notSubscribed && widget.type != _ListItemType.grid
                ? 20.0
                : 0.0,
          ),
          child: GestureDetector(
            onLongPress: () {
              if (widget.requiredEditDelete &&
                  appUser.admin &&
                  vm.feed.type != PeamanFeedType.other)
                DialogProvider(context).showBottomSheet(
                  widget: EditDeleteSelector(
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreatePostScreen(
                            feedToUpdate: vm.feed,
                          ),
                        ),
                      );
                    },
                    onDelete: () async {
                      DialogProvider(context).showAlertDialog(
                        title: 'Are you sure you want to delete?',
                        description:
                            'This action is permanent and cannot be undone!',
                        onPressedPositiveBtn: () async {
                          await PFeedProvider.deleteFeed(
                            feedId: vm.feed.id!,
                          );
                          Fluttertoast.showToast(
                            msg: 'Post deleted. Please refresh the screen',
                          );
                        },
                      );
                    },
                  ),
                );
            },
            child: Stack(
              children: [
                widget.type == _ListItemType.normal
                    ? _normalItemBuilder(context, vm, appUser)
                    : _gridItemBuilder(context, vm),
                if (_notSubscribed)
                  Positioned.fill(
                    child: widget.type == _ListItemType.grid
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ViewSingleFeedScreen(
                                    feed: vm.feed,
                                  ),
                                ),
                              );
                            },
                            child: PremiumFeedCover.small(),
                          )
                        : PremiumFeedCover.large(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ignore: unused_element
  Widget _actionButtonsBuilder(
    final BuildContext context,
    final FeedItemVm vm,
  ) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.black.withOpacity(0.6),
          ),
          child: Container(
            width: 40.0,
            height: 40.0,
            child: IconButton(
              icon: Icon(Icons.delete_rounded),
              iconSize: 20.0,
              color: whiteColor,
              onPressed: () async {
                await PFeedProvider.deleteFeed(
                  feedId: vm.feed.id!,
                );
                Fluttertoast.showToast(
                  msg: 'Post deleted. Please refresh the screen',
                );
              },
            ),
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.black.withOpacity(0.6),
          ),
          child: Container(
            width: 40.0,
            height: 40.0,
            child: IconButton(
              icon: Icon(Icons.edit_rounded),
              iconSize: 20.0,
              color: whiteColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreatePostScreen(
                      feedToUpdate: vm.feed,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _normalItemBuilder(
    final BuildContext context,
    final FeedItemVm vm,
    final PeamanUser appUser,
  ) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _mainContentBuilder(context, appUser, vm),
          SizedBox(
            height: 10.0,
          ),
          FeedActionButtons(
            feed: vm.feed,
            onFeedUpdate: (val) {
              vm.updateFeed(val);
              GoogleAdsProvider.loadInterstitialAd(
                context: context,
              );
            },
            disabledViews: vm.feed.type == PeamanFeedType.image,
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  Widget _gridItemBuilder(
    final BuildContext context,
    final FeedItemVm vm,
  ) {
    final _article = vm.feed.type == PeamanFeedType.other
        ? FeedExtraData.fromJson(vm.feed.extraData).article
        : null;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ViewSingleFeedScreen(
              feed: vm.feed,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: greyColorshade200,
                image: vm.feed.type == PeamanFeedType.video &&
                        vm.feed.photos.isEmpty
                    ? null
                    : DecorationImage(
                        image: CachedNetworkImageProvider(
                          vm.feed.type == PeamanFeedType.other
                              ? '${_article?.photos.first}'
                              : '${vm.feed.photos.first}',
                        ),
                        fit: BoxFit.cover,
                      ),
              ),
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Icon(
                  vm.feed.type == PeamanFeedType.video
                      ? Icons.play_arrow_rounded
                      : vm.feed.type == PeamanFeedType.image &&
                              vm.feed.photos.length > 1
                          ? Icons.style
                          : vm.feed.type == PeamanFeedType.image &&
                                  vm.feed.photos.length == 1
                              ? Icons.insert_photo_rounded
                              : Icons.description_rounded,
                  color: Colors.white,
                  size: vm.feed.type == PeamanFeedType.video ? 24.0 : 20.0,
                ),
              ),
            ),
          ),
          if (widget.withText)
            _withTextBuilder(
              _article == null ? '${widget.feed.caption}' : _article.title,
            ),
        ],
      ),
    );
  }

  Widget _mainContentBuilder(
    final BuildContext context,
    final PeamanUser appUser,
    final FeedItemVm vm,
  ) {
    final _feedExtraData = FeedExtraData.fromJson(vm.feed.extraData);
    final _appUserExtraData = AppUserExtraData.fromJson(appUser.extraData);

    final _notSubscribed =
        _feedExtraData.subscriptionType == FeedSubscriptionType.paid &&
            _appUserExtraData.subscriptionType == SubscriptionType.none;

    switch (vm.feed.type) {
      case PeamanFeedType.image:
        return Column(
          children: [
            FeedCarouselSlider.image(
              images: vm.feed.photos,
              inView: widget.inView,
              customAd: vm.randomAd,
              customAdPosition: _feedExtraData.adPosition,
            ),
            _captionBuilder(vm),
            _dateBuilder(vm),
          ],
        );
      case PeamanFeedType.video:
        return Column(
          children: [
            FeedCarouselSlider.video(
              videos: vm.feed.videos,
              inView: _notSubscribed ? false : widget.inView,
              fit: BoxFit.values[vm.feed.extraData['fit'] ?? 2],
              onVideoInitialized: (controller) {
                setState(() {
                  _videoControllers.add(controller);
                });
              },
              onPressed: (vids, index) async {
                vm.viewFeed(
                  appUser,
                  vm.feed,
                );
                final _data = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ViewVideoScreen(
                      feed: vm.feed,
                      caption: vm.feed.caption!,
                      createdAt: vm.feed.createdAt!,
                      initialIndex: index,
                      videoControllers: _videoControllers,
                      liked: vm.feed.extraData['liked'] ?? false,
                      likeReactionId: vm.feed.extraData['like_reaction_id'],
                    ),
                  ),
                );

                if (_data != null) {
                  final _liked = _data['liked'] ?? false;
                  final _likeId = _data['like_reaction_id'];

                  final _feed = vm.feed;

                  if ((_feed.extraData['liked'] ?? false) != _liked) {
                    if (_likeId != null) {
                      final _newFeed = _feed.copyWith(
                        reactionsCount: _liked
                            ? _feed.reactionsCount + 1
                            : _feed.reactionsCount - 1,
                        extraData: {
                          ..._feed.extraData,
                          'liked': _liked,
                          'like_reaction_id': _likeId,
                        },
                      );
                      vm.updateFeed(_newFeed);
                    }
                  }
                }
              },
            ),
            _captionBuilder(vm),
            _dateBuilder(vm),
          ],
        );
      case PeamanFeedType.other:
        final _article = FeedExtraData.fromJson(vm.feed.extraData).article;
        if (_article == null) return Container();

        return GestureDetector(
          onTap: () async {
            final _val = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ViewSingleArticleScreen(
                  feed: vm.feed,
                ),
              ),
            );
            if (_val is PeamanFeed) {
              vm.updateFeed(_val);
            }
          },
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              FeedCarouselSlider.image(
                images: _article.photos,
                inView: widget.inView,
                onPressed: (_1, _2) async {
                  final _val = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewSingleArticleScreen(
                        feed: vm.feed,
                      ),
                    ),
                  );
                  if (_val is PeamanFeed) {
                    vm.updateFeed(_val);
                  }
                },
              ),
              _articleTextBuilder(_article),
            ],
          ),
        );
      default:
        return Container();
    }
  }

  Widget _captionBuilder(
    final FeedItemVm vm,
  ) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.topLeft,
      // child: ReadMoreText(
      //   '${feed.caption}',
      //   trimLines: 2,
      //   colorClickableText: greyColor,
      //   trimMode: TrimMode.Line,
      //   trimCollapsedText: 'Show more',
      //   trimExpandedText: ' Show less',
      //   style: TextStyle(
      //     color: Colors.black,
      //     fontWeight: FontWeight.w500,
      //     fontSize: 12,
      //   ),
      // ),
      child: HotepReadMoreText(
        '${vm.feed.caption}',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _articleTextBuilder(final Article article) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Read article',
                style: TextStyle(
                  color: blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
              Text(
                DateTimeHelper.getFormattedDate(
                  DateTime.fromMillisecondsSinceEpoch(
                    article.createdAt,
                  ),
                ),
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            CommonHelper.limitedText(
              article.title,
              limit: 100,
            ),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _withTextBuilder(final String text) {
    return Container(
      height: 40.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CommonHelper.limitedText(
              text,
              limit: 40,
            ),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateBuilder(
    final FeedItemVm vm,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          time_ago.format(
            DateTime.fromMillisecondsSinceEpoch(
              vm.feed.createdAt!,
            ),
          ),
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        SizedBox(
          width: 10.0,
        ),
      ],
    );
  }
}
