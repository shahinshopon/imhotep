import 'package:cloud_functions/cloud_functions.dart';

class ArticleProvider {
  static final _functions = FirebaseFunctions.instance;

  // update articles on posts collection
  static Future<void> updateArticles() async {
    try {
      final _callable = _functions.httpsCallable('addArticlesToCollection');
      final _res = await _callable.call();

      print(_res.data);

      print('Success: Updating articles');
    } catch (e) {
      print(e);
      print('Error!!!: Updating articles');
    }
  }
}
