import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/screens/comments_screen.dart';
import 'package:imhotep/widgets/common_widgets/hotep_read_more_text.dart';
import 'package:imhotep/widgets/common_widgets/video_controls.dart';
import 'package:imhotep/widgets/feed_widgets/feed_carousel_slider.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';
import '../helpers/dialog_provider.dart';
import '../models/archived_feed_model.dart';
import '../widgets/common_widgets/avatar_builder.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../widgets/feed_widgets/feed_share_bottomsheet.dart';

class ViewVideoScreen extends StatefulWidget {
  final PeamanFeed feed;
  final String caption;
  final int createdAt;
  final int initialIndex;
  final List<VideoPlayerController> videoControllers;
  final bool liked;
  final String? likeReactionId;

  const ViewVideoScreen({
    Key? key,
    required this.feed,
    required this.caption,
    required this.createdAt,
    this.initialIndex = 0,
    this.videoControllers = const [],
    this.liked = false,
    this.likeReactionId,
  }) : super(key: key);

  @override
  State<ViewVideoScreen> createState() => _ViewVideoScreenState();
}

class _ViewVideoScreenState extends State<ViewVideoScreen>
    with SingleTickerProviderStateMixin {
  Duration? _timerDuration;
  Duration? _totalDuration;
  Duration? _seekDuration;
  bool _paused = false;
  bool _seeked = false;
  bool _seekedForw = false;
  bool _liked = false;
  Future<PeamanUser>? _userFuture;
  String? _likeReactionId;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();

    _userFuture = PUserProvider.getUserById(
      uid: widget.feed.ownerId!,
    ).first;
    _likeReactionId = widget.likeReactionId;
    _liked = widget.liked;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.ease,
      ),
    );

    Future.delayed(Duration(milliseconds: 3000), () {
      _animationController.forward();
    });
  }

  void _likeVideo() {
    final _appUser = context.read<PeamanUser>();

    final _reaction = PeamanReaction(
      id: _likeReactionId,
      feedId: widget.feed.id,
      ownerId: _appUser.uid,
      parent: PeamanReactionParent.feed,
      parentId: widget.feed.id,
    );
    PFeedProvider.addReaction(
      reaction: _reaction,
      onSuccess: (reaction) {
        setState(() {
          _likeReactionId = reaction.id;
        });
        LikedFeed(
          feedId: widget.feed.id!,
          createdAt: DateTime.now().millisecondsSinceEpoch,
        )..saveLikedFeed(uid: _appUser.uid!);
      },
    );
  }

  void _unlikeVideo() {
    PFeedProvider.removeReaction(
      feedId: widget.feed.id!,
      parentId: widget.feed.id!,
      reactionId: _likeReactionId!,
    );
  }

  void _seekVideo(final TapDownDetails details) {
    final _screenSize = MediaQuery.of(context).size;

    final _fingerPosition = details.globalPosition.dx;
    final _center = _screenSize.width / 2;
    setState(() {
      _seeked = !_seeked;

      if (_fingerPosition < _center) {
        _seekedForw = false;

        if (_timerDuration != null) {
          _seekDuration = Duration(
            seconds: _timerDuration!.inSeconds > 5
                ? _timerDuration!.inSeconds - 5
                : 0,
          );
        }
      } else {
        _seekedForw = true;

        if (_timerDuration != null) {
          _seekDuration = Duration(
            seconds: _timerDuration!.inSeconds + 5,
          );
        }
      }
    });
  }

  void _playPauseVideo() {
    setState(() {
      _paused = !_paused;
      _visible = true;
    });

    if (!_paused) {
      Future.delayed(Duration(milliseconds: 5000), () {
        setState(() {
          _visible = false;
        });
        _animationController.forward(from: 0.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, {
          'liked': _liked,
          'like_reaction_id': _likeReactionId,
        });
        return true;
      },
      child: Scaffold(
        backgroundColor: blackColor,
        body: SafeArea(
          child: Container(
            height: _screenSize.height,
            child: GestureDetector(
              onDoubleTapDown: _seekVideo,
              onDoubleTap: () {},
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FeedCarouselSlider.video(
                        videos: widget.feed.videos,
                        inView: !_paused,
                        requiredIndicator: false,
                        initialIndex: widget.initialIndex,
                        volume: 1.0,
                        fit: BoxFit.contain,
                        seekDuration: _seekDuration,
                        onVideoProgress: (newTimerDuration, newTotalDuration) {
                          setState(() {
                            _timerDuration = newTimerDuration;
                            _totalDuration = newTotalDuration;
                          });
                        },
                        onPressed: (_1, _2) => _playPauseVideo(),
                        onPageChange: (val) {
                          setState(() {
                            _paused = false;
                            _timerDuration = Duration.zero;
                            _totalDuration = Duration.zero;
                          });
                        },
                        fullScreen: true,
                        videoControllers: widget.videoControllers,
                      ),
                    ],
                  ),
                  if (_timerDuration != null && _totalDuration != null)
                    Positioned.fill(
                      child: Center(
                        child: VideoControls.playPause(
                          paused: _paused,
                        ),
                      ),
                    ),
                  Positioned(
                    top: 0.0,
                    bottom: 0.0,
                    left: !_seekedForw ? 40.0 : null,
                    right: _seekedForw ? 40.0 : null,
                    child: Center(
                      child: VideoControls.seek(
                        seeked: _seeked,
                        seekedForw: _seekedForw,
                      ),
                    ),
                  ),
                  Positioned(
                    child: _overlapBuilder(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _overlapBuilder(final BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _visible ? 1.0 : _animation.value,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _backIconBuilder(context),
                    _ownerDetailsBuilder(),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.5),
                      Colors.black,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: _captionBuilder(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 15.0,
                            bottom: 40.0,
                          ),
                          child: _postActionsBuilder(),
                        ),
                      ],
                    ),
                    if (_timerDuration != null && _totalDuration != null)
                      VideoControls.timer(
                        timerDuration: _timerDuration!,
                        totalDuration: _totalDuration!,
                        paused: _paused,
                        onPaused: () => setState(
                          () => _paused = true,
                        ),
                        onPlayed: () => setState(
                          () => _paused = false,
                        ),
                        onTimerDrag: (duration) {
                          setState(() {
                            _seekDuration = duration;
                            _timerDuration = duration;
                          });
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _postActionsBuilder() {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              _liked = !_liked;
            });

            if (_liked) {
              _likeVideo();
            } else {
              _unlikeVideo();
            }
          },
          child: SvgPicture.asset(
            'assets/svg/blue like button.svg',
            color: !_liked ? whiteColor : null,
          ),
        ),
        SizedBox(
          height: 25.0,
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            setState(() {
              _paused = true;
            });
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CommentsScreen(
                  feed: widget.feed,
                ),
              ),
            );
            setState(() {
              _paused = false;
            });
          },
          child: SvgPicture.asset(
            'assets/svg/Background.svg',
            color: whiteColor,
          ),
        ),
        SizedBox(
          height: 25.0,
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            DialogProvider(context).showBottomSheet(
              widget: FeedShareBottomSheet(
                feed: widget.feed,
              ),
            );
          },
          child: SvgPicture.asset(
            'assets/svg/share lines.svg',
            color: whiteColor,
          ),
        ),
      ],
    );
  }

  Widget _backIconBuilder(final BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_rounded),
      color: whiteColor,
      onPressed: () => Navigator.pop(context, {
        'liked': _liked,
        'like_reaction_id': _likeReactionId,
      }),
    );
  }

  Widget _ownerDetailsBuilder() {
    return FutureBuilder<PeamanUser>(
      future: _userFuture,
      builder: (context, snap) {
        if (snap.hasData) {
          final _user = snap.data!;
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AvatarBuilder.image(
                  '${_user.photoUrl}',
                  size: 35.0,
                  border: true,
                  borderColor: whiteColor,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  '${_user.name}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  timeago.format(
                    DateTime.fromMillisecondsSinceEpoch(
                      widget.createdAt,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _captionBuilder() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.topLeft,
      child: HotepReadMoreText(
        widget.caption,
        height: 200.0,
        style: TextStyle(
          color: greyColorshade200,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        showMoreTextStyle: TextStyle(
          color: greyColor,
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
