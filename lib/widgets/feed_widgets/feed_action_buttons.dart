import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/viewmodels/feed_action_buttons_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:peaman/peaman.dart';

class FeedActionButtons extends StatelessWidget {
  final PeamanFeed feed;
  final Function(PeamanFeed)? onFeedUpdate;
  final bool disabledViews;
  const FeedActionButtons({
    Key? key,
    required this.feed,
    this.onFeedUpdate,
    this.disabledViews = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VMProvider<FeedActionButtonsVm>(
      vm: FeedActionButtonsVm(context),
      onInit: (vm) => vm.onInit(thisFeed: feed),
      builder: (context, vm, appVm, appUser) {
        if (vm.feed != feed) {
          vm.updateFeed(
            feed,
            requiredStateChange: false,
          );
        }

        final _liked = vm.feed.extraData['liked'] ?? false;
        final _saved = vm.feed.extraData['saved'] ?? false;
        final _viewed = vm.feed.extraData['viewed'] ?? false;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (_liked) {
                    vm.unlikeFeed(appUser!);
                  } else {
                    vm.likeFeed(appUser!, onLiked: () {
                      onFeedUpdate?.call(vm.feed);
                    });
                  }
                  onFeedUpdate?.call(vm.feed);
                },
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/blue like button.svg',
                      color: !_liked ? greyColorshade400 : null,
                    ),
                    SizedBox(
                      width: 05,
                    ),
                    Text(
                      '${vm.formatNumber(vm.feed.reactionsCount)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 220,
                height: MediaQuery.of(context).size.height / 20,
                color: greyColor.withOpacity(0.2),
              ),
              GestureDetector(
                onTap: () {
                  vm.gotoComments(onComment: () {
                    onFeedUpdate?.call(vm.feed);
                  });
                },
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset('assets/svg/Background.svg'),
                    SizedBox(
                      width: 05,
                    ),
                    Text(
                      '${vm.formatNumber(vm.feed.commentsCount)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 220,
                height: MediaQuery.of(context).size.height / 20,
                color: greyColor.withOpacity(0.2),
              ),
              GestureDetector(
                onTap: () {
                  if (_saved) {
                    vm.unsaveFeed(appUser!);
                  } else {
                    vm.saveFeed(appUser!);
                  }
                  onFeedUpdate?.call(vm.feed);
                },
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/fvrt i.svg',
                      color: !_saved ? greyColorshade400 : null,
                    ),
                    SizedBox(
                      width: 05,
                    ),
                    Text(
                      '${vm.formatNumber(vm.feed.savesCount)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 220,
                height: MediaQuery.of(context).size.height / 20,
                color: greyColor.withOpacity(0.2),
              ),
              GestureDetector(
                onTap: () {
                  vm.openShareBottomSheet(onShare: () {
                    onFeedUpdate?.call(vm.feed);
                  });
                },
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset('assets/svg/share lines.svg'),
                    SizedBox(
                      width: 05,
                    ),
                    Text(
                      '${vm.formatNumber(vm.feed.sharesCount)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              if (!disabledViews)
                Container(
                  width: MediaQuery.of(context).size.width / 220,
                  height: MediaQuery.of(context).size.height / 20,
                  color: greyColor.withOpacity(0.2),
                ),
              if (!disabledViews)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/view.svg',
                      color: !_viewed ? greyColorshade400 : null,
                    ),
                    SizedBox(
                      width: 05,
                    ),
                    Text(
                      '${vm.formatNumber(vm.feed.viewsCount)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
