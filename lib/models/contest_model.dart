class Contest {
  final String? id;
  final String title;
  final String description;
  final int startsAt;
  final int createdAt;

  Contest({
    this.id,
    this.title = '',
    this.description = '',
    this.startsAt = -1,
    this.createdAt = -1,
  });

  Contest copyWith({
    final String? id,
    final String? title,
    final String? description,
    final int? startsAt,
    final int? createdAt,
  }) {
    return Contest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startsAt: startsAt ?? this.startsAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static Contest fromJson(final Map<String, dynamic> data) {
    return Contest(
      id: data['id'],
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      startsAt: data['starts_at'] ?? -1,
      createdAt: data['starts_at'] ?? -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'starts_at': startsAt,
      'created_at': createdAt,
    };
  }
}
