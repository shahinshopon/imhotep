import 'package:flutter/material.dart';
import 'package:imhotep/models/contest_model.dart';
import 'package:imhotep/widgets/contest_widgets/contests_list_item.dart';

class ContestsList extends StatelessWidget {
  final List<Contest> contests;
  const ContestsList({
    Key? key,
    required this.contests,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: contests.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final _contest = contests[index];
        return ContestListItem(
          contest: _contest,
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}
