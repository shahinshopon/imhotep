class Product {
  final String? id;
  final String name;
  final String content;
  final String description;
  final String shortDescription;
  final double price;
  final String displayPhoto;
  final List<String> photos;
  final List<String> searchKeys;
  final List<String> categories;
  final String website;

  Product({
    this.id,
    this.name = '',
    this.content = '<div></div>',
    this.description = '',
    this.shortDescription = '',
    this.price = 0.0,
    this.displayPhoto = '',
    this.photos = const [],
    this.searchKeys = const [],
    this.categories = const [],
    this.website = 'https://mrimhotep.org/',
  });

  static Product fromJson(final Map<String, dynamic> data) {
    final _description =
        (data['description'] ?? data['short_description'] ?? '') as String;
    return Product(
      id: '${data['id']}',
      name: data['name'] ?? '',
      description:
          _description.replaceAll('<br />', '').replaceAll('&nbsp;', ''),
      shortDescription: data['short_description'] ?? '',
      price: double.parse('${data['price'] ?? 0.0}'),
      displayPhoto: data['image_id'],
      photos: List<String>.from(data['gallery_image_ids'] ?? []),
      website: data['slug'] == null
          ? 'https://mrimhotep.org/'
          : 'https://mrimhotep.org/product/${data['slug']}/',
      categories: List<String>.from(data['category_ids'] ?? []),
      searchKeys: _getSearchKeys(
        data['name'] ?? '',
        _description.replaceAll('<br />', ''),
      ),
    );
  }

  // get search keys from name and description
  static List<String> _getSearchKeys(
    final String name,
    final String description,
  ) {
    var _searchKeys = <String>[];
    final _names = name.split(' ');
    final _descriptions = description.split(' ');

    // split letters of name
    for (int i = 0; i < name.length; i++) {
      final _letter = name.substring(0, i + 1);
      if (!_searchKeys.contains(_letter.toUpperCase())) {
        _searchKeys.add(_letter.toUpperCase());
      }
    }

    for (int i = 0; i < _names.length; i++) {
      for (int j = 0; j < _names[i].length; j++) {
        final _letter = _names[i].substring(0, j + 1);
        if (!_searchKeys.contains(_letter.toUpperCase())) {
          _searchKeys.add(_letter.toUpperCase());
        }
      }
    }
    //

    // split letters of description
    for (int i = 0; i < description.length; i++) {
      final _letter = description.substring(0, i + 1);
      if (!_searchKeys.contains(_letter.toUpperCase())) {
        _searchKeys.add(_letter.toUpperCase());
      }
    }

    for (int i = 0; i < _descriptions.length; i++) {
      for (int j = 0; j < _descriptions[i].length; j++) {
        final _letter = _descriptions[i].substring(0, j + 1);
        if (!_searchKeys.contains(_letter.toUpperCase())) {
          _searchKeys.add(_letter.toUpperCase());
        }
      }
    }
    //

    return _searchKeys
        .where((element) =>
            element.trim() != '' &&
            element.trim() != ',' &&
            element.trim() != '.')
        .toList();
  }
}
