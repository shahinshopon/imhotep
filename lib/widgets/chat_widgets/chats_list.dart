import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/widgets/chat_widgets/chat_list_item.dart';
import 'package:peaman/peaman.dart';

class ChatsList extends StatelessWidget {
  final PeamanUser appUser;
  final List<PeamanChat>? chats;
  final bool requiredDivider;
  const ChatsList({
    Key? key,
    required this.appUser,
    required this.chats,
    this.requiredDivider = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return chats != null
        ? ListView.separated(
            itemCount: chats!.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final _chat = chats![index];

              if (_chat.firstUserId == null || _chat.secondUserId == null)
                return Container();

              final _friendId = _chat.firstUserId == appUser.uid
                  ? _chat.secondUserId
                  : _chat.firstUserId;

              if (_friendId == null) return Container();

              return StreamBuilder<PeamanUser>(
                stream: PUserProvider.getUserById(uid: _friendId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final _friend = snapshot.data!;

                    return ChatListItem(
                      chat: _chat,
                      appUser: appUser,
                      friend: _friend,
                    );
                  }
                  return Container();
                },
              );
            },
            separatorBuilder: (context, index) {
              return requiredDivider ? Divider() : Container();
            },
          )
        : Center(
            child: CircularProgressIndicator(
              color: blueColor,
            ),
          );
  }
}
