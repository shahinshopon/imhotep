class ShopifyProduct {
  final String? id;
  final String name;
  final String content;
  final String displayPhoto;
  final double price;
  final List<String> photos;
  final String website;
  final List<String> searchKeys;

  ShopifyProduct({
    this.id,
    this.name = '',
    this.content = '<div></div>',
    this.displayPhoto = '',
    this.price = 0.0,
    this.photos = const [],
    this.searchKeys = const [],
    this.website = 'https://www.montustore.com/',
  });

  static ShopifyProduct fromJson(final Map<String, dynamic> data) {
    final List<dynamic> _varients = data['variants'] ?? [];
    final _price =
        _varients.isNotEmpty ? _varients.first['price'] ?? '0.0' : '0.0';
    return ShopifyProduct(
      id: '${data['id']}',
      name: data['title'] ?? '',
      displayPhoto: (data['image'] ?? {})['src'] ?? '',
      content: data['body_html'] ?? '<div></div>',
      price: double.parse(_price),
      photos: List<String>.from(
        (data['images'] ?? []).map((e) => e['src']).toList(),
      ),
      website: data['handle'] == null
          ? 'https://www.montustore.com/'
          : 'https://www.montustore.com/products/${data['handle']}/',
      searchKeys: _getSearchKeys(
        data['title'] ?? '',
      ),
    );
  }

  // get search keys from name and description
  static List<String> _getSearchKeys(
    final String name,
  ) {
    var _searchKeys = <String>[];
    final _names = name.split(' ');

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

    return _searchKeys
        .where((element) =>
            element.trim() != '' &&
            element.trim() != ',' &&
            element.trim() != '.')
        .toList();
  }
}
