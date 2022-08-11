import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/screens/view_stories_screen.dart';
import 'package:imhotep/widgets/common_widgets/avatar_builder.dart';
import 'package:imhotep/widgets/common_widgets/user_fetcher.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

class StoriesListItem extends StatefulWidget {
  final PeamanMoment moment;
  final List<PeamanMoment> moments;
  StoriesListItem({
    required this.moment,
    required this.moments,
  });

  @override
  State<StoriesListItem> createState() => _StoriesListItemState();
}

class _StoriesListItemState extends State<StoriesListItem> {
  Future<PeamanUser>? _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = PUserProvider.getUserById(uid: widget.moment.ownerId!).first;
  }

  @override
  void didUpdateWidget(StoriesListItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.moments != widget.moments) {
      _userFuture = PUserProvider.getUserById(
        uid: widget.moment.ownerId!,
      ).first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _appUser = context.watch<PeamanUser>();
    return UserFetcher.singleFuture(
      userFuture: _userFuture,
      singleBuilder: (user) {
        final _user = user;
        final _userNames = '${_user.name}'.split(' ');
        final _userName = widget.moment.ownerId == _appUser.uid
            ? 'You'
            : _user.admin
                ? 'Mr. Imhotep'
                : '${_userNames.first}';
        final _thisMomentIndex =
            widget.moments.indexWhere((e) => e.id == widget.moment.id);

        return Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ViewStoriesScreen(
                    moments: widget.moments,
                    initIndex: _thisMomentIndex,
                  ),
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  AvatarBuilder.image(
                    '${_user.photoUrl}',
                    size: 60.9,
                    border: true,
                    borderColor: blueColor,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Text(
                        _userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: blackColor,
                        ),
                      ),
                      // if (CommonHelper.subscriptionType(
                      //           context,
                      //           user: user,
                      //         ) ==
                      //         SubscriptionType.level3 &&
                      //     _userName != 'You')
                      //   SizedBox(
                      //     width: 2.0,
                      //   ),
                      // if (CommonHelper.subscriptionType(
                      //           context,
                      //           user: user,
                      //         ) ==
                      //         SubscriptionType.level3 &&
                      //     _userName != 'You')
                      //   VerifiedUserBadge(
                      //     size: 16.0,
                      //   ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
