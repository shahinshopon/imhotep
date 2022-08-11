import 'package:imhotep/models/editor_access_config_mode.dart';
import 'package:peaman/peaman.dart';

class EditorAccessProvider {
  static final _ref = Peaman.ref;

  // editor access config from firestore
  static EditorAccessConfig _editorAccessConfigFromFirestore(dynamic snap) {
    return EditorAccessConfig.fromJson(snap.data() ?? {});
  }

  // stream of editor access config
  static Stream<EditorAccessConfig> get editorAccessConfig {
    return _ref
        .collection('configs')
        .doc('editor_access_config')
        .snapshots()
        .map(_editorAccessConfigFromFirestore);
  }
}
