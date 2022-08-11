import 'package:flutter/material.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

class BlockedUsersVm extends BaseVm {
  final BuildContext context;
  BlockedUsersVm(this.context);

  List<PeamanBlockedUser> get blockedUsers =>
      context.watch<List<PeamanBlockedUser>>();

  // unblock user
  void unblockUser(
    final PeamanUser appUser,
    final PeamanBlockedUser friend,
  ) {
    PUserProvider.unblockUser(
      uid: appUser.uid!,
      friendId: friend.uid!,
    );
  }
}
