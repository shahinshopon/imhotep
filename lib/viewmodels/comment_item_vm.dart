import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:peaman/peaman.dart';

class CommentItemVm extends BaseVm {
  int _likes = 0;
  bool _liked = false;
  String? _myReactionId;

  int get likes => _likes;
  bool get liked => _liked;
  String? get myReactionId => _myReactionId;

  // init function
  void onInit(
    final PeamanComment comment,
    final PeamanUser appUser,
  ) async {
    updateStateType(StateType.busy);
    final _reaction = await PFeedProvider.getReactionByOwnerId(
      feedId: comment.feedId!,
      ownerId: appUser.uid!,
      parent: PeamanReactionParent.comment,
      parentId: comment.id!,
    );

    _liked = _reaction != null && !_reaction.unreacted;
    _likes = comment.reactionsCount;
    _myReactionId = _reaction?.id;
    updateStateType(StateType.idle);
  }

  // like comment
  void likeComment(
    final PeamanUser appUser,
    final PeamanFeed feed,
    final PeamanComment comment,
  ) {
    _updateLiked(true);
    final _reaction = PeamanReaction(
      id: _myReactionId,
      feedId: feed.id,
      ownerId: appUser.uid,
      parent: PeamanReactionParent.comment,
      parentId: comment.id,
    );
    PFeedProvider.addReaction(
      reaction: _reaction,
      onSuccess: (reaction) {
        _updateMyReactionId(reaction.id);

        if (comment.parent == PeamanCommentParent.comment) {
          PUserProvider.updateUserPropertiesCount(
            uid: comment.ownerId!,
            likeableReplies: 1,
          );
        } else {
          PUserProvider.updateUserPropertiesCount(
            uid: comment.ownerId!,
            likeableComments: 1,
          );
        }
      },
    );
  }

  // unlike comment
  void unlikeComment(final PeamanComment comment) {
    if (_myReactionId != null) {
      _updateLiked(false);
      PFeedProvider.removeReaction(
        feedId: comment.feedId!,
        parentId: comment.id!,
        reactionId: _myReactionId!,
        onSuccess: (_) {
          PUserProvider.updateUserPropertiesCount(
            uid: comment.ownerId!,
            likeableComments: -1,
          );
        },
      );
    }
  }

  // update value of liked
  void _updateLiked(final bool newVal) {
    _liked = newVal;
    if (newVal)
      _likes++;
    else if (_likes != 0) _likes--;

    notifyListeners();
  }

  // update value of myReactionId
  void _updateMyReactionId(final String? newVal) {
    _myReactionId = newVal;
    notifyListeners();
  }
}
