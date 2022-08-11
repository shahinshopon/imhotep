import 'package:flutter/material.dart';
import 'package:imhotep/helpers/dialog_provider.dart';
import 'package:imhotep/models/contest_model.dart';
import 'package:imhotep/models/contest_question_model.dart';
import 'package:imhotep/services/firebase/database/contest_provider.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:imhotep/widgets/create_contest_widgets/add_question_dialog_content.dart';

class CreateContestVm extends BaseVm {
  final BuildContext context;
  CreateContestVm(this.context);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _startsAtDate;
  TimeOfDay? _startsAtTime;
  List<ContestQuestion> _questions = [];

  TextEditingController get titleController => _titleController;
  TextEditingController get descriptionController => _descriptionController;
  DateTime? get startsAtDate => _startsAtDate;
  TimeOfDay? get startsAtTime => _startsAtTime;
  List<ContestQuestion> get questions => _questions;

  // create contest
  void createContest() {
    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty)
      return showToast('Please fill up all the details!');

    if (_startsAtDate == null || _startsAtTime == null)
      return showToast('Please select date and time!');

    final _date = DateTime(
      _startsAtDate!.year,
      _startsAtDate!.month,
      _startsAtDate!.day,
      _startsAtTime!.hour,
      _startsAtTime!.minute,
    );

    final _contest = Contest(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      startsAt: _date.millisecondsSinceEpoch,
    );

    ContestProvider.createContest(
      contest: _contest,
      questions: _questions,
      onSuccess: (_) {
        showToast('Successfully created contest!');
        _clearAll();
      },
      onError: (e) {
        showToast('An unexpected error occured!');
      },
    );
  }

  // open add question dialog
  void showAddQuestionBottomsheet({final ContestQuestion? question}) {
    DialogProvider(context).showBottomSheet(
      widget: AddQuestionDialogContent(
        question: question,
        onQuestionAdd: (val) {
          _questions = [..._questions, val];
          updateQuestions(_questions);
        },
        onQuestionEdit: (val) {
          final _index = _questions.indexWhere(
            (element) => element.id == val.id,
          );
          final _newQuestions = _questions;

          if (_index == -1) showToast('An unexpected error occured!');
          _newQuestions[_index] = val;
          updateQuestions(_newQuestions);
        },
      ),
    );
  }

  // open date picker
  void openDatePicker() async {
    FocusScope.of(context).unfocus();
    final _date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(days: 1095),
      ),
    );

    if (_date != null) {
      updateStartsAtDate(_date);
    }
  }

  // open time picker
  void openTimePicker() async {
    FocusScope.of(context).unfocus();
    final _time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (_time != null) {
      updateStartsAtTime(_time);
    }
  }

  // clear all values
  void _clearAll() {
    _titleController.clear();
    _descriptionController.clear();
    _questions = [];
    notifyListeners();
  }

  // update value of questions
  void updateQuestions(final List<ContestQuestion> newVal) {
    _questions = newVal;
    notifyListeners();
  }

  // update value of startsAtDate
  void updateStartsAtDate(final DateTime newVal) {
    _startsAtDate = newVal;
    notifyListeners();
  }

  // update value of startsAtTime
  void updateStartsAtTime(final TimeOfDay newVal) {
    _startsAtTime = newVal;
    notifyListeners();
  }
}
