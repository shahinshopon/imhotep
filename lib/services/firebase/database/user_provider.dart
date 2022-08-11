import 'package:imhotep/models/admin_model.dart';
import 'package:peaman/peaman.dart';

class UserProvider {
  static final _ref = Peaman.ref;

  // admin from firestore
  static Admin? _adminFromFirestore(dynamic snap) {
    return snap.docs.isEmpty
        ? null
        : Admin.fromJson(snap.docs.first.data() ?? {});
  }

  // stream of admin
  static Stream<Admin?> get admin {
    return _ref
        .collection('users')
        .where('admin', isEqualTo: true)
        .limit(1)
        .snapshots()
        .map(_adminFromFirestore);
  }
}
