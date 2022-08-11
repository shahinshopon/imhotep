import 'package:flutter/material.dart';
import 'package:imhotep/models/archived_comment_model.dart';
import 'package:imhotep/widgets/profile_widgets/comment_archives_list.dart';
import 'package:imhotep/widgets/profile_widgets/profile_empty_builder.dart';

class CommentArchiveTab extends StatelessWidget {
  final List<ArchivedComment>? comments;
  const CommentArchiveTab({
    Key? key,
    required this.comments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (comments == null) {
      return Center(child: CircularProgressIndicator());
    }
    if (comments!.isEmpty) {
      return ProfileEmptyBuilder(
        imgUrl: 'assets/Groupchat.png',
        description:
            'This is your comment archive.\n Once you start to comment\n You can track your discussions here.',
      );
    }
    return CommentArchivesList(
      comments: comments!,
    );
  }
}
