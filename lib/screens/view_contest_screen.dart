import 'package:flutter/material.dart';
import 'package:imhotep/models/contest_model.dart';
import 'package:imhotep/models/contest_question_model.dart';
import 'package:imhotep/services/firebase/database/contest_provider.dart';
import 'package:imhotep/viewmodels/view_contest_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/common_widgets/hotep_button.dart';
import 'package:imhotep/widgets/common_widgets/rounded_icon_button.dart';
import 'package:imhotep/widgets/contest_widgets/contest_questions_list.dart';
import 'package:imhotep/widgets/create_contest_widgets/create_questions_list.dart';
import 'package:peaman/peaman.dart';

import '../constants.dart';
import '../helpers/dialog_provider.dart';

class ViewContestScreen extends StatefulWidget {
  final Contest contest;
  const ViewContestScreen({
    Key? key,
    required this.contest,
  }) : super(key: key);

  @override
  State<ViewContestScreen> createState() => _ViewContestScreenState();
}

class _ViewContestScreenState extends State<ViewContestScreen> {
  Stream<List<ContestQuestion>>? _contestQuestionsStream;

  @override
  void initState() {
    super.initState();
    _contestQuestionsStream = ContestProvider.contestQuestionsByContestId(
      contestId: widget.contest.id!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return VMProvider<ViewContestVm>(
      vm: ViewContestVm(context),
      builder: (context, vm, appVm, appUser) {
        return StreamBuilder<List<ContestQuestion>>(
          stream: _contestQuestionsStream,
          builder: (context, snap) {
            final _questions = snap.data ?? [];
            return Scaffold(
              backgroundColor: whiteColor,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(70.0),
                child: AppBar(
                  elevation: 0,
                  backgroundColor: blueColor,
                  leading: Padding(
                    padding: const EdgeInsets.only(
                      top: 15.0,
                      left: 20.0,
                    ),
                    child: RoundIconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: blueColor,
                      ),
                      padding: const EdgeInsets.only(
                        bottom: 15.0,
                        right: 15.0,
                        top: 9.0,
                        left: 6.0,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
              body: snap.hasData
                  ? vm.ansSubmitted
                      ? _answerSubmittedBuilder(vm, _questions)
                      : ContestQuestionsList(
                          pageController: vm.pageController,
                          questions: _questions,
                          selectedAnswers: vm.selectedAnswers,
                          onSelect: vm.onOptionSelect,
                        )
                  : Container(),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(10.0),
                child: vm.ansSubmitted
                    ? null
                    : _actionButtonsBuilder(vm, appUser!, _questions),
              ),
            );
          },
        );
      },
    );
  }

  Widget _actionButtonsBuilder(
    final ViewContestVm vm,
    final PeamanUser appUser,
    final List<ContestQuestion> questions,
  ) {
    final _finalQuestion = vm.questionIndex == questions.length - 1;
    return Row(
      children: [
        Expanded(
          child: HotepButton.gradient(
            value: 'Previous',
            borderRadius: 10.0,
            padding: const EdgeInsets.all(8.0),
            onPressed: vm.onPressedPrevious,
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: HotepButton.gradient(
            value: _finalQuestion ? 'Submit' : 'Next',
            borderRadius: 10.0,
            padding: const EdgeInsets.all(8.0),
            onPressed: _finalQuestion
                ? () => vm.onPressedSubmit(
                      appUser,
                      widget.contest,
                      questions,
                    )
                : vm.onPressedNext,
          ),
        ),
      ],
    );
  }

  Widget _answerSubmittedBuilder(
    final ViewContestVm vm,
    final List<ContestQuestion> questions,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.0,
            ),
            _numberBuilder(
              title: 'Total Questions: ',
              number: questions.length,
            ),
            SizedBox(
              height: 10.0,
            ),
            _numberBuilder(
              title: 'Total Attempted: ',
              number: vm.selectedAnswers.length,
            ),
            SizedBox(
              height: 10.0,
            ),
            _numberBuilder(
              title: 'Total Scored: ',
              number: vm.correctAnswers,
            ),
            SizedBox(
              height: 10.0,
            ),
            _badgeBuilder(vm, questions),
            SizedBox(
              height: 30.0,
            ),
            CreateQuestionsList(
              contestQuestions: questions,
              requiredTitle: false,
              requiredEditDelete: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _numberBuilder({
    required final String title,
    required final int number,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff3D4A5A),
            fontSize: 16.0,
          ),
        ),
        Text(
          '${number}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: blueColor,
            fontSize: 20.0,
          ),
        ),
      ],
    );
  }

  Widget _badgeBuilder(
    final ViewContestVm vm,
    final List<ContestQuestion> questions,
  ) {
    String _badgeIcon = 'None';
    String _badgeImg = 'None';
    final _percent = vm.correctAnswers / questions.length * 100;

    if (_percent == 100) {
      _badgeIcon = 'gold_medal';
      _badgeImg = 'gold';
    } else if (_percent >= 90) {
      _badgeIcon = 'silver_medal';
      _badgeImg = 'silver';
    } else if (_percent >= 80) {
      _badgeIcon = 'bronze_medal';
      _badgeImg = 'bronze';
    }

    return Row(
      children: [
        Text(
          'Badge Obtained: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff3D4A5A),
            fontSize: 16.0,
          ),
        ),
        _badgeIcon == 'None'
            ? Text(
                'None',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: blueColor,
                  fontSize: 17.0,
                ),
              )
            : GestureDetector(
                onTap: () {
                  DialogProvider(context).showBadgeDialog(
                    badgeUrl: 'assets/images/contest_badge_$_badgeImg.png',
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Image.asset(
                  'assets/images/${_badgeIcon}.png',
                  height: 30.0,
                ),
              ),
      ],
    );
  }
}
