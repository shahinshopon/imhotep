import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/models/contest_question_model.dart';

class CreateQuestionsListItem extends StatelessWidget {
  final int index;
  final ContestQuestion contestQuestion;
  final Function()? onEdit;
  final Function()? onDelete;
  final bool requiredEditDelete;
  const CreateQuestionsListItem({
    Key? key,
    required this.index,
    required this.contestQuestion,
    this.onEdit,
    this.onDelete,
    this.requiredEditDelete = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1}. ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${contestQuestion.title}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (requiredEditDelete)
              Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onEdit?.call(),
                    child: Icon(
                      Icons.edit_rounded,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onDelete?.call(),
                    child: Icon(
                      Icons.delete_rounded,
                      color: redAccentColor,
                    ),
                  ),
                ],
              ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        for (int i = 0; i < contestQuestion.options.length; i++)
          _optionBuilder(
            title: contestQuestion.options[i],
            correct: i == contestQuestion.correctAnsIndex,
          ),
      ],
    );
  }

  Widget _optionBuilder({
    required final String title,
    final bool correct = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            correct ? Icons.check_rounded : Icons.close_rounded,
            color: correct ? Colors.green : redAccentColor,
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
