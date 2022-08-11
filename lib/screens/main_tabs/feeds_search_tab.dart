import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/screens/friend_profile_screen.dart';
import 'package:imhotep/viewmodels/app_vm.dart';
import 'package:imhotep/viewmodels/feed_search_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/common_widgets/user_fetcher.dart';
import 'package:imhotep/widgets/common_widgets/users_list.dart';
import 'package:imhotep/widgets/feed_widgets/feeds_list.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

import '../../widgets/common_widgets/feed_fetcher.dart';
import '../../widgets/common_widgets/hotep_searchbar.dart';

class FeedsSearchTab extends StatelessWidget {
  const FeedsSearchTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _appVm = context.watch<AppVm>();

    return VMProvider<FeedSearchVm>(
      vm: FeedSearchVm(),
      onInit: (vm) => vm.onInit(_appVm.allFeeds),
      onDispose: (vm) => vm.onDispose(),
      builder: (context, vm, appVm, appUser) {
        return SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                HotepSearchBar(
                  hintText: 'Type something awesome...',
                  controller: vm.searchController,
                  onChanged: (val) => vm.createDebounce(),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: !vm.searchActive
                      ? vm.stateType == StateType.busy
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : SingleChildScrollView(
                              child: FeedsList.grid(
                                feeds: vm.randomFeeds,
                              ),
                            )
                      : _searchTabsBuilder(context, vm),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _searchTabsBuilder(
    final BuildContext context,
    final FeedSearchVm vm,
  ) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          _tabBarBuilder(),
          Expanded(
            child: _tabViewBuilder(context, vm),
          ),
        ],
      ),
    );
  }

  Widget _tabBarBuilder() {
    return TabBar(
      labelColor: blueColor,
      unselectedLabelColor: greyColor,
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
        fontFamily: GoogleFonts.nunito().fontFamily,
      ),
      tabs: [
        Tab(
          text: 'Posts',
        ),
        Tab(
          text: 'People',
        ),
      ],
    );
  }

  Widget _tabViewBuilder(
    final BuildContext context,
    final FeedSearchVm vm,
  ) {
    return TabBarView(
      children: [
        FeedFetcher.multiStream(
          feedsStream: PFeedProvider.getFeedsBySearchKeyword(
            searchKeyword: vm.searchController.text.trim().toUpperCase(),
          ),
          multiBuilder: (feeds) {
            return FeedsList.grid(
              scroll: true,
              feeds: feeds,
              crossAxisCount: 2,
            );
          },
        ),
        UserFetcher.multiStream(
          usersStream: PUserProvider.getUsersBySearchKeyword(
            searchKeyword: vm.searchController.text.trim().toUpperCase(),
          ),
          multiBuilder: (users) {
            return UsersList.expanded(
              scroll: true,
              users: users,
              onPressedUser: (user) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FriendProfileScreen(friend: user),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
