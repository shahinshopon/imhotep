import 'package:flutter/material.dart';
import 'package:imhotep/models/contest_model.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:provider/provider.dart';

class ContestsVm extends BaseVm {
  final BuildContext context;
  ContestsVm(this.context);

  List<Contest>? get contests => context.watch<List<Contest>?>();
}
