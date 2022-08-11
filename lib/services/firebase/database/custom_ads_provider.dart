import 'package:imhotep/models/custom_ad_model.dart';
import 'package:peaman/peaman.dart';

class CustomAdsProvider {
  static final _ref = Peaman.ref;

  // create custom ads
  static Future<void> createCustomAd({
    required final CustomAd customAd,
  }) async {
    try {
      final _customAdRef = _ref.collection('custom_ads').doc(customAd.id);
      final _customAds = customAd.copyWith(
        id: _customAdRef.id,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      await _customAdRef.set(_customAds.toJson());
      print('Success: Creating custom ad');
    } catch (e) {
      print(e);
      print('Error!!!: Creating custom ad');
    }
  }

  // update custom ads
  static Future<void> updateCustomAd({
    required final String customAdId,
    required final Map<String, dynamic> data,
  }) async {
    try {
      final _customAdRef = _ref.collection('custom_ads').doc(customAdId);

      await _customAdRef.set(data);
      print('Success: Updating custom ad');
    } catch (e) {
      print(e);
      print('Error!!!: Updating custom ad');
    }
  }

  // delete custom ads
  static Future<void> deleteCustomAd({
    required final String customAdId,
  }) async {
    try {
      final _customAdRef = _ref.collection('custom_ads').doc(customAdId);

      await _customAdRef.delete();
      print('Success: Deleting custom ad');
    } catch (e) {
      print(e);
      print('Error!!!: Deleting custom ad');
    }
  }

  // custom ads list from firestore
  static List<CustomAd> _customAdsFromFirestore(dynamic querySnap) {
    return List<CustomAd>.from(
        querySnap.docs.map((e) => CustomAd.fromJson(e.data() ?? {})).toList());
  }

  // stream of list of custom ads
  static Stream<List<CustomAd>> get customAds {
    return _ref
        .collection('custom_ads')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(_customAdsFromFirestore);
  }
}
