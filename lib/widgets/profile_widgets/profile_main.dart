import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imhotep/enums/contest_badge_type.dart';
import 'package:imhotep/helpers/dialog_provider.dart';
import 'package:imhotep/models/contest_badge_model.dart';
import 'package:imhotep/services/firebase/database/contest_provider.dart';
import 'package:imhotep/widgets/profile_widgets/profile_properties_count.dart';
import 'package:imhotep/widgets/profile_widgets/profile_user_details.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../enums/state_type.dart';
import '../../helpers/common_helper.dart';
import '../../screens/donation_screen.dart';
import '../../screens/subscription_screen.dart';
import '../../viewmodels/profile_vm.dart';
import '../../viewmodels/vm_provider.dart';
import '../common_widgets/block_view_profile_selector.dart';
import '../common_widgets/hotep_button.dart';
import 'profile_tabs/profile_tabs.dart';

enum _Type {
  personal,
  friend,
}

class ProfileMain extends StatelessWidget {
  final _Type type;
  final PeamanUser? friend;

  const ProfileMain.personal({
    Key? key,
  })  : type = _Type.personal,
        friend = null,
        super(key: key);

  const ProfileMain.friend({
    Key? key,
    required this.friend,
  })  : type = _Type.friend,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _following = context.watch<List<PeamanFollowing>?>();

    return VMProvider<ProfileVm>(
      vm: ProfileVm(context),
      loading: _following == null,
      onInit: (vm) {
        if (type == _Type.friend) {
          vm.onInit(friend!, vm.followings ?? []);
        }
      },
      builder: (context, vm, appVm, appUser) {
        final _user = type == _Type.friend ? friend! : appUser!;

        final _blockedUsersIds = vm.blockedUsers.map((e) => e.uid).toList();
        final _isFriendBlocked =
            friend == null ? false : _blockedUsersIds.contains(friend!.uid);

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: type == _Type.personal ? 20.0 : 0.0,
              ),
              ProfileUserDetails(
                appUser: _user,
                suffix: type == _Type.personal
                    ? null
                    : GestureDetector(
                        onTap: () {
                          DialogProvider(context).showBottomSheet(
                            widget: BlockAndViewProfileSelector(
                              alreadyBlocked: _isFriendBlocked,
                              onBlock: () {
                                if (_isFriendBlocked) {
                                  vm.unblockUser(
                                    appUser!,
                                    friend!,
                                  );
                                } else {
                                  vm.blockUser(
                                    appUser!,
                                    friend!,
                                  );
                                }
                              },
                            ),
                          );
                        },
                        child: Icon(
                          Icons.more_vert_rounded,
                        ),
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              ProfilePropertiesCount(
                articlesViewed: 0,
                repliesReceived: _user.repliesReceived,
                likeableComments: _user.likeableComments,
                followers: _user.followers,
                following: _user.following,
              ),
              Divider(),
              type == _Type.personal
                  ? _personalMiddleContentBuilder(context, vm, appUser!)
                  : _friendMiddleContentBuilder(context, appUser!, vm),
              SizedBox(
                height: type == _Type.friend ? 0.0 : 15.0,
              ),
              SizedBox(
                child: type == _Type.friend
                    ? ProfileTabs.friend(
                        friendId: friend!.uid!,
                      )
                    : ProfileTabs.personal(
                        comments: vm.archivedComments,
                        savedFeeds: vm.savedFeeds,
                        allFeeds: appVm.allFeeds,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _friendMiddleContentBuilder(
    final BuildContext context,
    final PeamanUser appUser,
    final ProfileVm vm,
  ) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 10,
      child: Padding(
        padding: EdgeInsets.only(left: 14.0, bottom: 10),
        child: Row(
          children: [
            HotepButton.gradient(
              value: vm.followed ? 'Unfollow' : 'Follow',
              padding: const EdgeInsets.all(0.0),
              width: 80.0,
              loading: vm.stateType == StateType.busy,
              loaderSize: 15.0,
              onPressed: () {
                vm.followed
                    ? vm.unfollowUser(appUser, friend!)
                    : vm.followUser(appUser, friend!);
              },
            ),
            SizedBox(
              width: 15,
            ),
            HotepButton.bordered(
              value: 'Message',
              padding: const EdgeInsets.all(0.0),
              onPressed: () => vm.gotoConversationScreen(friend!),
            ),
            SizedBox(
              width: 15,
            ),
            if (CommonHelper.isMaatWarrior(context, user: friend))
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: whiteColor,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: ExactAssetImage(
                      'assets/warrior.png',
                    ),
                  ),
                ),
              ),
            SizedBox(
              width: 5,
            ),
            StreamBuilder<ContestBadge>(
              stream: ContestProvider.contestBadge(ownerId: friend!.uid!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final _badge = snapshot.data!;
                  String? _badgeIcon;
                  String? _badgeImg;

                  switch (_badge.type) {
                    case ContestBadgeType.gold:
                      _badgeIcon = 'gold_medal';
                      _badgeImg = 'gold';
                      break;
                    case ContestBadgeType.silver:
                      _badgeIcon = 'silver_medal';
                      _badgeImg = 'silver';
                      break;
                    case ContestBadgeType.bronze:
                      _badgeIcon = 'bronze_medal';
                      _badgeImg = 'bronze';
                      break;
                    default:
                  }

                  if (_badgeIcon == null) return Container();

                  return GestureDetector(
                    onTap: () {
                      DialogProvider(context).showBadgeDialog(
                        badgeUrl: 'assets/images/contest_badge_$_badgeImg.png',
                      );
                    },
                    child: Image.asset(
                      'assets/images/${_badgeIcon}.png',
                      height: 35.0,
                    ),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _personalMiddleContentBuilder(
    final BuildContext context,
    final ProfileVm vm,
    final PeamanUser appUser,
  ) {
    String? _contestBadgeIcon;
    String? _contestBadgeImg;
    final _currentDate = DateTime.now();
    final _expireDate = vm.contestBadge?.expiresAt == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            vm.contestBadge!.expiresAt,
          );
    final _contestBadgeExpired =
        _expireDate == null ? true : _currentDate.isAfter(_expireDate);

    switch (vm.contestBadge?.type) {
      case ContestBadgeType.gold:
        _contestBadgeIcon = 'gold_medal';
        _contestBadgeImg = 'gold';
        break;
      case ContestBadgeType.silver:
        _contestBadgeIcon = 'silver_medal';
        _contestBadgeImg = 'silver';
        break;
      case ContestBadgeType.bronze:
        _contestBadgeIcon = 'bronze_medal';
        _contestBadgeImg = 'bronze';
        break;
      default:
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DonationScreen(),
              ),
            );
          },
          child: Image.asset(
            'assets/donate.png',
            height: Get.height * 0.045,
          ),
        ),
        if (CommonHelper.isMaatWarrior(context))
          InkWell(
            onTap: () {
              DialogProvider(context).showBadgeDialog(
                badgeUrl: 'assets/images/maat_warrior_badge.png',
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: Get.height * 0.026,
              child: Padding(
                padding: EdgeInsets.all(2.0),
                child: Image.asset(
                  'assets/warrior.png',
                  scale: 0.6,
                ),
              ),
            ),
          ),
        if (_contestBadgeIcon != null && !_contestBadgeExpired)
          GestureDetector(
            onTap: () {
              DialogProvider(context).showBadgeDialog(
                badgeUrl: 'assets/images/contest_badge_$_contestBadgeImg.png',
              );
            },
            child: Image.asset(
              'assets/images/${_contestBadgeIcon}.png',
              height: 35.0,
            ),
          ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SubscriptionScreen(),
              ),
            );
          },
          child: Image.asset(
            'assets/subscribe.png',
            height: Get.height * 0.045,
          ),
        ),
      ],
    );
  }
}
