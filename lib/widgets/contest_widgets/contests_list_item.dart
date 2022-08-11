import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:imhotep/helpers/common_helper.dart';
import 'package:imhotep/helpers/date_time_helper.dart';
import 'package:imhotep/models/contest_badge_model.dart';
import 'package:imhotep/models/contest_model.dart';
import 'package:imhotep/services/firebase/database/contest_provider.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../helpers/dialog_provider.dart';
import '../../screens/view_contest_screen.dart';
import '../common_widgets/edit_delete_selector.dart';

class ContestListItem extends StatelessWidget {
  final Contest contest;
  ContestListItem({
    Key? key,
    required this.contest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _contestBadge = context.watch<ContestBadge?>();
    final _appUser = context.watch<PeamanUser>();

    final _currentDate = DateTime.now();
    final _contestDate = DateTime.fromMillisecondsSinceEpoch(contest.startsAt);
    final _contestStarted = _currentDate.isAfter(_contestDate) ||
        _currentDate.isAtSameMomentAs(_contestDate);

    final _badgeEarned = _contestBadge?.contestId == contest.id;

    return GestureDetector(
      onLongPress: () {
        DialogProvider(context).showBottomSheet(
          widget: EditDeleteSelector(
            onDelete: () async {
              DialogProvider(context).showAlertDialog(
                title: 'Are you sure you want to delete?',
                description: 'This action is permanent and cannot be undone!',
                onPressedPositiveBtn: () async {
                  await ContestProvider.deleteContest(
                    contestId: contest.id!,
                  );
                  Fluttertoast.showToast(
                    msg: 'Contest deleted!',
                  );
                },
              );
            },
          ),
        );
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 4,
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 4.5,
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            contest.title,
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            CommonHelper.limitedText(
                              contest.description,
                              limit: 136,
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      if (contest.startsAt != -1)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateTimeHelper.getFormattedTime(
                                  TimeOfDay.fromDateTime(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      contest.startsAt,
                                    ),
                                  ),
                                ),
                                style: TextStyle(color: blueColor),
                              ),
                              Text(
                                DateTimeHelper.getFormattedDate(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    contest.startsAt,
                                  ),
                                ),
                                style: TextStyle(
                                  color: blueColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: Get.height * 0.19,
              left: Get.width * 0.17,
              child: InkWell(
                onTap: () {
                  if (!_appUser.admin && (!_contestStarted || _badgeEarned))
                    return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewContestScreen(contest: contest),
                    ),
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 20,
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: blueColor,
                        spreadRadius: 1,
                        blurRadius: 1,
                      )
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        bluegradientColor,
                        yellowgradientColor,
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _badgeEarned
                                ? 'Be ready for next contest!'
                                : _contestStarted
                                    ? 'Enter Quiz'
                                    : 'Starting Soon',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
