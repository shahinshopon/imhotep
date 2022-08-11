import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/helpers/dialog_provider.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:imhotep/viewmodels/temp_imgs_vm.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

import '../models/maat_warrior_config_model.dart';
import '../models/temp_img_model.dart';
import '../services/firebase/database/maat_warrior_provider.dart';

class ConversationVm extends BaseVm {
  final BuildContext context;
  ConversationVm(this.context);

  TextEditingController _messageController = TextEditingController();
  File? _imgFile;
  bool _isMeBlocked = false;

  TextEditingController get messageController => _messageController;
  List<PeamanChat> get chats => context.watch<List<PeamanChat>>();
  List<PeamanBlockedUser> get blockedUsers =>
      context.watch<List<PeamanBlockedUser>>();
  File? get imgFile => _imgFile;
  bool get isMeBlocked => _isMeBlocked;

  // init function
  void onInit({
    required final PeamanUser appUser,
    required final PeamanUser friend,
  }) async {
    updateStateType(StateType.busy);
    final _isBlocked = await PUserProvider.checkIfBlocked(
      uid: appUser.uid!,
      friendId: friend.uid!,
    );
    _isMeBlocked = _isBlocked;
    updateStateType(StateType.idle);
  }

  // send message
  Future<void> sendMessage(
    final PeamanChat chat,
    final PeamanUser appUser,
    final PeamanUser friend,
  ) async {
    if (_messageController.text.trim() != '') {
      final _chatId = chat.id ??
          PeamanChatHelper.getChatId(
            myId: appUser.uid!,
            friendId: friend.uid!,
          );
      final _message = PeamanMessage(
        id: null,
        chatId: _chatId,
        text: _messageController.text.trim(),
        senderId: appUser.uid!,
        receiverId: friend.uid!,
        type: PeamanMessageType.text,
      );

      _messageController.clear();
      setTypingState(chat, appUser, friend, PeamanTypingStatus.idle);
      PChatProvider.sendMessage(message: _message);

      // update maat warrior points
      final _maatWarriorConfig = context.read<MaatWarriorConfig>();
      if (_maatWarriorConfig.messageUserPoints > 0) {
        MaatWarriorProvider.updateMaatWarriorPoints(
          uid: appUser.uid!,
          points: _maatWarriorConfig.messageUserPoints,
        );
      }
      //
    }
  }

  // send img message
  Future sendImgMessage(
    final PeamanChat chat,
    final PeamanUser appUser,
    final PeamanUser friend,
  ) async {
    final _tempImgVm = context.read<TempImgVM>();

    final _pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (_pickedImage != null) {
      _imgFile = File(_pickedImage.path);
    }

    if (_imgFile != null) {
      final _chatId = chat.id ??
          PeamanChatHelper.getChatId(
            myId: appUser.uid!,
            friendId: friend.uid!,
          );

      final _tempImg = TempImg(
        parentId: _chatId,
        imgFile: _imgFile,
        progress: 0.0,
      );
      _tempImgVm.addItem(_tempImg);

      final _imgUrl = await PStorageProvider.uploadFile(
        'chats/$_chatId/${_chatId}_${DateTime.now().millisecondsSinceEpoch}',
        _imgFile!,
      );

      final _message = PeamanMessage(
        id: null,
        chatId: _chatId,
        text: _imgUrl!,
        senderId: appUser.uid!,
        receiverId: friend.uid!,
        type: PeamanMessageType.image,
      );

      await PChatProvider.sendMessage(message: _message);

      _tempImgVm.removeItem(_tempImg);
    }
  }

  // set typing state
  Future setTypingState(
    final PeamanChat chat,
    final PeamanUser appUser,
    final PeamanUser friend,
    final PeamanTypingStatus typingState,
  ) async {
    if (chat.chatRequestStatus != PeamanChatRequestStatus.accepted) return;

    if (chat.id != null) {
      final _isAppUserFirstUser = PeamanChatHelper.isAppUserFirstUser(
        myId: appUser.uid!,
        friendId: friend.uid!,
      );

      bool _change = true;

      if (_isAppUserFirstUser) {
        if (typingState == PeamanTypingStatus.typing) {
          _change = !chat.firstUserTyping;
        } else {
          _change = chat.firstUserTyping;
        }
      } else {
        if (typingState == PeamanTypingStatus.typing) {
          _change = !chat.secondUserTyping;
        } else {
          _change = chat.secondUserTyping;
        }
      }

      if (_change) {
        return await PChatProvider.setTypingStatus(
          chatId: chat.id!,
          chatUser: _isAppUserFirstUser
              ? PeamanChatUser.first
              : PeamanChatUser.second,
          typingState: typingState,
        );
      }
    }
  }

  // read chat message
  Future readMessage(
    final PeamanChat chat,
    final PeamanUser appUser,
    final PeamanUser friend,
  ) async {
    if (chat.chatRequestStatus != PeamanChatRequestStatus.accepted) return;

    final _isAppUserFirstUser = PeamanChatHelper.isAppUserFirstUser(
      myId: appUser.uid!,
      friendId: friend.uid!,
    );

    bool _change = true;

    if (_isAppUserFirstUser) {
      _change = chat.firstUserUnreadMessagesCount > 0;
    } else {
      _change = chat.secondUserUnreadMessagesCount > 0;
    }

    if (_change) {
      return await PChatProvider.readMessage(
        chatId: chat.id!,
        chatUser:
            _isAppUserFirstUser ? PeamanChatUser.first : PeamanChatUser.second,
      );
    }
  }

  // update chat with id
  Future updateChat(
    final String chatId,
    final Map<String, dynamic> data,
  ) async {
    return await PChatProvider.updateChat(chatId: chatId, data: data);
  }

  // accept chat request
  Future acceptChatRequest(final PeamanChat chat) async {
    await PChatProvider.acceptRequest(chatId: chat.id!);
  }

  // decline chat request
  Future declineChatRequest(final PeamanChat chat) async {
    showToast('Message request declined!');
    Navigator.pop(context);
    PChatProvider.declineRequest(
      chatId: chat.id!,
      onSuccess: (_) {},
      onError: (_) {
        showToast('An unexpected error occured!');
      },
    );
  }

  // block user
  void blockUser(
    final PeamanUser appUser,
    final PeamanUser friend,
  ) {
    DialogProvider(context).showAlertDialog(
      title: 'Are you sure you want to block ${friend.name} ?',
      description:
          "Doing this will prevent you from receiving any messages from this user.",
      onPressedPositiveBtn: () {
        showToast('Blocked ${friend.name}');
        PUserProvider.blockUser(
          uid: appUser.uid!,
          friendId: friend.uid!,
        );
      },
    );
  }

  // unblock user
  Future<void> unblockUser(
    final PeamanUser appUser,
    final PeamanUser friend,
  ) async {
    showToast('Unblocked ${friend.name}');
    await PUserProvider.unblockUser(
      uid: appUser.uid!,
      friendId: friend.uid!,
    );
  }
}
