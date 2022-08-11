import 'package:flutter/material.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

import '../enums/notification_type.dart';
import '../screens/conversation_screen.dart';
import '../screens/friend_profile_screen.dart';
import '../screens/view_single_comment_screen.dart';
import '../screens/view_single_feed_screen.dart';

class NotificationNavigationHelper {
  final BuildContext context;
  NotificationNavigationHelper(this.context);

  void navigate({
    required final Map<String, dynamic> data,
  }) {
    NotificationType? _type;

    if (data['type'] is String) {
      _type = NotificationType.values[int.parse(data['type'])];
    } else {
      _type = NotificationType.values[data['type'] ?? 0];
    }

    switch (_type) {
      case NotificationType.chatMessage:
        final _chatId = data['chat_id'];
        return _chatNavigation(_chatId);
      case NotificationType.reactToComment:
        final _feedId = data['feed_id'];
        final _commentId = data['comment_id'];
        return _singleCommentNavigation(_feedId, _commentId);
      case NotificationType.replyToComment:
        final _feedId = data['feed_id'];
        final _commentId = data['comment_id'];
        return _singleCommentNavigation(_feedId, _commentId);
      case NotificationType.startedFollowing:
        final _friendId = data['friend_id'];
        return _friendProfileNavigation(_friendId);
      default:
    }
  }

  void _chatNavigation(final String chatId) async {
    final _chats = context.read<List<PeamanChat>?>() ?? [];
    final _appUser = context.read<PeamanUser?>();

    if (_chats.isNotEmpty && _appUser != null) {
      final _thisChat = _chats.firstWhere((element) => element.id == chatId);

      final _friendId = _thisChat.firstUserId == _appUser.uid
          ? _thisChat.secondUserId
          : _thisChat.firstUserId;

      final _friend = await PUserProvider.getUserById(uid: _friendId!).first;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ConversationScreen(friend: _friend),
        ),
      );
    }
  }

  // ignore: unused_element
  void _singleFeedNavigation(final String feedId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ViewSingleFeedScreen(
          feedId: feedId,
        ),
      ),
    );
  }

  void _singleCommentNavigation(
    final String feedId,
    final String commentId,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ViewSingleFeedScreen(
          feedId: feedId,
        ),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ViewSingleCommentScreen(
          feedId: feedId,
          commentId: commentId,
        ),
      ),
    );
  }

  void _friendProfileNavigation(final String friendId) async {
    final _friend = await PUserProvider.getUserById(uid: friendId).first;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FriendProfileScreen(
          friend: _friend,
        ),
      ),
    );
  }
}
