import 'package:imhotep/models/custom_notification_model.dart';
import 'package:peaman/peaman.dart';

class CustomNotificationProvider {
  static final _ref = Peaman.ref;

  // send notification
  static Future<void> sendNotification({
    required final CustomNotification customNotification,
    final Function(CustomNotification)? onSuccess,
    final Function(dynamic)? onError,
  }) async {
    try {
      final _customNotificationRef =
          _ref.collection('custom_notifications').doc();
      final _customNotification = customNotification.copyWith(
        id: _customNotificationRef.id,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      await _customNotificationRef.set(_customNotification.toJson());
      print('Success: Sending notification');
      onSuccess?.call(_customNotification);
    } catch (e) {
      print(e);
      print('Error!!!: Sending notification');
      onError?.call(e);
    }
  }

  // list of custom notification from firestore
  static List<CustomNotification> _customNotificationsFromFirestore(
    dynamic querySnap,
  ) {
    return List<CustomNotification>.from(querySnap.docs
        .map((e) => CustomNotification.fromJson(e.data() ?? {}))
        .toList());
  }

  // stream of list of custom notification
  static Stream<List<CustomNotification>> get customNotifications {
    return _ref
        .collection('custom_notifications')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(_customNotificationsFromFirestore);
  }
}
