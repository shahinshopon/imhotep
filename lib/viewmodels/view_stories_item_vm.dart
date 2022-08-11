import 'package:flutter/material.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:peaman/peaman.dart';

class ViewStoriesItemVm extends BaseVm {
  final BuildContext context;
  ViewStoriesItemVm(this.context);

  bool _seen = false;
  final TextEditingController _commentController = TextEditingController();

  bool get seen => _seen;
  TextEditingController get commentController => _commentController;

  // init function
  void onInit(
    final PeamanUser appUser,
    final PeamanMoment moment,
  ) {
    if (moment.ownerId != appUser.uid) {
      _viewMoment(appUser, moment);
    }
  }

  // delete moment picture
  void deleteMomentPicture(
    final String momentId,
    final String pictureId,
  ) async {
    await PFeedProvider.deletMomentPicture(
      momentId: momentId,
      pictureId: pictureId,
    );
    Navigator.pop(context);
  }

  // send message
  Future<void> sendMessage(
    final PeamanUser appUser,
    final PeamanMoment moment,
  ) async {
    if (_commentController.text.trim() != '') {
      FocusScope.of(context).unfocus();
      final _chatId = PeamanChatHelper.getChatId(
        myId: appUser.uid!,
        friendId: moment.ownerId!,
      );
      final _message = PeamanMessage(
        chatId: _chatId,
        text: _commentController.text.trim(),
        senderId: appUser.uid!,
        receiverId: moment.ownerId!,
        type: PeamanMessageType.momentReply,
        extraId: moment.id,
      );

      _commentController.clear();
      showToast("Commented on the story");
      await PChatProvider.sendMessage(message: _message);
    }
  }

  // view moment
  void _viewMoment(
    final PeamanUser appUser,
    final PeamanMoment moment,
  ) async {
    _updateSeen(true);
    await PFeedProvider.viewMoment(
      momentId: moment.id!,
      uid: appUser.uid!,
    );
  }

  // update value of seen
  void _updateSeen(final bool val) {
    _seen = val;
    notifyListeners();
  }
}
