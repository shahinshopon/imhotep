import 'package:flutter/material.dart';
import 'package:imhotep/helpers/dialog_provider.dart';
import 'package:imhotep/screens/friend_profile_screen.dart';
import 'package:imhotep/viewmodels/conversation_vm.dart';
import 'package:imhotep/widgets/chat_widgets/accept_decline_actions.dart';
import 'package:imhotep/widgets/chat_widgets/message_input.dart';
import 'package:imhotep/widgets/chat_widgets/messages_list.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';
import '../enums/subscription_type.dart';
import '../helpers/common_helper.dart';
import '../viewmodels/vm_provider.dart';
import '../widgets/chat_widgets/chat_blocked_builder.dart';
import '../widgets/common_widgets/avatar_builder.dart';
import '../widgets/common_widgets/block_view_profile_selector.dart';
import '../widgets/common_widgets/verified_user_badge.dart';

class ConversationScreen extends StatefulWidget {
  final PeamanUser friend;

  ConversationScreen({
    required this.friend,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  Stream<List<PeamanMessage>>? _messagesStream;

  @override
  void initState() {
    super.initState();
    final _appUser = context.read<PeamanUser>();
    final _chatId = PeamanChatHelper.getChatId(
      myId: _appUser.uid!,
      friendId: widget.friend.uid!,
    );
    _messagesStream = PChatProvider.getMessages(
      chatId: _chatId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _appUser = context.watch<PeamanUser>();
    final _chats = context.watch<List<PeamanChat>?>() ?? [];

    final _chatId = PeamanChatHelper.getChatId(
      myId: _appUser.uid!,
      friendId: widget.friend.uid!,
    );
    final _realtimeChat = _chats.firstWhere(
      (element) => element.id == _chatId,
      orElse: () => PeamanChat(),
    );

    return VMProvider<ConversationVm>(
      vm: ConversationVm(context),
      onInit: (vm) => vm.onInit(
        appUser: _appUser,
        friend: widget.friend,
      ),
      onDispose: (vm) {
        vm.setTypingState(
          _realtimeChat,
          _appUser,
          widget.friend,
          PeamanTypingStatus.idle,
        );
      },
      builder: (context, vm, appVm, appUser) {
        // this part is to update the unread messages count, show seen-unseen and typing status
        bool _isSeen = false;
        bool _isTyping = false;

        if (_realtimeChat.id != null) {
          final _isAppUserFirstUser = PeamanChatHelper.isAppUserFirstUser(
            myId: appUser!.uid!,
            friendId: widget.friend.uid!,
          );
          vm.readMessage(_realtimeChat, appUser, widget.friend);
          if (_isAppUserFirstUser) {
            if (_realtimeChat.secondUserUnreadMessagesCount <= 0) {
              _isSeen = true;
            }
            _isTyping = _realtimeChat.secondUserTyping;
          } else {
            if (_realtimeChat.firstUserUnreadMessagesCount <= 0) {
              _isSeen = true;
            }
            _isTyping = _realtimeChat.firstUserTyping;
          }
        }
        //

        final _blockedUsersIds = vm.blockedUsers.map((e) => e.uid).toList();
        final _isMeBlocked = vm.isMeBlocked;
        final _isFriendBlocked = _blockedUsersIds.contains(widget.friend.uid!);
        final _isMessageRequest =
            _realtimeChat.chatRequestStatus == PeamanChatRequestStatus.idle &&
                _realtimeChat.chatRequestSenderId != null &&
                _realtimeChat.chatRequestSenderId != appUser!.uid;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 1,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: GestureDetector(
              onTap: () {
                if (widget.friend.admin || _isMeBlocked) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FriendProfileScreen(friend: widget.friend),
                  ),
                );
              },
              child: Row(
                children: [
                  AvatarBuilder.image(widget.friend.photoUrl),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    widget.friend.name!,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
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
            ),
            leading: IconButton(
              // send to back page icon
              color: Colors.black54,
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              if (!widget.friend.admin)
                IconButton(
                  color: Colors.black54,
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    DialogProvider(context).showBottomSheet(
                      widget: BlockAndViewProfileSelector(
                        alreadyBlocked: _isFriendBlocked,
                        onViewProfile: widget.friend.admin || _isMeBlocked
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FriendProfileScreen(
                                      friend: widget.friend,
                                    ),
                                  ),
                                );
                              },
                        onBlock: () {
                          if (_isFriendBlocked) {
                            vm.unblockUser(
                              appUser!,
                              widget.friend,
                            );
                          } else {
                            vm.blockUser(
                              appUser!,
                              widget.friend,
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
          body: SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: _realtimeChat.id != null
                  ? chatMessageList(
                      _appUser,
                      _realtimeChat,
                      _isSeen,
                      _isTyping,
                      _isFriendBlocked,
                    )
                  : Container(),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: _isMessageRequest
                    ? null
                    : Border.all(
                        color: Colors.black12,
                        width: 0.75,
                      ),
              ),
              child: _isMessageRequest
                  ? AcceptDeclineActions(
                      friend: widget.friend,
                      onPressedAccept: () => vm.acceptChatRequest(
                        _realtimeChat,
                      ),
                      onPressedDecline: () => vm.declineChatRequest(
                        _realtimeChat,
                      ),
                    )
                  : _isFriendBlocked
                      ? ChatBlockedBuilder(
                          friend: widget.friend,
                          friendBlocked: true,
                          onPressedUnblock: () {
                            vm.unblockUser(appUser!, widget.friend);
                          },
                        )
                      : _isMeBlocked
                          ? ChatBlockedBuilder(
                              friend: widget.friend,
                              friendBlocked: false,
                            )
                          : MessageInput(
                              controller: vm.messageController,
                              onPressedOpenGallery: () {
                                vm.sendImgMessage(
                                  _realtimeChat,
                                  appUser!,
                                  widget.friend,
                                );
                              },
                              onPressedSendMessage: () {
                                vm.sendMessage(
                                  _realtimeChat,
                                  appUser!,
                                  widget.friend,
                                );
                              },
                              onChanged: (val) {
                                if (val.length > 0) {
                                  vm.setTypingState(
                                    _realtimeChat,
                                    appUser!,
                                    widget.friend,
                                    PeamanTypingStatus.typing,
                                  );
                                } else {
                                  vm.setTypingState(
                                    _realtimeChat,
                                    appUser!,
                                    widget.friend,
                                    PeamanTypingStatus.idle,
                                  );
                                }
                              },
                            ),
            ),
          ),
        );
      },
    );
  }

  Widget chatMessageList(
    final PeamanUser appUser,
    final PeamanChat realtimeChat,
    final bool isSeen,
    final bool isTyping,
    final bool blockedUser,
  ) {
    return Container(
      child: StreamBuilder<List<PeamanMessage>>(
        stream: _messagesStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? MessagesList(
                  chatId: realtimeChat.id!,
                  messages: snapshot.data ?? [],
                  isSeen: isSeen,
                  isTyping: isTyping,
                  friend: widget.friend,
                  appUser: appUser,
                  blockedUser: blockedUser,
                )
              : Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  ),
                );
        },
      ),
    );
  }
}
