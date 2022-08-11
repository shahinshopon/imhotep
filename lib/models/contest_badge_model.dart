import '../enums/contest_badge_type.dart';

class ContestBadge {
  final String ownerId;
  final String contestId;
  final ContestBadgeType type;
  final int createdAt;
  final int expiresAt;

  ContestBadge({
    this.ownerId = '',
    this.contestId = '',
    this.type = ContestBadgeType.none,
    this.createdAt = -1,
    this.expiresAt = -1,
  });

  ContestBadge copyWith({
    final String? ownerId,
    final String? contestId,
    final ContestBadgeType? type,
    final int? createdAt,
    final int? expiresAt,
  }) {
    return ContestBadge(
      ownerId: ownerId ?? this.ownerId,
      contestId: contestId ?? this.contestId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  static ContestBadge fromJson(final Map<String, dynamic> data) {
    return ContestBadge(
      ownerId: data['owner_id'] ?? '',
      contestId: data['contest_id'] ?? '',
      type: ContestBadgeType.values[data['type'] ?? 0],
      createdAt: data['created_at'] ?? -1,
      expiresAt: data['expires_at'] ?? -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'owner_id': ownerId,
      'contest_id': contestId,
      'type': type.index,
      'created_at': createdAt,
      'expires_at': expiresAt,
    };
  }
}
