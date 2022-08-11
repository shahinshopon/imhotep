import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/models/contest_question_model.dart';

class ContestQuestionsListItem extends StatefulWidget {
  final int index;
  final int length;
  final ContestQuestion question;
  final int selectedAns;
  final Function(ContestQuestion, int)? onSelect;
  const ContestQuestionsListItem({
    Key? key,
    required this.index,
    required this.length,
    required this.question,
    this.selectedAns = -1,
    this.onSelect,
  }) : super(key: key);

  @override
  State<ContestQuestionsListItem> createState() =>
      _ContestQuestionsListItemState();
}

class _ContestQuestionsListItemState extends State<ContestQuestionsListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20.0,
          ),
          _titleBuilder(),
          SizedBox(
            height: 20.0,
          ),
          _questionBuilder(),
          SizedBox(
            height: 20.0,
          ),
          _optionsListBuilder(),
        ],
      ),
    );
  }

  Widget _titleBuilder() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Question ${widget.index + 1}/',
          style: TextStyle(
            fontSize: 26.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 1.0),
          child: Text(
            '${widget.length}',
            style: TextStyle(
              fontSize: 23.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _questionBuilder() {
    return Text(
      widget.question.title,
      style: TextStyle(
        fontSize: 20.0,
        color: greyColor,
      ),
    );
  }

  Widget _optionsListBuilder() {
    return ListView.builder(
      itemCount: widget.question.options.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final _option = widget.question.options[index];
        return _optionListItem(title: _option, val: index);
      },
    );
  }

  Widget _optionListItem({
    required final String title,
    final int val = 0,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        children: [
          Radio<int>(
            value: val,
            groupValue: widget.selectedAns,
            onChanged: (val) => widget.onSelect?.call(
              widget.question,
              val!,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20.0,
                color: greyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
