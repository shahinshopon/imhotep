import 'package:flutter/material.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/viewmodels/comments_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/comments_widgets/comment_input.dart';
import 'package:imhotep/widgets/comments_widgets/comments_list.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class CommentsScreen extends StatefulWidget {
  final PeamanFeed feed;
  CommentsScreen({
    Key? key,
    required this.feed,
  }) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  var _focusNode = FocusNode();

  Stream<List<PeamanComment>>? _commentsFuture;

  @override
  void initState() {
    super.initState();
    _commentsFuture = PFeedProvider.getComments(
      feedId: widget.feed.id!,
      parent: PeamanCommentParent.feed,
      parentId: widget.feed.id!,
    );
  }

  void _requestFocus() {
    final _newFocusNode = FocusNode();
    _focusNode = _newFocusNode;
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final _appUser = context.watch<PeamanUser>();
    return VMProvider<CommentsVm>(
      vm: CommentsVm(context),
      onInit: (vm) => vm.onInit(
        appUser: _appUser,
        feed: widget.feed,
      ),
      builder: (context, vm, appVm, appUser) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, vm.comments);
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: whiteColor,
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
            body: vm.stateType == StateType.busy
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : StreamBuilder<List<PeamanComment>>(
                    stream: _commentsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final _comments = snapshot.data ?? [];
                        return GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            color: whiteColor,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Divider(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context, vm.comments);
                                          },
                                          behavior: HitTestBehavior.opaque,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.arrow_back,
                                              ),
                                              Text(
                                                '  Go back',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: blackColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Get Notifications',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: blackColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Switch(
                                              value: vm.getNotification,
                                              onChanged: (val) {
                                                vm.updateGetNotification(val);
                                                if (val) {
                                                  vm.enableNotificationForFeed(
                                                    appUser!,
                                                    widget.feed,
                                                  );
                                                } else {
                                                  vm.disableNotificationForFeed(
                                                    appUser!,
                                                    widget.feed,
                                                  );
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  CommentsList(
                                    feed: widget.feed,
                                    comments: _comments,
                                    onPressedReply: (user, comment) {
                                      vm.updateReplyingTo(user.name);
                                      vm.updateCommentToReply(comment);
                                      _requestFocus();
                                    },
                                    onPressedEdit: (comment) {
                                      if (comment.secondUserName != null)
                                        vm.updateReplyingTo(
                                          comment.secondUserName,
                                        );
                                      vm.updateCommentToEdit(comment);
                                      vm.updateCommentControllerText(
                                        comment.comment!,
                                      );
                                      _requestFocus();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
            bottomNavigationBar: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
                child: CommentInput(
                  controller: vm.commentController,
                  focusNode: _focusNode,
                  replyingTo: vm.replyingTo,
                  editing: vm.commentToEdit != null,
                  onPressedSend: () {
                    if (vm.replyingTo != null && vm.commentToReply != null) {
                      vm.replyToComment(
                        appUser!,
                        widget.feed,
                        vm.commentToReply!,
                      );
                    } else {
                      vm.commentToFeed(
                        appUser!,
                        widget.feed,
                      );
                    }
                  },
                  onPressedCancelReply: () {
                    vm.updateReplyingTo(null);
                    vm.updateCommentToReply(null);
                    vm.updateCommentToEdit(null);
                    vm.updateCommentControllerText('');
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
