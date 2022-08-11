import 'package:flutter/material.dart';
import 'package:imhotep/models/contest_question_model.dart';
import 'package:imhotep/widgets/contest_widgets/contest_questions_list_item.dart';

class ContestQuestionsList extends StatelessWidget {
  final PageController pageController;
  final List<ContestQuestion> questions;
  final Map<String, int> selectedAnswers;
  final Function(ContestQuestion, int)? onSelect;

  const ContestQuestionsList({
    Key? key,
    required this.pageController,
    required this.questions,
    this.selectedAnswers = const {},
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: questions.length,
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final _question = questions[index];
        return ContestQuestionsListItem(
          question: _question,
          index: index,
          length: questions.length,
          selectedAns: selectedAnswers[_question.id] ?? -1,
          onSelect: onSelect,
        );
      },
    );
  }
}
