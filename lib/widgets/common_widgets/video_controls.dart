import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';

enum _ControlsType {
  playPause,
  timer,
  seek,
}

class VideoControls extends StatefulWidget {
  final _ControlsType type;
  final Duration timerDuration;
  final Duration totalDuration;
  final bool paused;
  final bool seeked;
  final bool seekedForw;
  final Function(Duration)? onTimerDrag;
  final Function()? onPaused;
  final Function()? onPlayed;

  const VideoControls.playPause({
    Key? key,
    this.onPaused,
    this.onPlayed,
    this.paused = false,
  })  : type = _ControlsType.playPause,
        timerDuration = const Duration(),
        totalDuration = const Duration(),
        onTimerDrag = null,
        seeked = false,
        seekedForw = false,
        super(key: key);

  const VideoControls.seek({
    Key? key,
    this.seeked = false,
    this.seekedForw = false,
  })  : type = _ControlsType.seek,
        timerDuration = const Duration(),
        totalDuration = const Duration(),
        onPaused = null,
        onPlayed = null,
        paused = false,
        onTimerDrag = null,
        super(key: key);

  const VideoControls.timer({
    Key? key,
    required this.timerDuration,
    required this.totalDuration,
    this.onPaused,
    this.onPlayed,
    this.paused = false,
    this.onTimerDrag,
  })  : type = _ControlsType.timer,
        seeked = false,
        seekedForw = false,
        super(key: key);

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _createAnimation();
  }

  @override
  void didUpdateWidget(VideoControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.paused != widget.paused) {
      _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeIn,
        ),
      );
      _animationController.forward(from: 0.0);
    }

    if (oldWidget.seeked != widget.seeked) {
      _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeIn,
        ),
      );
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _createAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _animation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.type == _ControlsType.playPause
        ? _playPauseControlBuilder()
        : widget.type == _ControlsType.seek
            ? _seekControlBuilder()
            : _timerControlBuilder();
  }

  Widget _timerControlBuilder() {
    return Row(
      children: [
        IconButton(
          splashRadius: 20.0,
          onPressed: () {
            if (!widget.paused) {
              widget.onPaused?.call();
            } else {
              widget.onPlayed?.call();
            }
          },
          icon: Icon(
            !widget.paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
            color: whiteColor,
          ),
        ),
        _timerIndicatorBuilder(),
        SizedBox(
          width: 10.0,
        ),
        _durationBuilder(),
        SizedBox(
          width: 20.0,
        ),
      ],
    );
  }

  Widget _playPauseControlBuilder() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Icon(
            !widget.paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
            color: whiteColor,
            size: 40.0,
          ),
        );
      },
    );
  }

  Widget _seekControlBuilder() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Icon(
            widget.seekedForw
                ? Icons.arrow_forward_ios_rounded
                : Icons.arrow_back_ios_rounded,
            color: whiteColor,
            size: 30.0,
          ),
        );
      },
    );
  }

  Widget _timerIndicatorBuilder() {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final _totalInMillis = widget.totalDuration.inMilliseconds;
          final _timerInMillis = widget.timerDuration.inMilliseconds;
          final _width = (_totalInMillis - _timerInMillis) / _totalInMillis;
          final _finalWidth =
              constraints.maxWidth - _width * constraints.maxWidth;

          if (_totalInMillis == 0) return Container();

          return GestureDetector(
            onHorizontalDragUpdate: (details) {
              final _fingerPosition = details.localPosition.dx;
              if (_fingerPosition >= 0) {
                final _newTimerInMillis = _totalInMillis -
                    _totalInMillis *
                        ((constraints.maxWidth - _fingerPosition) /
                            constraints.maxWidth);

                final _newTimerDuration = Duration(
                  milliseconds: _newTimerInMillis.toInt(),
                );
                widget.onTimerDrag?.call(_newTimerDuration);
              }
            },
            onTapDown: (details) {
              final _fingerPosition = details.localPosition.dx;
              if (_fingerPosition >= 0) {
                final _newTimerInMillis = _totalInMillis -
                    _totalInMillis *
                        ((constraints.maxWidth - _fingerPosition) /
                            constraints.maxWidth);

                final _newTimerDuration = Duration(
                  milliseconds: _newTimerInMillis.toInt(),
                );
                widget.onTimerDrag?.call(_newTimerDuration);
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Stack(
                children: [
                  Container(
                    height: 3.0,
                    decoration: BoxDecoration(
                      color: greyColorshade200.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  Container(
                    height: 3.0,
                    width: _finalWidth,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _durationBuilder() {
    final _duration =
        widget.totalDuration.inSeconds - widget.timerDuration.inSeconds;
    final _durationString = widget.totalDuration.inSeconds >= 60
        ? '${Duration(seconds: _duration)}'.substring(2, 7)
        : '${Duration(seconds: _duration)}'.substring(3, 7);
    return Text(
      _durationString,
      style: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        color: whiteColor,
      ),
    );
  }
}
