import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imhotep/models/contest_question_model.dart';
import 'package:imhotep/widgets/common_widgets/hotep_button.dart';
import 'package:peaman/peaman.dart';

import '../common_widgets/hotep_text_input.dart';

class AddQuestionDialogContent extends StatefulWidget {
  final ContestQuestion? question;
  final Function(ContestQuestion)? onQuestionAdd;
  final Function(ContestQuestion)? onQuestionEdit;
  AddQuestionDialogContent({
    Key? key,
    this.question,
    this.onQuestionAdd,
    this.onQuestionEdit,
  }) : super(key: key);

  @override
  State<AddQuestionDialogContent> createState() =>
      _AddQuestionDialogContentState();
}

class _AddQuestionDialogContentState extends State<AddQuestionDialogContent> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _option1Controller = TextEditingController();
  final TextEditingController _option2Controller = TextEditingController();
  final TextEditingController _option3Controller = TextEditingController();
  final TextEditingController _option4Controller = TextEditingController();
  int _selectedOption = 0;
  String _id = Peaman.ref.collection('random').doc().id;

  @override
  void initState() {
    super.initState();
    if (widget.question != null) {
      _id = widget.question!.id!;
      _questionController.text = widget.question!.title;
      _option1Controller.text = widget.question!.options[0];
      _option2Controller.text = widget.question!.options[1];
      _option3Controller.text = widget.question!.options[2];
      _option4Controller.text = widget.question!.options[3];
      _selectedOption = widget.question!.correctAnsIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 80.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5.0,
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close_rounded,
            ),
            splashRadius: 20.0,
            iconSize: 30.0,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _textInputBuilder(
                      title: 'Enter question:',
                      hintText: 'Question',
                      controller: _questionController,
                      radio: false,
                    ),
                    _textInputBuilder(
                      title: 'Enter question:',
                      hintText: 'Option 1',
                      controller: _option1Controller,
                      radio: true,
                      radioVal: 0,
                    ),
                    _textInputBuilder(
                      title: 'Enter question:',
                      hintText: 'Option 2',
                      controller: _option2Controller,
                      radio: true,
                      radioVal: 1,
                    ),
                    _textInputBuilder(
                      title: 'Enter question:',
                      hintText: 'Option 3',
                      controller: _option3Controller,
                      radio: true,
                      radioVal: 2,
                    ),
                    _textInputBuilder(
                      title: 'Enter question:',
                      hintText: 'Option 4',
                      controller: _option4Controller,
                      radio: true,
                      radioVal: 3,
                    ),
                    HotepButton.filled(
                      value: 'Confirm',
                      color: Colors.green,
                      padding: const EdgeInsets.all(15.0),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (_questionController.text.trim().isEmpty ||
                            _option1Controller.text.trim().isEmpty ||
                            _option2Controller.text.trim().isEmpty ||
                            _option3Controller.text.trim().isEmpty ||
                            _option4Controller.text.trim().isEmpty) {
                          return Fluttertoast.showToast(
                            msg: 'Please fill in all the details!',
                          );
                        }

                        final _question = ContestQuestion(
                          id: _id,
                          title: _questionController.text.trim(),
                          options: [
                            _option1Controller.text.trim(),
                            _option2Controller.text.trim(),
                            _option3Controller.text.trim(),
                            _option4Controller.text.trim(),
                          ],
                          correctAnsIndex: _selectedOption,
                        );

                        if (widget.question == null) {
                          widget.onQuestionAdd?.call(_question);
                        } else {
                          widget.onQuestionEdit?.call(_question);
                        }
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textInputBuilder({
    required final String title,
    required final String hintText,
    required final TextEditingController controller,
    final bool radio = false,
    final int radioVal = 0,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (radio)
              Radio<int>(
                value: radioVal,
                groupValue: _selectedOption,
                onChanged: (val) {
                  setState(() {
                    _selectedOption = val!;
                  });
                },
              ),
            Expanded(
              child: HotepTextInput.bordered(
                hintText: hintText,
                controller: controller,
                requiredCapitalization: false,
                isExpanded: true,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}
