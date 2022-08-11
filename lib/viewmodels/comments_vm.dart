import 'package:flutter/material.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/models/archived_comment_model.dart';
import 'package:imhotep/models/feed_extra_data_model.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

import '../models/maat_warrior_config_model.dart';
import '../services/firebase/database/maat_warrior_provider.dart';

class CommentsVm extends BaseVm {
  final BuildContext context;
  CommentsVm(this.context);

  final TextEditingController _commentController = TextEditingController();
  PeamanComment? _commentToReply;
  PeamanComment? _commentToEdit;
  String? _replyingTo;
  bool _getNotification = false;

  // number of comments that the user made after they visited the comments screen
  int _comments = 0;
  //

  TextEditingController get commentController => _commentController;
  String? get replyingTo => _replyingTo;
  PeamanComment? get commentToReply => _commentToReply;
  PeamanComment? get commentToEdit => _commentToEdit;
  bool get getNotification => _getNotification;
  int get comments => _comments;

  // init function
  void onInit({
    required final PeamanUser appUser,
    required final PeamanFeed feed,
  }) async {
    updateStateType(StateType.busy);
    final _feedFollower = await PFeedProvider.getFeedFollowerByUid(
      feedId: feed.id!,
      uid: appUser.uid!,
    );
    _getNotification = _feedFollower != null;
    updateStateType(StateType.idle);
  }

  // comment on the feed
  void commentToFeed(
    final PeamanUser appUser,
    final PeamanFeed feed,
  ) async {
    if (_commentController.text.trim() != '') {
      FocusScope.of(context).unfocus();
      final _millis = DateTime.now().millisecondsSinceEpoch;
      final _commentText = _commentController.text.trim();
      _commentController.clear();
      final _comment = PeamanComment(
        feedId: feed.id,
        ownerId: appUser.uid,
        parent: PeamanCommentParent.feed,
        parentId: feed.id,
        comment: _commentText,
        createdAt: _millis,
      );

      if (_commentToEdit != null) {
        await PFeedProvider.updateComment(
          feedId: feed.id!,
          commentId: _commentToEdit!.id!,
          data: {
            'comment': _commentText,
          },
        );
      } else {
        // update maat warrior points
        final _maatWarriorConfig = context.read<MaatWarriorConfig>();
        if (_maatWarriorConfig.commentPostPoints > 0) {
          MaatWarriorProvider.updateMaatWarriorPoints(
            uid: appUser.uid!,
            points: _maatWarriorConfig.commentPostPoints,
          );
        }
        //

        await PFeedProvider.addComment(
          comment: _comment,
          onSuccess: (comment) {
            updateComments(++_comments);

            final _article = feed.type == PeamanFeedType.other
                ? FeedExtraData.fromJson(feed.extraData).article
                : null;
            final _caption = feed.type == PeamanFeedType.other
                ? _article!.title
                : feed.caption;

            ArchivedComment(
              feedId: feed.id,
              caption: _caption,
              commentId: comment.id,
              comment: comment.comment,
              createdAt: DateTime.now().millisecondsSinceEpoch,
            )..saveArchiveComment(uid: appUser.uid!);
          },
        );
      }
      updateCommentToEdit(null);
    }
  }

  // reply to comment
  void replyToComment(
    final PeamanUser appUser,
    final PeamanFeed feed,
    final PeamanComment comment,
  ) async {
    if (_commentController.text.trim() != '') {
      FocusScope.of(context).unfocus();
      final _millis = DateTime.now().millisecondsSinceEpoch;
      final _commentText = _commentController.text.trim();
      final _reply = PeamanComment(
        feedId: feed.id,
        ownerId: appUser.uid,
        secondUserId: comment.ownerId,
        secondUserName: _replyingTo,
        parent: PeamanCommentParent.comment,
        parentId: comment.parent == PeamanCommentParent.feed
            ? comment.id
            : comment.parentId,
        comment: _commentText,
        createdAt: _millis,
      );
      _commentController.clear();
      updateReplyingTo(null);
      updateCommentToReply(null);

      if (_commentToEdit != null) {
        await PFeedProvider.updateComment(
          feedId: feed.id!,
          commentId: _commentToEdit!.id!,
          data: {
            'comment': _commentText,
          },
        );
      } else {
        // update maat warrior points
        final _maatWarriorConfig = context.read<MaatWarriorConfig>();
        if (_maatWarriorConfig.commentPostPoints > 0) {
          MaatWarriorProvider.updateMaatWarriorPoints(
            uid: appUser.uid!,
            points: _maatWarriorConfig.commentPostPoints,
          );
        }
        //

        await PFeedProvider.addComment(
          comment: _reply,
          onSuccess: (reply) {
            updateComments(++_comments);

            PUserProvider.updateUserPropertiesCount(
              uid: comment.ownerId!,
              repliesReceived: 1,
            );

            final _article = feed.type == PeamanFeedType.other
                ? FeedExtraData.fromJson(feed.extraData).article
                : null;
            final _caption = feed.type == PeamanFeedType.other
                ? _article!.title
                : feed.caption;
            ArchivedComment(
              feedId: feed.id,
              caption: _caption,
              commentId: comment.parent == PeamanCommentParent.feed
                  ? comment.id
                  : comment.parentId,
              replyId: reply.id,
              comment: comment.comment,
              reply: _reply.comment,
              createdAt: DateTime.now().millisecondsSinceEpoch,
            )..saveArchiveComment(uid: appUser.uid!);
          },
        );
      }
      updateCommentToEdit(null);
    }
  }

  // enable notification for feed
  void enableNotificationForFeed(
    final PeamanUser appUser,
    final PeamanFeed feed,
  ) {
    PFeedProvider.followFeed(
      uid: appUser.uid!,
      feedId: feed.id!,
    );
  }

  // disable notification for feed
  void disableNotificationForFeed(
    final PeamanUser appUser,
    final PeamanFeed feed,
  ) {
    PFeedProvider.unFollowFeed(
      uid: appUser.uid!,
      feedId: feed.id!,
    );
  }

  // update value of replyingTo
  void updateReplyingTo(final String? newVal) {
    _replyingTo = newVal;
    notifyListeners();
  }

  // update value of commentToReply
  void updateCommentToReply(final PeamanComment? newVal) {
    _commentToReply = newVal;
    notifyListeners();
  }

  // update value of commentToEdit
  void updateCommentToEdit(final PeamanComment? newVal) {
    _commentToEdit = newVal;
    notifyListeners();
  }

  // update value of getNotification
  void updateGetNotification(final bool newVal) {
    _getNotification = newVal;
    notifyListeners();
  }

  // update controller text
  void updateCommentControllerText(final String newVal) {
    _commentController.text = newVal;
    notifyListeners();
  }

  // update value of comments
  void updateComments(final int newVal) {
    _comments = newVal;
    notifyListeners();
  }
}
