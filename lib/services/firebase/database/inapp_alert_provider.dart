import 'package:imhotep/models/inapp_alert_model.dart';
import 'package:peaman/peaman.dart';

class InAppAlertProvider {
  static final _ref = Peaman.ref;

  // create alert
  static Future<void> createAlert({
    required final InAppAlert alert,
    final Function(InAppAlert)? onSuccess,
    final Function(dynamic)? onError,
  }) async {
    try {
      final _alertRef = _ref.collection('in_app_alerts').doc(
            'imhotep_in_app_alert',
          );
      final _alert = alert.copyWith(
        id: _alertRef.id,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      await _alertRef.set(_alert.toJson());
      print('Success: Creating alert');
      onSuccess?.call(_alert);
    } catch (e) {
      print(e);
      print('Error!!!: Creating alert');
      onError?.call(e);
    }
  }

  // update alert
  static Future<void> updateAlert({
    required final String alertId,
    required final Map<String, dynamic> data,
    final Function()? onSuccess,
    final Function(dynamic)? onError,
  }) async {
    try {
      final _alertRef = _ref.collection('in_app_alerts').doc(alertId);

      await _alertRef.update(data);
      print('Success: Updating alert');
      onSuccess?.call();
    } catch (e) {
      print(e);
      print('Error!!!: Updating alert');
      onError?.call(e);
    }
  }

  // deactivate alert
  static Future<void> deactivateAlert({
    required final String alertId,
    final Function()? onSuccess,
    final Function(dynamic)? onError,
  }) async {
    try {
      final _alertRef = _ref.collection('in_app_alerts').doc(alertId);

      await _alertRef.update({
        'deactivated': true,
      });
      print('Success: Deactivating alert');
    } catch (e) {
      print(e);
      print('Error!!!: Deactivating alert');
    }
  }

  // activate alert
  static Future<void> activateAlert({
    required final String alertId,
    final Function()? onSuccess,
    final Function(dynamic)? onError,
  }) async {
    try {
      final _alertRef = _ref.collection('in_app_alerts').doc(alertId);

      await _alertRef.update({
        'deactivated': false,
      });
      print('Success: Activating alert');
    } catch (e) {
      print(e);
      print('Error!!!: Activating alert');
    }
  }

  // delete alert
  static Future<void> deleteAlert({
    required final String alertId,
    final Function()? onSuccess,
    final Function(dynamic)? onError,
  }) async {
    try {
      final _alertRef = _ref.collection('in_app_alerts').doc(alertId);

      await _alertRef.delete();
      print('Success: Deleting alert');
    } catch (e) {
      print(e);
      print('Error!!!: Deleting alert');
    }
  }

  // alert from firestore
  static InAppAlert? _alertFromFirestore(final dynamic snap) {
    return snap.exists ? InAppAlert.fromJson(snap.data() ?? {}) : null;
  }

  // stream of in app alert
  static Stream<InAppAlert?> get inAppAlert {
    return _ref
        .collection('in_app_alerts')
        .doc('imhotep_in_app_alert')
        .snapshots()
        .map(_alertFromFirestore);
  }
}
