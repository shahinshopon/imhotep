import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imhotep/viewmodels/followers_following_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/followers_following_widgets/followers_following_list.dart';
import 'package:peaman/peaman.dart';

import '../constants.dart';

enum _ScreenType {
  followers,
  following,
}

class FollowersFollowingScreen extends StatelessWidget {
  final _ScreenType type;

  const FollowersFollowingScreen.followers({
    Key? key,
  })  : type = _ScreenType.followers,
        super(key: key);

  const FollowersFollowingScreen.following({
    Key? key,
  })  : type = _ScreenType.following,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return VMProvider<FollowersFollowingVm>(
      vm: FollowersFollowingVm(context),
      builder: (context, vm, appVm, appUser) {
        return DefaultTabController(
          length: 2,
          initialIndex: type.index,
          child: Scaffold(
            appBar: _tabBarBuilder(context, appUser!, vm),
            body: _tabViewBuilder(vm, appUser),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _tabBarBuilder(
    final BuildContext context,
    final PeamanUser appUser,
    final FollowersFollowingVm vm,
  ) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        '${appUser.name}',
        style: TextStyle(
          fontSize: Get.height * 0.022,
          color: Colors.black,
        ),
      ),
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      bottom: TabBar(
        indicatorColor: blueColor,
        unselectedLabelColor: Colors.grey,
        labelColor: Colors.black,
        labelStyle: TextStyle(
          fontSize: Get.height * 0.02,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: Get.height * 0.017,
        ),
        tabs: [
          Tab(
            text: vm.followers != null && vm.followers!.isNotEmpty
                ? '${vm.followers!.length} ${vm.followers!.length > 1 ? 'Followers' : 'Follower'}'
                : 'Followers',
          ),
          Tab(
            text: vm.following != null && vm.following!.isNotEmpty
                ? '${vm.following!.length} Following'
                : 'Following',
          ),
        ],
      ),
    );
  }

  Widget _tabViewBuilder(
    final FollowersFollowingVm vm,
    final PeamanUser appUser,
  ) {
    return TabBarView(
      children: [
        FollowersFollowingList.followers(
          followers: vm.followers,
          // following is required here to check whether I have already
          // followed the follower
          following: vm.following,
          //
          onFollow: (friend) => vm.followUser(appUser, friend),
        ),
        FollowersFollowingList.following(
          following: vm.following,
          onUnfollow: (friend) => vm.unfollowUser(appUser, friend),
        ),
      ],
    );
  }
}
