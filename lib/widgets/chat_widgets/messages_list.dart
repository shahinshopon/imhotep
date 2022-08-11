import 'package:flutter/material.dart';
import 'package:imhotep/widgets/chat_widgets/message_list_item.dart';
import 'package:imhotep/widgets/chat_widgets/temp_images_builder.dart';
import 'package:peaman/peaman.dart';

class MessagesList extends StatelessWidget {
  final String chatId;
  final bool isTyping;
  final bool isSeen;
  final PeamanUser friend;
  final PeamanUser appUser;
  final List<PeamanMessage> messages;
  final bool blockedUser;
  const MessagesList({
    Key? key,
    required this.chatId,
    required this.messages,
    required this.friend,
    required this.appUser,
    this.isSeen = false,
    this.isTyping = false,
    this.blockedUser = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(
        bottom: 10,
        top: 10,
      ),
      itemCount: messages.length,
      reverse: true,
      itemBuilder: (context, index) {
        final _message = messages[index];
        final _widget = MessageListItem(
          sender: _message.senderId == friend.uid ? friend : appUser,
          message: _message,
          isSentByMe: _message.senderId != friend.uid,
          blockedUser: blockedUser,
        );

        // display typing indicator
        if (index == 0 && isTyping) {
          return Column(
            children: [
              _widget,
              TempImgsBuilder(chatId),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Typing...',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
            ],
          );
        }
        //

        // display seen text if the other user has seen all the messages
        if (index == 0 && isSeen && _message.senderId != friend.uid) {
          return Column(
            children: [
              _widget,
              TempImgsBuilder(chatId),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Seen',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
            ],
          );
        }
        //

        if (index == 0)
          return Column(
            children: [
              _widget,
              TempImgsBuilder(chatId),
            ],
          );

        // display user details
        if (index == messages.length - 1)
          return Column(
            children: [
              // ChatUserDetails(
              //   chatUser: friend,
              // ),
              // SizedBox(
              //   height: 20.0,
              // ),
              _widget,
            ],
          );

        return _widget;
      },
    );
  }
}
