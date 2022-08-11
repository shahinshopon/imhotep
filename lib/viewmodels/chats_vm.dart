import 'package:flutter/material.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

class ChatsVm extends BaseVm {
  final BuildContext context;
  ChatsVm(this.context);

  List<PeamanChat>? get allChats => context.watch<List<PeamanChat>?>();
}
