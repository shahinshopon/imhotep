import 'package:flutter/material.dart';
import 'package:imhotep/helpers/date_time_helper.dart';
import 'package:imhotep/viewmodels/create_contest_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/common_widgets/hotep_button.dart';

import '../constants.dart';
import '../enums/state_type.dart';
import '../widgets/common_widgets/hotep_text_input.dart';
import '../widgets/create_contest_widgets/create_questions_list.dart';

class CreateContestScreen extends StatelessWidget {
  const CreateContestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VMProvider<CreateContestVm>(
      vm: CreateContestVm(context),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          backgroundColor: whiteColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: whiteColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              color: blackColor,
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Create Contest',
              style: TextStyle(
                color: blackColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  _textInputBuilder(
                    title: 'Enter title:',
                    hintText: 'Title',
                    controller: vm.titleController,
                  ),
                  _textInputBuilder(
                    title: 'Enter description:',
                    hintText: 'Description',
                    controller: vm.descriptionController,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Divider(),
                  _dateSelectorBuilder(
                    title: 'Enter contest start date:',
                    subTitle: vm.startsAtDate == null
                        ? 'Select Date'
                        : DateTimeHelper.getFormattedDate(vm.startsAtDate!),
                    onPressed: vm.openDatePicker,
                  ),
                  _dateSelectorBuilder(
                    title: 'Enter contest start time:',
                    subTitle: vm.startsAtTime == null
                        ? 'Select Time'
                        : DateTimeHelper.getFormattedTime(vm.startsAtTime!),
                    onPressed: vm.openTimePicker,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Divider(),
                  CreateQuestionsList(
                    contestQuestions: vm.questions,
                    onEdit: (q) => vm.showAddQuestionBottomsheet(
                      question: q,
                    ),
                    onDelete: (q) {
                      vm.updateQuestions(
                        vm.questions
                            .where((element) => element.id != q.id)
                            .toList(),
                      );
                    },
                  ),
                  _addQuestionBuilder(vm),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(
              10.0,
            ),
            child: HotepButton.filled(
              value: 'Create Contest',
              borderRadius: 15.0,
              padding: const EdgeInsets.all(15.0),
              loading: vm.stateType == StateType.busy,
              onPressed: vm.createContest,
            ),
          ),
        );
      },
    );
  }

  Widget _textInputBuilder({
    required final String title,
    required final String hintText,
    required final TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.0,
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff3D4A5A),
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        HotepTextInput.bordered(
          hintText: hintText,
          controller: controller,
          requiredCapitalization: false,
          isExpanded: true,
        ),
      ],
    );
  }

  Widget _dateSelectorBuilder({
    required final String title,
    required final String subTitle,
    final Function()? onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.0,
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff3D4A5A),
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        HotepButton.filled(
          value: subTitle,
          onPressed: onPressed,
          color: Colors.green,
          padding: const EdgeInsets.all(0.0),
        ),
      ],
    );
  }

  Widget _addQuestionBuilder(final CreateContestVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.0,
        ),
        HotepButton.filled(
          value: 'Add question',
          icon: Icon(
            Icons.add_rounded,
            color: whiteColor,
          ),
          onPressed: vm.showAddQuestionBottomsheet,
          color: Colors.green,
          padding: const EdgeInsets.all(0.0),
        ),
      ],
    );
  }
}
