import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/enums/feed_subscription_type.dart';
import 'package:imhotep/models/feed_extra_data_model.dart';
import 'package:imhotep/screens/view_photo_screen.dart';
import 'package:imhotep/screens/view_single_feed_screen.dart';
import 'package:imhotep/screens/view_stories_screen.dart';
import 'package:imhotep/widgets/feed_widgets/premium_feed_cover.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../helpers/date_time_helper.dart';
import '../../screens/friend_profile_screen.dart';
import '../common_widgets/avatar_builder.dart';

class MessageListItem extends StatefulWidget {
  final PeamanUser sender;
  final PeamanMessage message;
  final bool isSentByMe;
  final bool blockedUser;
  MessageListItem({
    required this.sender,
    required this.message,
    this.isSentByMe = false,
    this.blockedUser = false,
  });

  @override
  State<MessageListItem> createState() => _MessageListItemState();
}

class _MessageListItemState extends State<MessageListItem> {
  bool _showTime = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _showTime = !_showTime),
      child: Container(
        padding: EdgeInsets.only(
          left: widget.isSentByMe ? 80 : 12,
          right: widget.isSentByMe ? 12 : 80,
        ),
        margin: EdgeInsets.symmetric(vertical: 5.0),
        width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: widget.isSentByMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (!widget.isSentByMe)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (widget.sender.admin || widget.blockedUser) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FriendProfileScreen(
                        friend: widget.sender,
                      ),
                    ),
                  );
                },
                child: AvatarBuilder.image(
                  '${widget.sender.photoUrl}',
                  size: 35.0,
                ),
              ),
            if (!widget.isSentByMe)
              SizedBox(
                width: 10.0,
              ),
            _messageBuilder(context),
            if (widget.isSentByMe)
              SizedBox(
                width: 5.0,
              ),
          ],
        ),
      ),
    );
  }

  Widget _messageBuilder(final BuildContext context) {
    switch (widget.message.type) {
      case PeamanMessageType.text:
        return _textMsgBuilder(widget.message.text!);
      case PeamanMessageType.image:
        return _imgMsgBuilder(widget.message.text!);
      case PeamanMessageType.momentReply:
        return _momentReplyMsgBuilder();
      case PeamanMessageType.feedShare:
        return Expanded(child: _feedShareMsgBuilder());
      default:
        return Container();
    }
  }

  Widget _textMsgBuilder(final String text) {
    final _messageDate = DateTime.fromMillisecondsSinceEpoch(
      widget.message.createdAt!,
    );
    return Column(
      crossAxisAlignment:
          widget.isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 1.7,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSentByMe ? blueColor : greyColorshade300,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: widget.isSentByMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Linkify(
                text: text,
                onOpen: (link) async {
                  try {
                    await launch(link.url);
                  } catch (e) {
                    print(e);
                  }
                },
                style: TextStyle(
                  color: widget.isSentByMe ? whiteColor : blackColor,
                  fontSize: 14,
                ),
                linkStyle: TextStyle(
                  color: widget.isSentByMe ? whiteColor : blueColor,
                ),
              ),
            ],
          ),
        ),
        if (_showTime)
          SizedBox(
            height: 5.0,
          ),
        if (_showTime)
          Padding(
            padding: EdgeInsets.only(
              right: widget.isSentByMe ? 3.0 : 0.0,
              left: widget.isSentByMe ? 0.0 : 3.0,
            ),
            child: Text(
              '${DateTimeHelper.getFormattedTime(
                TimeOfDay(
                  hour: _messageDate.hour,
                  minute: _messageDate.minute,
                ),
              )}',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 10,
              ),
            ),
          ),
      ],
    );
  }

  Widget _imgMsgBuilder(final String img) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ViewPhotoScreen(
              photoUrl: img,
            ),
          ),
        );
      },
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width / 1.7,
        ),
        child: Center(
          child: CachedNetworkImage(
            imageUrl: img,
          ),
        ),
      ),
    );
  }

  Widget _momentReplyMsgBuilder() {
    final _moments = context.watch<List<PeamanMoment>?>() ?? [];
    final _repliedToStoryWidget = Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text(
        '${widget.isSentByMe ? 'You' : 'They'} replied to ${widget.isSentByMe ? 'their' : 'your'} story',
        style: TextStyle(
          color: greyColor,
          fontSize: 12.0,
        ),
      ),
    );
    final _crossAxisAlignment =
        widget.isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: _crossAxisAlignment,
      children: [
        SizedBox(
          height: 10.0,
        ),
        if (widget.message.extraId != null)
          StreamBuilder<PeamanMoment>(
            stream: PFeedProvider.getSingleMomentById(
              momentId: widget.message.extraId!,
            ),
            builder: (context, snap) {
              if (snap.hasData) {
                final _moment = snap.data!;
                final _imgUrl = _moment.pictures.first;

                return Column(
                  crossAxisAlignment: _crossAxisAlignment,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ViewStoriesScreen(
                              moments: _moments,
                              initIndex: _moments.indexWhere(
                                (element) =>
                                    element.id == widget.message.extraId,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 150.0,
                        height: 220.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(color: blueColor),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(_imgUrl.url!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'View Story',
                                style: TextStyle(
                                  color: blueColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _repliedToStoryWidget,
                  ],
                );
              }
              return _repliedToStoryWidget;
            },
          ),
        _textMsgBuilder(widget.message.text!),
      ],
    );
  }

  Widget _feedShareMsgBuilder() {
    final _sharedAPostWidget = Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text(
        '${widget.isSentByMe ? 'You' : 'They'} shared a post to ${widget.isSentByMe ? 'them' : 'you'}',
        style: TextStyle(
          color: greyColor,
          fontSize: 12.0,
        ),
      ),
    );
    final _crossAxisAlignment =
        widget.isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: _crossAxisAlignment,
      children: [
        SizedBox(
          height: 10.0,
        ),
        if (widget.message.extraId != null)
          StreamBuilder<PeamanFeed>(
            stream: PFeedProvider.getSingleFeedById(
              feedId: widget.message.extraId!,
            ),
            builder: (context, snap) {
              if (snap.hasData) {
                final _feed = snap.data!;
                final _feedType = _feed.type;
                final _feedExtraData = _feed.type == PeamanFeedType.other
                    ? FeedExtraData.fromJson(_feed.extraData)
                    : null;

                final _imgUrl = _feedType == PeamanFeedType.other
                    ? _feedExtraData!.article!.photos.first
                    : _feed.photos.first;

                return Column(
                  crossAxisAlignment: _crossAxisAlignment,
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ViewSingleFeedScreen(
                                  feed: _feed,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            height: 300.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(color: blueColor),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(_imgUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    _feed.type == PeamanFeedType.video
                                        ? Icons.play_arrow_rounded
                                        : _feed.type == PeamanFeedType.image &&
                                                _feed.photos.length > 1
                                            ? Icons.style
                                            : _feed.type ==
                                                        PeamanFeedType.image &&
                                                    _feed.photos.length == 1
                                                ? Icons.insert_photo_rounded
                                                : Icons.description_rounded,
                                    color: whiteColor,
                                  ),
                                ),
                                Container(
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'View Post',
                                      style: TextStyle(
                                        color: blueColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (FeedExtraData.fromJson(
                              _feed.extraData,
                            ).subscriptionType ==
                            FeedSubscriptionType.paid)
                          Positioned.fill(
                            child: PremiumFeedCover.medium(
                              borderRadius: 20.0,
                            ),
                          ),
                      ],
                    ),
                    _sharedAPostWidget,
                  ],
                );
              }
              return _sharedAPostWidget;
            },
          ),
      ],
    );
  }
}
