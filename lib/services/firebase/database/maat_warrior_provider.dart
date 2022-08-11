import 'package:imhotep/models/maat_warrior_config_model.dart';
import 'package:peaman/peaman.dart';

class MaatWarriorProvider {
  static final _ref = Peaman.ref;

  // update maat warrior points
  static Future<void> updateMaatWarriorPoints({
    required final String uid,
    required final double points,
  }) async {
    try {
      if (points == 0) throw Future.error('Invalid point [$points]');

      final _userUpdateFuture1 = PUserProvider.updateUserData(
        uid: uid,
        data: {
          'maat_warrior_points':
              PeamanDatabaseHelper.fieldValueIncrement(points),
        },
      );
      final _userUpdateFuture2 = PUserProvider.updateUserData(
        uid: uid,
        data: {
          'maat_warrior_points_updated_at':
              DateTime.now().millisecondsSinceEpoch,
        },
      );

      await Future.wait([
        _userUpdateFuture1,
        _userUpdateFuture2,
      ]);

      print('Success: Updating maat warrior points of user');
    } catch (e) {
      print(e);
      print('Error!!!: Updating maat warrior points of user');
    }
  }

  // maat warrior config from firestore
  static MaatWarriorConfig _warriorConfigFromFirestore(dynamic snap) {
    return MaatWarriorConfig.fromJson(snap.data() ?? {});
  }

  // stream of maat warrior config
  static Stream<MaatWarriorConfig> get getMaatWarriorConfig {
    return _ref
        .collection('configs')
        .doc('maat_warrior_config')
        .snapshots()
        .map(_warriorConfigFromFirestore);
  }
}
