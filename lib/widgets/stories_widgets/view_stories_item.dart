import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/viewmodels/view_stories_item_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/common_widgets/user_fetcher.dart';
import 'package:imhotep/widgets/common_widgets/verified_user_badge.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import '../../enums/subscription_type.dart';
import '../../helpers/common_helper.dart';
import '../../screens/friend_profile_screen.dart';
import '../comments_widgets/comment_input.dart';
import '../common_widgets/avatar_builder.dart';

const linkRegex =
    "(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})";

class ViewStoriesItem extends StatefulWidget {
  final PeamanMoment moment;
  final Function(bool) onPageChanged;
  @override
  _ViewStoriesItemState createState() => _ViewStoriesItemState();

  ViewStoriesItem({
    required this.moment,
    required this.onPageChanged,
  });
}

class _ViewStoriesItemState extends State<ViewStoriesItem>
    with TickerProviderStateMixin {
  late AnimationController _animation;
  late CachedNetworkImageProvider _img;
  int _imgIndex = 0;

  bool _isLongTap = false;
  bool _isDragging = false;
  bool _isBottomSheetOpen = false;
  bool _loading = false;
  bool _showTexts = false;
  Future<PeamanUser>? _userFuture;
  Future<List<PeamanMomentViewer>>? _momentViewersFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = PUserProvider.getUserById(
      uid: widget.moment.ownerId!,
    ).first;
    _momentViewersFuture = PFeedProvider.getMomentViewers(
      momentId: widget.moment.id!,
    ).first;
    _img = CachedNetworkImageProvider(
      '${widget.moment.pictures[_imgIndex].url}',
    );
    _handleAnimation();
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  void _handleAnimation() {
    setState(() {
      _loading = true;
    });
    _animation = AnimationController(
      duration: Duration(milliseconds: 5000),
      vsync: this,
    );

    // play animation only when the image is fully loaded
    _img.resolve(new ImageConfiguration()).addListener(
      ImageStreamListener((info, call) {
        _animation.forward();
        setState(() {
          _loading = false;
        });
      }),
    );

    _animation.addListener(() {
      if (_animation.isCompleted) {
        _pageChangeLogic();
      }
      setState(() {});
    });
  }

  void _pageChangeLogic({bool reverse = false}) {
    setState(() {
      _showTexts = false;
    });
    if (reverse) {
      if (_imgIndex > 0) {
        _imgIndex--;
        _restartAnimation();
      } else {
        widget.onPageChanged(!reverse);

        Future.delayed(Duration(milliseconds: 100), () {});
      }
    } else {
      if (_imgIndex < (widget.moment.pictures.length - 1)) {
        _imgIndex++;
        _restartAnimation();
      } else {
        widget.onPageChanged(!reverse);
        Future.delayed(Duration(milliseconds: 100), () {});
      }
    }
  }

  void _restartAnimation() {
    _animation.dispose();
    _img = CachedNetworkImageProvider(
      '${widget.moment.pictures[_imgIndex].url}',
    );
    _handleAnimation();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _appUser = context.watch<PeamanUser>();
    final _texts = List<String>.from(
      widget.moment.pictures[_imgIndex].extraData['story_texts'] ?? [],
    );

    return VMProvider<ViewStoriesItemVm>(
      vm: ViewStoriesItemVm(context),
      onInit: (vm) => vm.onInit(_appUser, widget.moment),
      builder: (context, vm, appVm, appUser) {
        return GestureDetector(
          onLongPressStart: (details) {
            setState(() {
              _isLongTap = true;
            });
          },
          onLongPressEnd: (details) {
            _animation.forward();
            setState(() {
              _isLongTap = false;
            });
          },
          onTapDown: (details) {
            _animation.stop();
            FocusScope.of(context).unfocus();
          },
          onTapUp: (details) {
            if (_isBottomSheetOpen) {
              Navigator.pop(context);
              setState(() {
                _isBottomSheetOpen = false;
              });
            } else {
              _animation.forward();

              if (_texts.isNotEmpty) {
                setState(() {
                  _showTexts = !_showTexts;
                });
                if (_showTexts) {
                  _animation.stop();
                } else {
                  _animation.forward();
                }
              }

              final _leftTapPos = 20 / 100 * _width;
              final _rightTapPos = 80 / 100 * _width;

              if (!_isLongTap && !_isDragging) {
                if (details.globalPosition.dx >= _rightTapPos) {
                  _pageChangeLogic();
                } else if (details.globalPosition.dx <= _leftTapPos) {
                  _pageChangeLogic(reverse: true);
                }
              }
            }
          },
          onVerticalDragEnd: (details) async {
            _animation.forward();

            if (_texts.isNotEmpty) {
              _animation.stop();
              try {
                if (await canLaunch('http://${_texts.first}')) {
                  await launch('http://${_texts.first}');
                } else {
                  throw Future.error('Unexpected error');
                }
              } catch (e) {
                print(e);
                print('Error!!!: Opening link');
              }
              _animation.forward();
            }
          },
          child: Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image(image: _img),
                ),
                _headerSectionBuilder(appUser!, vm),
                Positioned(
                  bottom: 10.0,
                  left: 10.0,
                  right: 10.0,
                  child: _footerSectionBuilder(appUser, vm),
                ),
                if (_showTexts)
                  Positioned.fill(
                    top: 150.0,
                    child: Center(
                      child: _textViewer(),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _headerSectionBuilder(
    final PeamanUser appUser,
    final ViewStoriesItemVm vm,
  ) {
    return Column(
      children: [
        SizedBox(
          height: 10.0,
        ),
        _indicator(),
        UserFetcher.singleFuture(
          userFuture: _userFuture,
          singleBuilder: (user) {
            final _user = user;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AvatarBuilder.image(
                        '${_user.photoUrl}',
                        size: 35.0,
                        border: true,
                        borderColor: whiteColor,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FriendProfileScreen(
                                friend: user,
                              ),
                            ),
                          );
                        },
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
                      if (CommonHelper.subscriptionType(
                            context,
                            user: user,
                          ) ==
                          SubscriptionType.level3)
                        SizedBox(
                          width: 5.0,
                        ),
                      if (CommonHelper.subscriptionType(
                            context,
                            user: user,
                          ) ==
                          SubscriptionType.level3)
                        VerifiedUserBadge(
                          color: whiteColor,
                        ),
                      SizedBox(
                        width: 8.0,
                      ),
                      if (widget.moment.pictures[_imgIndex].createdAt != null)
                        Text(
                          timeago.format(
                            DateTime.fromMillisecondsSinceEpoch(
                              widget.moment.pictures[_imgIndex].createdAt!,
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
                      if (_loading)
                        Container(
                          width: 18.0,
                          height: 18.0,
                          child: CircularProgressIndicator(
                            color: whiteColor,
                            strokeWidth: 1.0,
                          ),
                        ),
                    ],
                  ),
                  if (appUser.uid == widget.moment.ownerId)
                    PopupMenuButton(
                      onCanceled: () {
                        _animation.forward();
                      },
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: whiteColor,
                      ),
                      itemBuilder: (context) {
                        if (_animation.isAnimating) {
                          _animation.stop();
                        }
                        return [
                          PopupMenuItem(
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: redAccentColor,
                              ),
                            ),
                            onTap: () => vm.deleteMomentPicture(
                              widget.moment.id!,
                              widget.moment.pictures[_imgIndex].id!,
                            ),
                          ),
                        ];
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _footerSectionBuilder(
    final PeamanUser appUser,
    final ViewStoriesItemVm vm,
  ) {
    return Row(
      children: [
        if (widget.moment.ownerId == appUser.uid) _viewsBuilder(appUser),
        if (widget.moment.ownerId == appUser.uid)
          SizedBox(
            width: 10.0,
          ),
        if (widget.moment.ownerId != appUser.uid)
          Expanded(child: _commentBuilder(appUser, vm)),
      ],
    );
  }

  Widget _commentBuilder(
    final PeamanUser appUser,
    final ViewStoriesItemVm vm,
  ) {
    return KeyboardVisibilityBuilder(
      builder: (context, val) {
        if (val && _animation.isAnimating) {
          _animation.stop();
        } else if (!val &&
            !_animation.isAnimating &&
            !_isLongTap &&
            !_loading) {
          _animation.forward();
        }
        return CommentInput(
          controller: vm.commentController,
          onPressedSend: () {
            vm.sendMessage(appUser, widget.moment);
          },
          onPressedCancelReply: () {},
        );
      },
    );
  }

  Widget _viewsBuilder(final PeamanUser appUser) {
    return widget.moment.id == null || widget.moment.views == 0
        ? Container(
            color: Colors.transparent,
            child: Row(
              children: [
                Icon(Icons.visibility, color: Colors.white),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  '${0}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          )
        : FutureBuilder<List<PeamanMomentViewer>>(
            future: _momentViewersFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final _seenUsers = snapshot.data ?? [];

                return GestureDetector(
                  onTap: _seenUsers.isEmpty
                      ? () {}
                      : () async {
                          setState(() {
                            _isBottomSheetOpen = true;
                          });
                          _animation.stop();

                          final _controller = showBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: MediaQuery.of(context).size.height / 2,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.visibility,
                                            color: Colors.black,
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            '${_seenUsers.length}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.separated(
                                        itemCount: _seenUsers.length,
                                        itemBuilder: (context, index) {
                                          final _momentViewer =
                                              _seenUsers[index];
                                          return UserFetcher.singleStream(
                                            userStream:
                                                PUserProvider.getUserById(
                                              uid: _momentViewer.uid!,
                                            ),
                                            singleBuilder: (seenUser) {
                                              return ListTile(
                                                leading: AvatarBuilder.image(
                                                  seenUser.photoUrl,
                                                ),
                                                title: Text(
                                                  '${seenUser.name}',
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20.0,
                                            ),
                                            child: Divider(),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                          final _val = await _controller.closed;
                          if (_val == null) {
                            _animation.forward();
                          }
                        },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Icon(Icons.visibility, color: Colors.white),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          '${_seenUsers.length}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
              return CircularProgressIndicator(
                color: whiteColor,
              );
            },
          );
  }

  Widget _indicator() {
    return Row(
      children: [
        for (int i = 0; i < widget.moment.pictures.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: i == (widget.moment.pictures.length - 1) ? 0.0 : 3.0,
              ),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    minHeight: 1.5,
                    value: _imgIndex == i
                        ? _animation.value
                        : _imgIndex <= i
                            ? 0.0
                            : 1.0,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _textViewer() {
    final _texts = List<String>.from(
        widget.moment.pictures[_imgIndex].extraData['story_texts'] ?? []);

    final _links = _texts.where((element) {
      final _regex = RegExp(linkRegex);
      return _regex.hasMatch(element);
    }).toList();

    if (_links.isEmpty) return Container();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0.0,
          right: 0.0,
          top: -8.0,
          child: Center(
            child: Transform.rotate(
              angle: pi / 4,
              child: Container(
                width: 20.0,
                height: 20.0,
                decoration: BoxDecoration(
                  color: blueColor,
                  borderRadius: BorderRadius.circular(3.0),
                ),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: blueColor,
            borderRadius: BorderRadius.circular(
              5.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 10.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final _link in _links)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: _links.indexOf(_link) != (_links.length - 1)
                        ? 5.0
                        : 0.0,
                  ),
                  child: Linkify(
                    onOpen: (link) async {
                      try {
                        await launch(link.url);
                      } catch (e) {
                        print(e);
                        print('Error!!!: Opening link');
                      }
                    },
                    linkStyle: TextStyle(
                      color: whiteColor,
                    ),
                    text: _link,
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}
