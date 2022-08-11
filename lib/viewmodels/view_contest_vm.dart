import 'package:flutter/material.dart';
import 'package:imhotep/enums/contest_badge_type.dart';
import 'package:imhotep/helpers/dialog_provider.dart';
import 'package:imhotep/models/contest_badge_model.dart';
import 'package:imhotep/models/contest_model.dart';
import 'package:imhotep/models/contest_question_model.dart';
import 'package:imhotep/services/firebase/database/contest_provider.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:peaman/peaman.dart';

class ViewContestVm extends BaseVm {
  final BuildContext context;
  ViewContestVm(this.context);

  PageController _pageController = PageController();
  Map<String, int> _selectedAnswers = {};
  int _questionIndex = 0;
  bool _ansSubmitted = false;
  int _correctAnswers = 0;

  PageController get pageController => _pageController;
  Map<String, int> get selectedAnswers => _selectedAnswers;
  int get questionIndex => _questionIndex;
  bool get ansSubmitted => _ansSubmitted;
  int get correctAnswers => _correctAnswers;

  // on option select
  void onOptionSelect(
    final ContestQuestion question,
    final int selectedOption,
  ) {
    final _newAnswers = <String, int>{
      ..._selectedAnswers,
      '${question.id}': selectedOption,
    };
    updateSelectedAnswers(_newAnswers);
  }

  // on pressed next
  void onPressedNext() {
    final _newVal = _questionIndex + 1;
    updateQuestionIndex(_newVal);
    changePage();
  }

  // on pressed previous
  void onPressedPrevious() {
    final _newVal = _questionIndex - 1;
    updateQuestionIndex(_newVal);
    changePage(reverse: true);
  }

  // on pressed next
  void onPressedSubmit(
    final PeamanUser appUser,
    final Contest contest,
    final List<ContestQuestion> questions,
  ) {
    DialogProvider(context).showAlertDialog(
      title: 'Are you sure you want to submit all of your answers ?',
      description: "This action is permanent and can't be undone.",
      onPressedPositiveBtn: () {
        var _newCorrectAnswers = 0;
        _selectedAnswers.forEach((key, value) {
          final _questionId = key;
          final _index = questions.indexWhere(
            (element) => element.id == _questionId,
          );

          if (_index != -1) {
            final _question = questions[_index];
            if (value == _question.correctAnsIndex) _newCorrectAnswers++;
          }
        });

        final _percent = _newCorrectAnswers / questions.length * 100;
        String _badge = 'None';
        ContestBadgeType _badgeType = ContestBadgeType.none;
        if (_percent == 100) {
          _badge = 'gold';
          _badgeType = ContestBadgeType.gold;
        } else if (_percent >= 90) {
          _badge = 'silver';
          _badgeType = ContestBadgeType.silver;
        } else if (_percent >= 80) {
          _badge = 'bronze';
          _badgeType = ContestBadgeType.bronze;
        }

        if (_badge != 'None') {
          final _currentDate = DateTime.now();
          final _expireDate = _currentDate.add(Duration(days: 7));
          final _contestBadge = ContestBadge(
            ownerId: appUser.uid!,
            contestId: contest.id!,
            type: _badgeType,
            expiresAt: _expireDate.millisecondsSinceEpoch,
          );
          ContestProvider.addBadge(
            contestBadge: _contestBadge,
          );
          Future.delayed(Duration(milliseconds: 500), () {
            DialogProvider(context).showBadgeDialog(
              badgeUrl: 'assets/images/contest_badge_$_badge.png',
            );
          });
        }

        updateCorrectAnswers(_newCorrectAnswers);
        updateAnsSubmitted(true);
      },
    );
  }

  // animate page controller
  void changePage({final bool reverse = false}) {
    _pageController.animateTo(
      MediaQuery.of(context).size.width * _questionIndex,
      duration: Duration(milliseconds: 1000),
      curve: Curves.ease,
    );
  }

  // update value of selectedAnswers
  void updateSelectedAnswers(
    final Map<String, int> newVal,
  ) {
    _selectedAnswers = newVal;
    notifyListeners();
  }

  // update value of questionIndex
  void updateQuestionIndex(
    final int newVal,
  ) {
    if (newVal >= 0) {
      _questionIndex = newVal;
      notifyListeners();
    }
  }

  // update value of ansSubmitted
  void updateAnsSubmitted(
    final bool newVal,
  ) {
    _ansSubmitted = newVal;
    notifyListeners();
  }

  // update value of correctAnswers
  void updateCorrectAnswers(
    final int newVal,
  ) {
    _correctAnswers = newVal;
    notifyListeners();
  }
}
