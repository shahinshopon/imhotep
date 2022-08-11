import 'package:peaman/peaman.dart';

class LikedFeed {
  final String? id;
  final String? feedId;
  final int? createdAt;

  LikedFeed({
    this.id,
    this.feedId,
    this.createdAt,
  });

  static LikedFeed fromJson(final Map<String, dynamic> data) {
    return LikedFeed(
      id: data['id'],
      feedId: data['feed_id'],
      createdAt: data['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'feed_id': feedId,
      'created_at': createdAt,
    };
  }

  void saveLikedFeed({required final String uid}) async {
    final _userRef = Peaman.ref.collection('users').doc(uid);
    final _archiveCommentsRef = _userRef.collection('liked_feeds').doc();
    final _data = {...toJson(), 'id': _archiveCommentsRef.id};
    await _archiveCommentsRef.set(_data);
  }

  static Stream<List<LikedFeed>> getLikedFeeds({
    required final String uid,
  }) {
    return Peaman.ref
        .collection('users')
        .doc(uid)
        .collection('liked_feeds')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => LikedFeed.fromJson(e.data()),
            )
            .toList());
  }
}
