import 'package:flutter/material.dart';
import 'package:imhotep/viewmodels/blocked_users_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';

import '../constants.dart';
import '../widgets/blocked_users_widgets/blocked_users_list.dart';

class BlockedUsersScreen extends StatelessWidget {
  const BlockedUsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VMProvider<BlockedUsersVm>(
      vm: BlockedUsersVm(context),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          backgroundColor: whiteColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: whiteColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              color: blackColor,
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Blocked Users',
              style: TextStyle(
                color: blackColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: BlockedUsersList(
            blockedUsers: vm.blockedUsers,
            onPressedUnblock: (blockedUser) {
              vm.unblockUser(appUser!, blockedUser);
            },
          ),
        );
      },
    );
  }
}
