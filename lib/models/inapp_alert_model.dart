class InAppAlert {
  final String? id;
  final String imgUrl;
  final String title;
  final String description;
  final bool deactivated;
  final int expiresAt;
  final int createdAt;

  InAppAlert({
    this.id,
    this.imgUrl = '',
    this.title = '',
    this.description = '',
    this.deactivated = false,
    this.expiresAt = -1,
    this.createdAt = -1,
  });

  InAppAlert copyWith({
    final String? id,
    final String? imgUrl,
    final String? title,
    final String? description,
    final bool? deactivated,
    final int? expiresAt,
    final int? createdAt,
  }) {
    return InAppAlert(
      id: id ?? this.id,
      imgUrl: imgUrl ?? this.imgUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      deactivated: deactivated ?? this.deactivated,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static InAppAlert fromJson(final Map<String, dynamic> data) {
    return InAppAlert(
      id: data['id'],
      imgUrl: data['img_url'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      deactivated: data['deactivated'] ?? false,
      expiresAt: data['expires_at'] ?? -1,
      createdAt: data['created_at'] ?? -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'img_url': imgUrl,
      'title': title,
      'description': description,
      'deactivated': deactivated,
      'expires_at': expiresAt,
      'created_at': createdAt,
    };
  }
}
