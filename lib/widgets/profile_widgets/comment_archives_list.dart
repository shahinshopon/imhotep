import 'package:flutter/material.dart';
import '../../models/archived_comment_model.dart';
import 'comment_archive_list_item.dart';

class CommentArchivesList extends StatelessWidget {
  final List<ArchivedComment> comments;
  const CommentArchivesList({
    Key? key,
    required this.comments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: comments.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final _comment = comments[index];

        final _widget = CommentArchiveListItem(
          comment: _comment,
        );

        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
            ),
            child: _widget,
          );
        }

        if (index == comments.length - 1) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 20.0,
            ),
            child: _widget,
          );
        }

        return _widget;
      },
      separatorBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Divider(),
        );
      },
    );
  }
}
