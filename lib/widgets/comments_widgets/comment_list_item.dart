import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/helpers/common_helper.dart';
import 'package:imhotep/viewmodels/comment_item_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/comments_widgets/comments_list.dart';
import 'package:imhotep/widgets/common_widgets/avatar_builder.dart';
import 'package:imhotep/widgets/common_widgets/maat_warrior_badge.dart';
import 'package:imhotep/widgets/common_widgets/user_fetcher.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import 'package:timeago/timeago.dart' as time_ago;
import '../../enums/subscription_type.dart';
import '../../helpers/dialog_provider.dart';
import '../../screens/friend_profile_screen.dart';
import '../common_widgets/admin_badge.dart';
import '../common_widgets/edit_delete_selector.dart';
import '../common_widgets/verified_user_badge.dart';

class CommentListItem extends StatefulWidget {
  final PeamanFeed feed;
  final PeamanComment comment;
  final Function(PeamanUser, PeamanComment)? onPressedReply;
  final Function(PeamanComment)? onPressedEdit;
  final bool repliesInitiallyShowing;
  CommentListItem({
    Key? key,
    required this.feed,
    required this.comment,
    this.onPressedReply,
    this.onPressedEdit,
    this.repliesInitiallyShowing = false,
  }) : super(key: key);

  @override
  State<CommentListItem> createState() => _CommentListItemState();
}

class _CommentListItemState extends State<CommentListItem> {
  Future<PeamanUser>? _userFuture;
  Stream<List<PeamanComment>>? _commentsStream;

  @override
  void initState() {
    super.initState();
    _userFuture = widget.comment.ownerId == null
        ? null
        : PUserProvider.getUserById(uid: widget.comment.ownerId!).first;
    _commentsStream = widget.comment.parentId == null
        ? null
        : PFeedProvider.getComments(
            feedId: widget.comment.parentId!,
            parent: PeamanCommentParent.comment,
            parentId: widget.comment.id!,
          );
  }

  @override
  void didUpdateWidget(covariant CommentListItem oldWidget) {
    setState(() {
      _userFuture = widget.comment.ownerId == null
          ? null
          : PUserProvider.getUserById(uid: widget.comment.ownerId!).first;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.comment.id == null) return Container();

    return UserFetcher.singleFuture(
      userFuture: _userFuture,
      singleBuilder: (user) {
        final _appUser = context.watch<PeamanUser>();
        return VMProvider<CommentItemVm>(
          vm: CommentItemVm(),
          onInit: (vm) => vm.onInit(widget.comment, _appUser),
          builder: (context, vm, appVm, appUser) {
            if (vm.stateType == StateType.busy) return Container();

            return Container(
              padding: EdgeInsets.only(
                left: widget.comment.parent == PeamanCommentParent.feed
                    ? 10.0
                    : 40.0,
                right: 10.0,
                top: 15.0,
                bottom: 15.0,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onLongPress: () {
                      if (appUser!.uid == widget.comment.ownerId)
                        DialogProvider(context).showBottomSheet(
                          widget: EditDeleteSelector(
                            onEdit: () =>
                                widget.onPressedEdit?.call(widget.comment),
                            onDelete: () async {
                              await PFeedProvider.removeComment(
                                feedId: widget.feed.id!,
                                commentId: widget.comment.id!,
                                parentId: widget.comment.parentId!,
                              );
                            },
                          ),
                        );
                    },
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AvatarBuilder.image(
                            '${user.photoUrl}',
                            size: widget.comment.parent ==
                                    PeamanCommentParent.feed
                                ? 60.0
                                : 40.0,
                            onPressed: () {
                              if (user.admin) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FriendProfileScreen(
                                    friend: user,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonHelper.isMaatWarrior(context, user: user)
                                    ? MaatWarriorBadge()
                                    : user.admin
                                        ? AdminBadge()
                                        : Container(),
                                SizedBox(
                                  height: 05,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            if (user.admin) return;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    FriendProfileScreen(
                                                  friend: user,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            '${user.name}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: widget.comment.parent ==
                                                      PeamanCommentParent.feed
                                                  ? 16.0
                                                  : 15.0,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        if (CommonHelper.subscriptionType(
                                              context,
                                              user: user,
                                            ) ==
                                            SubscriptionType.level3)
                                          VerifiedUserBadge(),
                                      ],
                                    ),
                                    Text(
                                      time_ago.format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          widget.comment.createdAt!,
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87.withOpacity(1),
                                      fontWeight: FontWeight.w500,
                                      fontFamily:
                                          GoogleFonts.nunito().fontFamily,
                                    ),
                                    children: [
                                      if (widget.comment.secondUserName != null)
                                        TextSpan(
                                          text:
                                              '${widget.comment.secondUserName} ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      TextSpan(
                                        text: '${widget.comment.comment}',
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () => widget.onPressedReply
                                          ?.call(user, widget.comment),
                                      child: Text(
                                        'Reply',
                                        style: TextStyle(
                                          color: blackColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        if (vm.liked) {
                                          vm.unlikeComment(widget.comment);
                                        } else {
                                          vm.likeComment(
                                            _appUser,
                                            widget.feed,
                                            widget.comment,
                                          );
                                        }
                                      },
                                      child: Text(
                                        vm.liked ? 'Unlike' : 'Like',
                                        style: TextStyle(
                                          color: blackColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 08,
                                          backgroundColor: vm.liked
                                              ? blueColor
                                              : greyColorshade400,
                                          child: Icon(
                                            Icons.thumb_up,
                                            color: whiteColor,
                                            size: 10,
                                          ),
                                        ),
                                        Text(' ${vm.likes}'),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (widget.comment.repliesCount > 0)
                    Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        title: Text(
                          'View ${widget.comment.repliesCount} ${widget.comment.repliesCount > 1 ? 'replies' : 'reply'}',
                          style: TextStyle(color: blueColor),
                          textAlign: TextAlign.center,
                        ),
                        initiallyExpanded: widget.repliesInitiallyShowing,
                        children: [
                          StreamBuilder<List<PeamanComment>>(
                            stream: _commentsStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final _replies = snapshot.data ?? [];
                                return CommentsList(
                                  feed: widget.feed,
                                  comments: _replies,
                                  onPressedReply: widget.onPressedReply,
                                  onPressedEdit: widget.onPressedEdit,
                                );
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
