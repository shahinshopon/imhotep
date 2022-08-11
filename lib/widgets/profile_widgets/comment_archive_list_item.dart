import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imhotep/helpers/common_helper.dart';
import 'package:imhotep/models/archived_comment_model.dart';

import '../../screens/view_single_comment_screen.dart';

class CommentArchiveListItem extends StatelessWidget {
  final ArchivedComment comment;
  const CommentArchiveListItem({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ViewSingleCommentScreen(
              feedId: comment.feedId!,
              commentId: comment.commentId!,
            ),
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset('assets/svgs/reply.svg'),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Text(
                    CommonHelper.limitedText(
                      comment.reply == null ? comment.comment : comment.reply,
                      limit: 40,
                    ),
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      CommonHelper.limitedText(
                        comment.caption,
                        limit: 70,
                      ),
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
