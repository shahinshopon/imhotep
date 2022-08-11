import 'package:flutter/material.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/helpers/dialog_provider.dart';
import 'package:imhotep/viewmodels/feed_share_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/common_widgets/hotep_searchbar.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../common_widgets/social_share_list.dart';
import '../common_widgets/spinner.dart';
import '../common_widgets/user_fetcher.dart';
import 'feed_share_users_list.dart';

enum _Type {
  noSearch,
  search,
}

class FeedShareBottomSheet extends StatelessWidget {
  final PeamanFeed feed;
  final Function()? onShare;
  final _Type type;

  const FeedShareBottomSheet({
    Key? key,
    required this.feed,
    this.onShare,
  })  : type = _Type.noSearch,
        super(key: key);

  const FeedShareBottomSheet.search({
    Key? key,
    required this.feed,
    this.onShare,
  })  : type = _Type.search,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _appUser = context.watch<PeamanUser>();

    return VMProvider<FeedShareVm>(
      vm: FeedShareVm(context),
      onInit: (vm) {
        if (type != _Type.search) {
          vm.onInit(
            appUser: _appUser,
            feed: feed,
          );
        }
      },
      builder: (context, vm, appVm, appUser) {
        return type == _Type.noSearch
            ? _noSearchBuilder(context, vm, appUser!)
            : _searchBuilder(context, vm, appUser!);
      },
    );
  }

  Widget _noSearchBuilder(
    final BuildContext context,
    final FeedShareVm vm,
    final PeamanUser appUser,
  ) {
    final _followersIds = vm.followers.map((e) => e.uid!).toList();
    final _followingIds = vm.following.map((e) => e.uid!).toList();
    final _chatUserIds = vm.chats.map((e) {
      return (appUser.uid == e.firstUserId ? e.secondUserId : e.firstUserId)!;
    }).toList();

    if (vm.stateType == StateType.busy)
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20.0,
          ),
          Spinner(),
          SizedBox(
            height: 20.0,
          ),
        ],
      );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleBuilder(context),
        FeedShareUsersList.rounded(
          scroll: true,
          scrollDirection: Axis.horizontal,
          requiredSearch: true,
          usersIds: vm.getNonRepeatingUsersList([
            ..._followersIds,
            ..._followingIds,
            ..._chatUserIds,
          ]),
          onPressedSend: (user) {
            vm.sendMessage(feed, user);
            onShare?.call();
          },
          onPressedSearch: () {
            DialogProvider(context).showBottomSheet(
              widget: FeedShareBottomSheet.search(
                feed: feed,
              ),
            );
          },
        ),
        Divider(
          height: 0.0,
        ),
        if (vm.deepLink != null)
          SocialShareList(
            link: vm.deepLink!,
          ),
        if (vm.deepLink != null)
          Divider(
            height: 0.0,
          ),
        _saveBuilder(vm),
      ],
    );
  }

  Widget _searchBuilder(
    final BuildContext context,
    final FeedShareVm vm,
    final PeamanUser appUser,
  ) {
    final _followersIds = vm.followers.map((e) => e.uid!).toList();
    final _followingIds = vm.following.map((e) => e.uid!).toList();
    final _chatUserIds = vm.chats.map((e) {
      return (appUser.uid == e.firstUserId ? e.secondUserId : e.firstUserId)!;
    }).toList();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _titleBuilder(context),
          SizedBox(
            height: 10.0,
          ),
          HotepSearchBar(
            controller: vm.searchController,
            onChanged: (val) => vm.createDebounce(),
          ),
          SizedBox(
            height: 10.0,
          ),
          SizedBox(
            height: 500.0,
            child: !vm.searchActive
                ? vm.stateType == StateType.busy
                    ? Column(
                        children: [
                          SizedBox(
                            height: 20.0,
                          ),
                          Spinner(),
                        ],
                      )
                    : FeedShareUsersList.expanded(
                        scroll: true,
                        requiredSearch: true,
                        usersIds: vm.getNonRepeatingUsersList([
                          ..._followersIds,
                          ..._followingIds,
                          ..._chatUserIds,
                        ]),
                        onPressedSend: (user) {
                          vm.sendMessage(feed, user);
                          onShare?.call();
                        },
                      )
                : UserFetcher.multiStream(
                    usersStream: PUserProvider.getUsersBySearchKeyword(
                      searchKeyword:
                          vm.searchController.text.trim().toUpperCase(),
                    ),
                    multiBuilder: (users) {
                      final _userIds = users
                          .where((e) => e.uid != appUser.uid)
                          .map((e) => e.uid!)
                          .toList();
                      return FeedShareUsersList.expanded(
                        scroll: true,
                        requiredSearch: true,
                        usersIds: _userIds,
                        onPressedSend: (user) {
                          vm.sendMessage(feed, user);
                          onShare?.call();
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _titleBuilder(
    final BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Send to',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          Positioned(
            right: 10.0,
            top: 0.0,
            bottom: 0.0,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close_rounded,
                size: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _saveBuilder(final FeedShareVm vm) {
    return GestureDetector(
      onTap: () => vm.download(feed),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: greyColorshade300,
              ),
              child: Center(
                child: Icon(
                  Icons.save_alt_rounded,
                  size: 30.0,
                  color: Colors.black45,
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
              width: 71.0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Download',
                    style: TextStyle(
                      color: greyColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                  if (vm.downloading)
                    SizedBox(
                      width: 5.0,
                    ),
                  if (vm.downloading)
                    Container(
                      width: 10.0,
                      height: 10.0,
                      child: Center(
                        child: Spinner(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
