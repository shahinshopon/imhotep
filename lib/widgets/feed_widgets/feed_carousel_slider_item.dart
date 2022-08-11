import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:imhotep/models/custom_ad_model.dart';
import 'package:imhotep/widgets/common_widgets/cached_network_video.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';

enum _CarouselItemType {
  image,
  video,
  ad,
}

class FeedCarouselSliderItem extends StatefulWidget {
  final String? imgUrl;
  final String? videoUrl;
  final int index;
  final int length;
  final _CarouselItemType type;
  final bool inView;
  final BoxFit fit;
  final double volume;
  final Function(Duration, Duration)? onVideoProgress;
  final Function(VideoPlayerController)? onVideoInitialized;
  final Duration? seekDuration;
  final VideoPlayerController? videoController;
  final CustomAd? customAd;

  const FeedCarouselSliderItem.image({
    Key? key,
    required this.imgUrl,
    required this.index,
    required this.length,
    this.inView = false,
    this.fit = BoxFit.cover,
  })  : type = _CarouselItemType.image,
        videoUrl = null,
        volume = 0.0,
        onVideoProgress = null,
        onVideoInitialized = null,
        seekDuration = null,
        videoController = null,
        customAd = null,
        super(key: key);

  const FeedCarouselSliderItem.video({
    Key? key,
    required this.videoUrl,
    required this.index,
    required this.length,
    this.inView = false,
    this.fit = BoxFit.cover,
    this.volume = 0.0,
    this.onVideoProgress,
    this.onVideoInitialized,
    this.seekDuration,
    this.videoController,
  })  : type = _CarouselItemType.video,
        imgUrl = null,
        customAd = null,
        super(key: key);

  const FeedCarouselSliderItem.ad({
    Key? key,
    required this.customAd,
    required this.index,
    required this.length,
    this.inView = false,
    this.fit = BoxFit.cover,
  })  : type = _CarouselItemType.ad,
        imgUrl = null,
        videoUrl = null,
        volume = 0.0,
        onVideoProgress = null,
        onVideoInitialized = null,
        seekDuration = null,
        videoController = null,
        super(key: key);

  @override
  State<FeedCarouselSliderItem> createState() => _FeedCarouselSliderItemState();
}

class _FeedCarouselSliderItemState extends State<FeedCarouselSliderItem>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  bool _showIndicator = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _timer = Timer(
      Duration(milliseconds: 1000),
      () => _animationController.forward(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.type == _CarouselItemType.image
        ? _imgItemBuilder()
        : widget.type == _CarouselItemType.ad
            ? _adItemBuilder()
            : _videoItemBuilder();
  }

  Widget _imgItemBuilder() {
    return Container(
      color: greyColorshade200,
      child: Stack(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: widget.imgUrl!,
            fit: widget.fit,
            width: double.infinity,
            height: double.infinity,
            fadeInDuration: Duration.zero,
            fadeOutDuration: Duration.zero,
          ),
          if (widget.length > 1 && _showIndicator)
            Positioned(
              top: 20,
              right: 20,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _animation.value,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 07,
                      height: MediaQuery.of(context).size.height / 21,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: blackColor.withOpacity(0.6),
                      ),
                      child: Center(
                        child: Text(
                          "${widget.index} / ${widget.length}",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
        ],
      ),
    );
  }

  Widget _videoItemBuilder() {
    return Container(
      color: greyColorshade200,
      child: Stack(
        children: <Widget>[
          CachedNetworkVideo(
            videoUrl: widget.videoUrl!,
            play: widget.inView,
            fit: widget.fit,
            volume: widget.volume,
            onVideoProgress: widget.onVideoProgress,
            seekDuration: widget.seekDuration,
            controller: widget.videoController,
            onVideoInitialized: widget.onVideoInitialized,
          ),
          if (widget.length > 1 && _showIndicator)
            Positioned(
              top: 20,
              right: 20,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _animation.value,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 07,
                      height: MediaQuery.of(context).size.height / 21,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: blackColor.withOpacity(0.6),
                      ),
                      child: Center(
                        child: Text(
                          "${widget.index} / ${widget.length}",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
        ],
      ),
    );
  }

  Widget _adItemBuilder() {
    return Container(
      color: greyColorshade200,
      child: Stack(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: widget.customAd!.photoUrl,
            fit: widget.fit,
            width: double.infinity,
            height: double.infinity,
            fadeInDuration: Duration.zero,
            fadeOutDuration: Duration.zero,
          ),
          if (widget.length > 1 && _showIndicator)
            Positioned(
              top: 20,
              right: 20,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _animation.value,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 07,
                      height: MediaQuery.of(context).size.height / 21,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: blackColor.withOpacity(0.6),
                      ),
                      child: Center(
                        child: Text(
                          "${widget.index} / ${widget.length}",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          Positioned(
            left: 10.0,
            top: 10.0,
            child: GestureDetector(
              onTap: () async {
                try {
                  final _link = !widget.customAd!.link.contains('http')
                      ? 'http://${widget.customAd!.link}'
                      : widget.customAd!.link;
                  await launch(_link);
                } catch (e) {
                  print(e);
                  print('Error!!!: Opening link');
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                decoration: BoxDecoration(
                  color: yellowgradientColor,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Ad',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 10.0,
            bottom: 10.0,
            child: GestureDetector(
              onTap: () async {
                try {
                  final _link = !widget.customAd!.link.contains('http')
                      ? 'http://${widget.customAd!.link}'
                      : widget.customAd!.link;
                  await launch(_link);
                } catch (e) {
                  print(e);
                  print('Error!!!: Opening link');
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                decoration: BoxDecoration(
                  color: yellowgradientColor,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'See More',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Icon(
                      Icons.arrow_circle_right,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
