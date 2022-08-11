import 'package:flutter/material.dart';
import 'package:imhotep/widgets/comments_widgets/comment_list_item.dart';
import 'package:peaman/peaman.dart';

import '../constants.dart';

class ViewSingleCommentScreen extends StatefulWidget {
  final String feedId;
  final String commentId;
  const ViewSingleCommentScreen({
    Key? key,
    required this.feedId,
    required this.commentId,
  }) : super(key: key);

  @override
  State<ViewSingleCommentScreen> createState() =>
      _ViewSingleCommentScreenState();
}

class _ViewSingleCommentScreenState extends State<ViewSingleCommentScreen> {
  Stream<PeamanComment>? _commentStream;

  @override
  void initState() {
    super.initState();
    _commentStream = PFeedProvider.getSingleCommentById(
      feedId: widget.feedId,
      commentId: widget.commentId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: whiteColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          color: blackColor,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Comments',
          style: TextStyle(
            color: blackColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<PeamanComment>(
          stream: _commentStream,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snap.hasData) {
              final _comment = snap.data!;
              // we only need feed id in CommentListItem
              final _feed = PeamanFeed().copyWith(id: widget.feedId);
              //

              if (_comment.id == null)
                return Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50.0,
                      ),
                      Text(
                        'Comments not found!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        'The comments that you are looking\nfor may have been deleted',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );

              return CommentListItem(
                feed: _feed,
                comment: _comment,
                repliesInitiallyShowing: true,
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
