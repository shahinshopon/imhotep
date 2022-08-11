class CustomAd {
  final String? id;
  final String photoUrl;
  final String link;
  final double priority;
  final int createdAt;

  CustomAd({
    this.id,
    this.photoUrl = '',
    this.link = '',
    this.priority = 1,
    this.createdAt = -1,
  });

  CustomAd copyWith({
    final String? id,
    final String? photoUrl,
    final String? link,
    final double? priority,
    final int? createdAt,
  }) {
    return CustomAd(
      id: id ?? this.id,
      photoUrl: photoUrl ?? this.photoUrl,
      link: link ?? this.link,
      createdAt: createdAt ?? this.createdAt,
      priority: priority ?? this.priority,
    );
  }

  static CustomAd fromJson(final Map<String, dynamic> data) {
    return CustomAd(
      id: data['id'],
      photoUrl: data['photo_url'],
      link: data['link'] ?? '',
      createdAt: data['created_at'] ?? -1,
      priority: double.parse('${data['priority'] ?? 1}'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'photo_url': photoUrl,
      'link': link,
      'priority': priority,
      'created_at': createdAt,
    };
  }
}
