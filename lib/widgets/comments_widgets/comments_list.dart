import 'package:flutter/material.dart';
import 'package:imhotep/widgets/comments_widgets/comment_list_item.dart';
import 'package:peaman/peaman.dart';

class CommentsList extends StatelessWidget {
  final PeamanFeed feed;
  final List<PeamanComment> comments;
  final Function(PeamanUser, PeamanComment)? onPressedReply;
  final Function(PeamanComment)? onPressedEdit;
  const CommentsList({
    Key? key,
    required this.feed,
    required this.comments,
    this.onPressedReply,
    this.onPressedEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if it is reply then reverse the list
    final _isReply =
        comments.map((e) => e.parent == PeamanCommentParent.comment).isNotEmpty
            ? comments.map((e) => e.parent == PeamanCommentParent.comment).first
            : false;
    //
    return ListView.builder(
      itemCount: comments.length,
      shrinkWrap: true,
      reverse: _isReply,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final _comment = comments[index];
        return CommentListItem(
          feed: feed,
          comment: _comment,
          onPressedReply: onPressedReply,
          onPressedEdit: onPressedEdit,
        );
      },
    );
  }
}
