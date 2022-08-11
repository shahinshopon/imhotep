import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/helpers/common_helper.dart';
import 'package:imhotep/models/app_user_extra_data_model.dart';
import 'package:imhotep/screens/create_post_screen.dart';
import 'package:imhotep/screens/notifications_screen.dart';
import 'package:imhotep/screens/settings_screen.dart';
import 'package:imhotep/viewmodels/app_vm.dart';
import 'package:imhotep/viewmodels/explore_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/common_widgets/spinner.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../widgets/common_widgets/beta_badge.dart';
import '../../widgets/common_widgets/circular_number_indicator.dart';
import '../../widgets/feed_widgets/feeds_list.dart';
import '../../widgets/stories_widgets/stories_list.dart';
import '../photo_editor_screen.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({Key? key}) : super(key: key);

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  gotopage(final BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return SettingsScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    final _appVm = context.watch<AppVm>();
    final _allFeeds = context.watch<List<PeamanFeed>?>();

    return VMProvider<ExploreVm>(
      vm: ExploreVm(context),
      loading: _allFeeds == null,
      onLoadingCompleted: (vm) {
        vm.updateStateType(StateType.busy);
        Future.delayed(
          Duration(milliseconds: _appVm.feedsLoaded ? 0 : 5000),
          () {
            _appVm.getFeeds(
              context,
              _allFeeds ?? [],
            );
            vm.updateStateType(StateType.idle);
          },
        );
      },
      builder: (context, vm, appVm, appUser) {
        final _allFeeds = vm.allFeeds;

        return Scaffold(
          floatingActionButton: CommonHelper.canCreatePost(context)
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) {
                          return CreatePostScreen();
                        },
                      ),
                    );
                  },
                  child: Icon(
                    Icons.add_rounded,
                  ),
                )
              : null,
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: [
                  bluegradientColor.withOpacity(1),
                  yellowgradientColor.withOpacity(1)
                ],
              ),
            ),
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  vm.updateStateType(StateType.busy);
                  Future.delayed(
                    Duration(milliseconds: 2000),
                    () {
                      _appVm.getFeeds(context, _allFeeds ?? []);
                      vm.updateStateType(StateType.idle);
                    },
                  );
                },
                child: Stack(
                  children: [
                    InViewNotifierCustomScrollView(
                      initialInViewIds: ['0'],
                      isInViewPortCondition: (
                        double deltaTop,
                        double deltaBottom,
                        double vpHeight,
                      ) {
                        return deltaTop < (0.5 * vpHeight) &&
                            deltaBottom > (0.5 * vpHeight);
                      },
                      controller: vm.scrollController,
                      slivers: [
                        _topbarBuilder(context, vm, appUser!),
                        _mainComponentsBuilder(context, vm, appVm, appUser)
                      ],
                    ),
                    Positioned(
                      left: 0.0,
                      right: 0.0,
                      top: 50.0,
                      child: _newPostsIndicator(context, vm, appVm),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _topbarBuilder(
    final BuildContext context,
    final ExploreVm vm,
    final PeamanUser appUser,
  ) {
    return SliverAppBar(
      floating: true,
      pinned: false,
      snap: false,
      expandedHeight: 70.0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [
              bluegradientColor.withOpacity(1),
              yellowgradientColor.withOpacity(1)
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 5.0,
            right: 10.0,
            bottom: 8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => vm.scrollListToTop(),
                    child: SizedBox(
                      child: Image.asset(
                        'assets/logo.png',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  // if (vm.stateType == StateType.busy)
                  //   Padding(
                  //     padding: const EdgeInsets.only(top: 6.0),
                  //     child: Container(
                  //       width: 25.0,
                  //       height: 25.0,
                  //       child: CircularProgressIndicator(
                  //         color: Colors.white,
                  //         strokeWidth: 2.0,
                  //       ),
                  //     ),
                  //   ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: BetaBadge(),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => NotificationsScreen(),
                          ),
                        );
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            Icons.notifications_outlined,
                            color: whiteColor,
                            size: 30,
                          ),
                          Positioned(
                            top: -10.0,
                            child: CircularNumberIndicator(
                              num: AppUserExtraData.fromJson(appUser.extraData)
                                  .newNotifications,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    GestureDetector(
                      onTap: () => gotopage(context),
                      child: Icon(
                        Icons.settings_outlined,
                        color: whiteColor,
                        size: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mainComponentsBuilder(
    final BuildContext context,
    final ExploreVm vm,
    final AppVm appVm,
    final PeamanUser appUser,
  ) {
    final _appUserExtraData = AppUserExtraData.fromJson(appUser.extraData);
    final _newFeeds = appVm.allFeeds
        .where((element) => _appUserExtraData.disabledVideo
            ? element.type != PeamanFeedType.video
            : true)
        .toList();
    final _popularFeeds = appVm.popularFeeds
        .where((element) => _appUserExtraData.disabledVideo
            ? element.type != PeamanFeedType.video
            : true)
        .toList();
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: (vm.allMoments ?? []).isNotEmpty ||
                            CommonHelper.canCreateStory(context)
                        ? 120.0
                        : 20.0,
                    child: StoriesList(
                      moments: vm.allMoments ?? [],
                      onPressedCreateMoment: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PhotoEditorScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        labelColor: blueColor,
                        labelStyle: TextStyle(
                          fontFamily: GoogleFonts.nunito().fontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelColor: greyColorshade400,
                        indicatorColor: blueColor,
                        indicatorWeight: 2.0,
                        tabs: [
                          Tab(
                            icon: Text(
                              'Popular',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Tab(
                            icon: Text(
                              'New',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                        onTap: vm.updateCurrentTabIndex,
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      vm.stateType == StateType.busy
                          ? Container(
                              height: MediaQuery.of(context).size.height / 1.5,
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Center(
                                child: Spinner(),
                              ),
                            )
                          : Container(
                              constraints: BoxConstraints(
                                minHeight:
                                    MediaQuery.of(context).size.height / 1.5,
                              ),
                              child: vm.currentTabIndex == 0
                                  ? FeedsList.normal(
                                      feeds: _popularFeeds,
                                      requiredEditDelete: appUser.admin,
                                    )
                                  : FeedsList.normal(
                                      feeds: _newFeeds,
                                      requiredEditDelete: appUser.admin,
                                    ),
                            ),
                      SizedBox(
                        height: 100.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _newPostsIndicator(
    final BuildContext context,
    final ExploreVm vm,
    final AppVm appVm,
  ) {
    bool _newPosts = false;
    final _allFeeds = vm.allFeeds;
    if (appVm.allFeeds.isNotEmpty &&
        appVm.allFeeds.length != (_allFeeds ?? []).length) {
      _newPosts = true;
    }

    if (!_newPosts) return Container();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            vm.scrollListToTop();
            _tabController.animateTo(1);
            vm.updateCurrentTabIndex(1);
            Future.delayed(Duration(milliseconds: 1000), () {
              vm.updateStateType(StateType.busy);
              Future.delayed(
                Duration(milliseconds: 2000),
                () {
                  appVm.getFeeds(context, _allFeeds ?? []);
                  vm.updateStateType(StateType.idle);
                },
              );
            });
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: greyColor.withOpacity(0.6),
                  blurRadius: 5.0,
                  offset: Offset(2.0, 5.0),
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 15.0,
            ),
            child: Text(
              'New Posts',
              style: TextStyle(
                color: greyColor,
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
