import 'package:flutter/material.dart';
import 'package:imhotep/models/contest_question_model.dart';

import 'create_questions_list_item.dart';

class CreateQuestionsList extends StatelessWidget {
  final List<ContestQuestion> contestQuestions;
  final Function(ContestQuestion)? onEdit;
  final Function(ContestQuestion)? onDelete;
  final bool requiredTitle;
  final bool requiredEditDelete;
  const CreateQuestionsList({
    Key? key,
    required this.contestQuestions,
    this.onEdit,
    this.onDelete,
    this.requiredTitle = true,
    this.requiredEditDelete = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (contestQuestions.isNotEmpty && requiredTitle)
          Text(
            'Questions:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff3D4A5A),
            ),
          ),
        if (contestQuestions.isNotEmpty && requiredTitle)
          SizedBox(
            height: 20.0,
          ),
        ListView.separated(
          itemCount: contestQuestions.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final _question = contestQuestions[index];
            return CreateQuestionsListItem(
              index: index,
              contestQuestion: _question,
              onEdit: () => onEdit?.call(_question),
              onDelete: () => onDelete?.call(_question),
              requiredEditDelete: requiredEditDelete,
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        ),
      ],
    );
  }
}
