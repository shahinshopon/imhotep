import 'package:flutter/material.dart';
import 'package:imhotep/helpers/common_helper.dart';
import 'package:imhotep/screens/create_contest_screen.dart';
import 'package:imhotep/viewmodels/contests_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/common_widgets/hotep_button.dart';

import '../../contest_widgets/contests_list.dart';

class ContestsTab extends StatefulWidget {
  const ContestsTab({Key? key}) : super(key: key);

  @override
  _ContentMessageCardState createState() => _ContentMessageCardState();
}

class _ContentMessageCardState extends State<ContestsTab> {
  @override
  Widget build(BuildContext context) {
    return VMProvider<ContestsVm>(
      vm: ContestsVm(context),
      builder: (context, vm, appVm, appUser) {
        return Column(
          children: [
            if (CommonHelper.canCreateContest(context))
              SizedBox(
                height: 10.0,
              ),
            if (CommonHelper.canCreateContest(context))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: HotepButton.filled(
                  value: 'Create Contest',
                  padding: const EdgeInsets.all(15.0),
                  borderRadius: 15.0,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CreateContestScreen(),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(
              height: 10.0,
            ),
            vm.contests == null
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SingleChildScrollView(
                    child: ContestsList(
                      contests: vm.contests!,
                    ),
                  ),
          ],
        );
      },
    );
  }
}
