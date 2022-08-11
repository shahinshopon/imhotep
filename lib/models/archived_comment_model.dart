import 'package:peaman/peaman.dart';

class ArchivedComment {
  final String? id;
  final String? feedId;
  final String? commentId;
  final String? replyId;
  final String? caption;
  final String? comment;
  final String? reply;
  final int? createdAt;

  ArchivedComment({
    this.id,
    this.feedId,
    this.commentId,
    this.replyId,
    this.caption,
    this.comment,
    this.reply,
    this.createdAt,
  });

  static ArchivedComment fromJson(final Map<String, dynamic> data) {
    return ArchivedComment(
      id: data['id'],
      feedId: data['feed_id'],
      commentId: data['comment_id'],
      replyId: data['reply_id'],
      caption: data['caption'],
      comment: data['comment'],
      reply: data['reply'],
      createdAt: data['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'feed_id': feedId,
      'comment_id': commentId,
      'reply_id': replyId,
      'caption': caption,
      'comment': comment,
      'reply': reply,
      'created_at': createdAt,
    };
  }

  void saveArchiveComment({required final String uid}) async {
    final _userRef = Peaman.ref.collection('users').doc(uid);
    final _archiveCommentsRef = _userRef.collection('archived_comments').doc();
    final _data = {...toJson(), 'id': _archiveCommentsRef.id};
    await _archiveCommentsRef.set(_data);
  }

  static Stream<List<ArchivedComment>> getArchivedComments({
    required final String uid,
  }) {
    return Peaman.ref
        .collection('users')
        .doc(uid)
        .collection('archived_comments')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => ArchivedComment.fromJson(e.data()),
            )
            .toList());
  }
}
