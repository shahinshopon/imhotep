import 'package:cached_video_player/cached_video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:imhotep/models/custom_ad_model.dart';
import 'package:imhotep/widgets/feed_widgets/feed_carousel_slider_item.dart';
import '../../constants.dart';

enum _CarouselType {
  image,
  video,
}

class FeedCarouselSlider extends StatefulWidget {
  final List<String> images;
  final List<String> videos;
  final Function(int)? onPageChange;
  final _CarouselType type;
  final bool inView;
  final BoxFit fit;
  final bool requiredIndicator;
  final int initialIndex;
  final Function(List<String>, int)? onPressed;
  final double volume;
  final Function(Duration, Duration)? onVideoProgress;
  final Function(VideoPlayerController)? onVideoInitialized;
  final Duration? seekDuration;
  final bool fullScreen;
  final List<VideoPlayerController> videoControllers;
  final CustomAd? customAd;
  final int customAdPosition;

  const FeedCarouselSlider.image({
    Key? key,
    required this.images,
    this.onPageChange,
    this.inView = false,
    this.fit = BoxFit.cover,
    this.requiredIndicator = true,
    this.initialIndex = 0,
    this.onPressed,
    this.fullScreen = false,
    this.customAd,
    this.customAdPosition = -1,
  })  : type = _CarouselType.image,
        videos = const [],
        volume = 0.0,
        onVideoProgress = null,
        seekDuration = null,
        onVideoInitialized = null,
        videoControllers = const [],
        super(key: key);

  const FeedCarouselSlider.video({
    Key? key,
    required this.videos,
    this.onPageChange,
    this.inView = false,
    this.fit = BoxFit.cover,
    this.requiredIndicator = true,
    this.initialIndex = 0,
    this.onPressed,
    this.volume = 0.0,
    this.onVideoProgress,
    this.onVideoInitialized,
    this.seekDuration,
    this.fullScreen = false,
    this.videoControllers = const [],
    this.customAd,
    this.customAdPosition = -1,
  })  : type = _CarouselType.video,
        images = const [],
        super(key: key);

  @override
  State<FeedCarouselSlider> createState() => _FeedCarouselSliderState();
}

class _FeedCarouselSliderState extends State<FeedCarouselSlider> {
  int _currentIndex = 1;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex + 1;
  }

  @override
  Widget build(BuildContext context) {
    return widget.type == _CarouselType.image
        ? _imgItemBuilder()
        : _videoItemBuilder();
  }

  Widget _imgItemBuilder() {
    var _photos = widget.images;
    if (widget.customAd != null) {
      if (widget.customAdPosition != -1) {
        final _firstImages = widget.images.sublist(0, widget.customAdPosition);
        final _lastImage = widget.images.sublist(widget.customAdPosition);
        _photos = [..._firstImages, widget.customAd!.photoUrl, ..._lastImage];
      }
    }

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.width,
            autoPlay: false,
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            reverse: false,
            enlargeStrategy: CenterPageEnlargeStrategy.scale,
            enlargeCenterPage: false,
            aspectRatio: 2.0,
            initialPage: widget.initialIndex,
            onPageChanged: (index, reason) {
              widget.onPageChange?.call(index);
              setState(() {
                _currentIndex = index + 1;
              });
            },
          ),
          items: _photos.map((item) {
            final _index = _photos.indexWhere(
              (element) => element == item,
            );
            final _adCreated = widget.customAd == null
                ? false
                : _photos.contains(widget.customAd!.photoUrl);
            final _isAd =
                _adCreated ? _index == widget.customAdPosition : false;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => widget.onPressed?.call(_photos, _index),
              child: _isAd
                  ? FeedCarouselSliderItem.ad(
                      customAd: widget.customAd,
                      index: _currentIndex,
                      length: _photos.length,
                      inView: widget.inView,
                      fit: widget.fit,
                    )
                  : FeedCarouselSliderItem.image(
                      imgUrl: item,
                      index: _currentIndex,
                      length: _photos.length,
                      inView: widget.inView,
                      fit: widget.fit,
                    ),
            );
          }).toList(),
        ),
        SizedBox(
          height: _photos.length > 1 && widget.requiredIndicator ? 5.0 : 15.0,
        ),
        if (_photos.length > 1 && widget.requiredIndicator)
          _indicatorBuilder(_photos),
      ],
    );
  }

  Widget _videoItemBuilder() {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: widget.fit == BoxFit.cover
                ? MediaQuery.of(context).size.width
                : widget.fullScreen
                    ? MediaQuery.of(context).size.height - 75.0
                    : null,
            autoPlay: false,
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            reverse: false,
            enlargeStrategy: CenterPageEnlargeStrategy.scale,
            enlargeCenterPage: false,
            initialPage: widget.initialIndex,
            onPageChanged: (index, reason) {
              widget.onPageChange?.call(index);
              setState(() {
                _currentIndex = index + 1;
              });
            },
          ),
          items: widget.videos.map((item) {
            final _index =
                widget.videos.indexWhere((element) => element == item);

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => widget.onPressed?.call(widget.videos, _index),
              child: FeedCarouselSliderItem.video(
                videoUrl: item,
                index: _currentIndex,
                length: widget.videos.length,
                inView: widget.inView,
                fit: widget.fit,
                volume: widget.volume,
                onVideoProgress: widget.onVideoProgress,
                seekDuration: widget.seekDuration,
                videoController: widget.videoControllers.isNotEmpty &&
                        widget.videoControllers.length > _index
                    ? widget.videoControllers[_index]
                    : null,
                onVideoInitialized: widget.onVideoInitialized,
              ),
            );
          }).toList(),
        ),
        SizedBox(
          height:
              widget.videos.length > 1 && widget.requiredIndicator ? 5.0 : 15.0,
        ),
        if (widget.videos.length > 1 && widget.requiredIndicator)
          _indicatorBuilder(widget.videos),
      ],
    );
  }

  Widget _indicatorBuilder(final List<String> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items.asMap().entries.map((entry) {
        final _color = Theme.of(context).brightness == Brightness.dark
            ? greyColor
            : blueColor;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _controller.animateToPage(entry.key),
          child: Container(
            width: 12.0,
            height: 12.0,
            margin: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 4.0,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _color.withOpacity(
                _currentIndex - 1 == entry.key ? 0.9 : 0.4,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
