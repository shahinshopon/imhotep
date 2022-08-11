import 'package:flutter/material.dart';
import 'package:imhotep/helpers/common_helper.dart';
import 'package:imhotep/screens/conversation_screen.dart';
import 'package:imhotep/widgets/common_widgets/avatar_builder.dart';
import 'package:imhotep/widgets/common_widgets/hotep_button.dart';
import 'package:peaman/peaman.dart';
import '../../constants.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../enums/subscription_type.dart';
import '../common_widgets/admin_badge.dart';
import '../common_widgets/maat_warrior_badge.dart';
import '../common_widgets/verified_user_badge.dart';

class ChatListItem extends StatefulWidget {
  final PeamanChat chat;
  final PeamanUser appUser;
  final PeamanUser friend;
  const ChatListItem({
    Key? key,
    required this.chat,
    required this.appUser,
    required this.friend,
  }) : super(key: key);

  @override
  State<ChatListItem> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  @override
  Widget build(BuildContext context) {
    // get the unread messages count
    final _isAppUserFirstUser = PeamanChatHelper.isAppUserFirstUser(
      myId: widget.appUser.uid!,
      friendId: widget.friend.uid!,
    );

    final _unreadCount = _isAppUserFirstUser
        ? widget.chat.firstUserUnreadMessagesCount
        : widget.chat.secondUserUnreadMessagesCount;
    //

    if (widget.chat.lastMessageId == null) return Container();

    return StreamBuilder<PeamanMessage>(
      stream: PChatProvider.getSingleMessageById(
        chatId: widget.chat.id!,
        messageId: widget.chat.lastMessageId!,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final _message = snapshot.data!;
          final _messageText = CommonHelper.limitedText(
            _message.text?.trim(),
            limit: 100,
          );

          var _displayText = _message.senderId == widget.appUser.uid
              ? _message.type == PeamanMessageType.image
                  ? 'You: Sent an image'
                  : _message.type == PeamanMessageType.feedShare
                      ? 'You: Shared a post'
                      : 'You: $_messageText'
              : _message.type == PeamanMessageType.image
                  ? 'Sent and image'
                  : _message.type == PeamanMessageType.feedShare
                      ? 'Shared a post'
                      : '$_messageText';

          _displayText = _displayText.contains('\n')
              ? _displayText.split('\n').first
              : _displayText;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConversationScreen(
                  friend: widget.friend,
                ),
              ),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      AvatarBuilder.image(
                        '${widget.friend.photoUrl}',
                        size: 60.0,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonHelper.isMaatWarrior(
                                context,
                                user: widget.friend,
                              )
                                  ? MaatWarriorBadge()
                                  : widget.friend.admin
                                      ? AdminBadge()
                                      : Container(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${widget.friend.name}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: blueColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      if (CommonHelper.subscriptionType(context,
                                              user: widget.friend) ==
                                          SubscriptionType.level3)
                                        VerifiedUserBadge(),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    timeago.format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        _message.createdAt!,
                                      ),
                                      locale: 'en_short',
                                    ),
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Text(
                                      CommonHelper.limitedText(
                                        _displayText,
                                        limit: 100,
                                      ),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: blackColor,
                                      ),
                                    ),
                                  ),
                                  if (_unreadCount > 0)
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                  if (_unreadCount > 0)
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: blueColor,
                                      ),
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                        '$_unreadCount',
                                        style: TextStyle(
                                          fontSize: 8,
                                          color: whiteColor,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.chat.chatRequestStatus ==
                          PeamanChatRequestStatus.idle &&
                      widget.chat.chatRequestSenderId != widget.appUser.uid)
                    _allowDeclineBuilder(context),
                ],
              ),
            ),
          );
        }

        return Container();
      },
    );
  }

  Widget _allowDeclineBuilder(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        HotepButton.bordered(
          value: 'Decline',
          borderColor: redAccentColor,
          padding: const EdgeInsets.all(0.0),
          borderRadius: 10.0,
          onPressed: () {
            PChatProvider.declineRequest(chatId: widget.chat.id!);
          },
        ),
        SizedBox(
          width: 10.0,
        ),
        HotepButton.filled(
          value: 'Accept',
          padding: const EdgeInsets.all(0.0),
          borderRadius: 10.0,
          onPressed: () {
            PChatProvider.acceptRequest(
              chatId: widget.chat.id!,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConversationScreen(
                  friend: widget.friend,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
