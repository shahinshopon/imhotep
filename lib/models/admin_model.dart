import 'package:peaman/peaman.dart';

class Admin {
  final PeamanUser user;
  Admin({
    required this.user,
  });

  static Admin fromJson(final Map<String, dynamic> data) {
    return Admin(
      user: PeamanUser.fromJson(data),
    );
  }
}
