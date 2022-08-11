import 'package:flutter/material.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/screens/friend_profile_screen.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/common_widgets/hotep_searchbar.dart';
import 'package:imhotep/widgets/common_widgets/user_fetcher.dart';
import 'package:imhotep/widgets/common_widgets/users_list.dart';
import 'package:peaman/peaman.dart';

import '../viewmodels/user_search_vm.dart';

class UserSearchScreen extends StatelessWidget {
  const UserSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VMProvider<UserSearchVm>(
      vm: UserSearchVm(context),
      onDispose: (vm) => vm.onDispose(),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                HotepSearchBar(
                  controller: vm.searchController,
                  autoFocus: true,
                  trailing: _cancelSearchBuilder(context, vm),
                  onChanged: (_) => vm.createDebounce(),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: !vm.searchActive
                      ? vm.stateType == StateType.busy
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container()
                      : SingleChildScrollView(
                          child: UserFetcher.multiStream(
                            usersStream: PUserProvider.getUsersBySearchKeyword(
                              searchKeyword:
                                  vm.searchController.text.trim().toUpperCase(),
                            ),
                            multiBuilder: (users) {
                              final _users = users
                                  .where(
                                    (e) => e.uid != appUser?.uid,
                                  )
                                  .toList();
                              return UsersList.expanded(
                                users: _users,
                                onPressedUser: (user) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FriendProfileScreen(
                                        friend: user,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _cancelSearchBuilder(
      final BuildContext context, final UserSearchVm vm) {
    return GestureDetector(
      onTap: () {
        if (vm.searchController.text.trim() == '') {
          Navigator.pop(context);
        } else {
          vm.searchController.clear();
          FocusScope.of(context).requestFocus();
          // vm.updateShowingResults(false);
          // vm.updateShowingSuggestions(false);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Color(0xffD6D5D5),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        child: Row(
          children: [
            Icon(
              Icons.close,
              size: 18.0,
              color: Color(0xff888888),
            ),
            SizedBox(
              width: 2.0,
            ),
            Text(
              'Cancel',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: Color(0xff888888),
              ),
            )
          ],
        ),
      ),
    );
  }
}
