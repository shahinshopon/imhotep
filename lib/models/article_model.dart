class Article {
  final String? id;
  final String title;
  final String content;
  final List<String> photos;
  final String website;
  final int createdAt;

  Article({
    this.id,
    this.title = '',
    this.content = '<div></div>',
    this.website = 'https://mrimhotep.org/',
    this.photos = const [],
    this.createdAt = -1,
  });

  static Article fromJson(final Map<String, dynamic> data) {
    return Article(
      id: '${data['id']}',
      title: data['title'] ?? '',
      content: (data['content'] ?? '<div></div>')
          .replaceAll('[dropcap]', '')
          .replaceAll('[/dropcap]', ''),
      photos: (data['featured_image'] ?? {})['large'] == null
          ? []
          : List<String>.from(
              [(data['featured_image'] ?? {})['large']],
            ),
      website: data['slug'] == null
          ? 'https://mrimhotep.org/'
          : 'https://mrimhotep.org/${data['slug']}/',
      createdAt: data['createDateGMT'] == null
          ? 0
          : DateTime.parse(data['createDateGMT']).millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toJson() {
    final _data = {
      'id': id,
      'title': title,
      'content': content,
      'photos': photos,
      'website': website,
      'created_at': createdAt,
    };

    _data.removeWhere((key, value) => value == null);

    return _data;
  }
}
