import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/widgets/common_widgets/rounded_icon_button.dart';
import 'package:photo_view/photo_view.dart';

class ViewPhotoScreen extends StatefulWidget {
  final String photoUrl;
  final bool downloadable;
  const ViewPhotoScreen({
    Key? key,
    required this.photoUrl,
    this.downloadable = true,
  }) : super(key: key);

  @override
  State<ViewPhotoScreen> createState() => _ViewPhotoScreenState();
}

class _ViewPhotoScreenState extends State<ViewPhotoScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _visible = true;
            });

            Future.delayed(Duration(milliseconds: 5000), () {
              setState(() {
                _visible = false;
              });
              _animationController.forward(from: 0.0);
            });
          },
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: whiteColor,
                    ),
                  ),
                ),
                PhotoView(
                  imageProvider: CachedNetworkImageProvider(widget.photoUrl),
                  maxScale: PhotoViewComputedScale.covered,
                  minScale: PhotoViewComputedScale.contained,
                ),
                Positioned(
                  bottom: 20.0,
                  left: 0.0,
                  right: 0.0,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _visible ? 1.0 : _animation.value,
                          child: RoundIconButton(
                            onPressed: () async {
                              try {
                                Fluttertoast.showToast(
                                  msg: 'Downloading image...',
                                );
                                final _imgId =
                                    await ImageDownloader.downloadImage(
                                  widget.photoUrl,
                                );
                                if (_imgId == null)
                                  throw ErrorSummary('imageId was null');
                                Fluttertoast.showToast(
                                  msg: 'Image downloaded!',
                                );
                              } catch (e) {
                                print(e);
                                Fluttertoast.showToast(
                                  msg: 'An unexpected error occured!',
                                );
                              }
                            },
                            bgColor: Colors.white.withOpacity(0.6),
                            icon: Icon(
                              Icons.download_rounded,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 20.0,
                  left: 20.0,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _visible ? 1.0 : _animation.value,
                          child: RoundIconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            bgColor: Colors.white.withOpacity(0.6),
                            icon: Icon(
                              Icons.arrow_back_rounded,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
