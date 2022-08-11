class CustomNotification {
  final String? id;
  final String title;
  final String body;
  final int? createdAt;

  CustomNotification({
    this.id,
    required this.title,
    required this.body,
    this.createdAt,
  });

  CustomNotification copyWith({
    final String? id,
    final String? title,
    final String? body,
    final int? createdAt,
  }) {
    return CustomNotification(
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static CustomNotification fromJson(final Map<String, dynamic> data) {
    return CustomNotification(
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      createdAt: data['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'created_at': createdAt,
    };
  }
}
