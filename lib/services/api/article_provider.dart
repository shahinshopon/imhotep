import 'package:dio/dio.dart';
import 'package:imhotep/models/article_model.dart';

const _articlesApi = 'https://mrimhotep.org/wp-json/api/v1/posts';

class ArticleProvider {
  // fetch articles
  static Future<List<Article>> getArticles() async {
    final _articles = <Article>[];
    try {
      final _dio = Dio();
      final _res = await _dio.get(_articlesApi);
      final _data = List<Map<String, dynamic>>.from(_res.data ?? []);

      _data.forEach((e) {
        final _article = Article.fromJson(e);
        _articles.add(_article);
      });
    } catch (e) {
      print(e);
      print('Error!!!: Getting articles');
    }
    return _articles;
  }
}
