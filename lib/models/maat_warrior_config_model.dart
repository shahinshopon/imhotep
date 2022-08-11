class MaatWarriorConfig {
  final double visitAppPoints;
  final double likePostPoints;
  final double commentPostPoints;
  final double savePostPoints;
  final double sharePostInsidePoints;
  final double sharePostOutsidePoints;
  final double viewPostPoints;
  final double followUserPoints;
  final double messageUserPoints;
  final double targetPoint;

  MaatWarriorConfig({
    this.visitAppPoints = -1,
    this.likePostPoints = -1,
    this.commentPostPoints = -1,
    this.savePostPoints = -1,
    this.sharePostInsidePoints = -1,
    this.sharePostOutsidePoints = -1,
    this.viewPostPoints = -1,
    this.followUserPoints = -1,
    this.messageUserPoints = -1,
    this.targetPoint = -1,
  });

  static MaatWarriorConfig fromJson(final Map<String, dynamic> data) {
    return MaatWarriorConfig(
      visitAppPoints: (data['visit_app_points'] ?? -1.0).toDouble(),
      likePostPoints: (data['like_post_points'] ?? -1.0).toDouble(),
      commentPostPoints: (data['comment_post_points'] ?? -1.0).toDouble(),
      savePostPoints: (data['save_post_points'] ?? -1.0).toDouble(),
      sharePostInsidePoints:
          (data['share_post_inside_points'] ?? -1.0).toDouble(),
      sharePostOutsidePoints:
          (data['share_post_outside_points'] ?? -1.0).toDouble(),
      viewPostPoints: (data['view_post_points'] ?? -1.0).toDouble(),
      followUserPoints: (data['follow_user_points'] ?? -1.0).toDouble(),
      messageUserPoints: (data['message_user_points'] ?? -1.0).toDouble(),
      targetPoint: (data['target_point'] ?? 999999.0).toDouble(),
    );
  }
}
