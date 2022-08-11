import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:imhotep/widgets/common_widgets/rounded_icon_button.dart';

class CachedNetworkVideo extends StatefulWidget {
  final String videoUrl;
  final bool play;
  final BoxFit fit;
  final double volume;
  final Function(Duration, Duration)? onVideoProgress;
  final Function(VideoPlayerController)? onVideoInitialized;
  final Duration? seekDuration;
  final bool requiredVolumeControl;
  final VideoPlayerController? controller;

  const CachedNetworkVideo({
    Key? key,
    required this.videoUrl,
    this.play = false,
    this.fit = BoxFit.cover,
    this.volume = 0.0,
    this.onVideoProgress,
    this.onVideoInitialized,
    this.seekDuration,
    this.requiredVolumeControl = true,
    this.controller,
  }) : super(key: key);

  @override
  State<CachedNetworkVideo> createState() => _CachedNetworkVideoState();
}

class _CachedNetworkVideoState extends State<CachedNetworkVideo> {
  VideoPlayerController? _videoPlayerController;
  bool _muted = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didUpdateWidget(CachedNetworkVideo oldWidget) {
    if (oldWidget.play != widget.play) {
      _videoPlayerController?.removeListener(_videoPlayerListener);

      if (widget.play) {
        if (!(_videoPlayerController?.value.isPlaying ?? false)) {
          _videoPlayerController?.play();
          _videoPlayerController?.setLooping(true);
          _videoPlayerController?.setVolume(_muted ? 0.0 : 1.0);
        }
      } else {
        if ((_videoPlayerController?.value.isPlaying ?? false)) {
          _videoPlayerController?.pause();
        }
      }

      _videoPlayerController?.addListener(_videoPlayerListener);
    }

    if (oldWidget.seekDuration != widget.seekDuration &&
        widget.seekDuration != null) {
      _videoPlayerController?.seekTo(widget.seekDuration!);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _videoPlayerController?.removeListener(_videoPlayerListener);
      _videoPlayerController?.dispose();
    }
    super.dispose();
  }

  // initialize
  void _initialize() async {
    if (widget.controller != null && widget.controller!.value.isInitialized) {
      _videoPlayerController = widget.controller!;
    } else {
      _videoPlayerController = VideoPlayerController.network(
        widget.videoUrl,
      );

      await _videoPlayerController?.initialize().then((value) {
        setState(() {});
        widget.onVideoInitialized?.call(_videoPlayerController!);
      });
    }

    if (widget.play) {
      _videoPlayerController?.setLooping(true);
      _videoPlayerController?.play();

      _muted = widget.volume == 0.0;
      _videoPlayerController?.setVolume(widget.volume);
      _videoPlayerController?.addListener(_videoPlayerListener);
    }
  }

  void _videoPlayerListener() {
    if (_videoPlayerController != null) {
      widget.onVideoProgress?.call(
        _videoPlayerController!.value.position,
        _videoPlayerController!.value.duration,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: blackColor,
      child: _videoPlayerController?.value.isInitialized ?? false
          ? Stack(
              children: <Widget>[
                SizedBox.expand(
                  child: FittedBox(
                    fit: widget.fit,
                    child: SizedBox(
                      width: _videoPlayerController?.value.size.width,
                      height: _videoPlayerController?.value.size.height,
                      child: VideoPlayer(_videoPlayerController!),
                    ),
                  ),
                ),
                if (widget.requiredVolumeControl)
                  Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    child: GestureDetector(
                      onTap: () {
                        _videoPlayerController?.setVolume(_muted ? 1.0 : 0.0);
                        setState(() {
                          _muted = !_muted;
                        });
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: RoundIconButton(
                          icon: Icon(
                            !_muted
                                ? Icons.volume_up_rounded
                                : Icons.volume_off_rounded,
                            size: 18.0,
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(5.0),
                          bgColor: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                color: whiteColor,
              ),
            ),
    );
  }
}
