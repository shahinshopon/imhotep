import 'package:flutter/material.dart';
import 'package:imhotep/viewmodels/app_vm.dart';
import 'package:imhotep/widgets/common_widgets/spinner.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

import 'base_vm.dart';

class VMProvider<T extends BaseVm> extends StatefulWidget {
  final T vm;
  final Widget Function(BuildContext, T, AppVm, PeamanUser?) builder;
  final bool loading;
  final Function(T)? onInit;
  final Function(T)? onDispose;
  final Function(T)? onLoadingCompleted;
  const VMProvider({
    Key? key,
    required this.vm,
    required this.builder,
    this.loading = false,
    this.onInit,
    this.onDispose,
    this.onLoadingCompleted,
  }) : super(key: key);

  @override
  State<VMProvider<T>> createState() => _VMProviderState();
}

class _VMProviderState<T extends BaseVm> extends State<VMProvider<T>> {
  @override
  void initState() {
    super.initState();
    widget.onInit?.call(widget.vm);

    if (!widget.loading) {
      widget.onLoadingCompleted?.call(widget.vm);
    }
  }

  @override
  void dispose() {
    widget.onDispose?.call(widget.vm);
    super.dispose();
  }

  @override
  void didUpdateWidget(VMProvider<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final _oldLoading = oldWidget.loading;
    final _newLoading = widget.loading;

    if (_oldLoading != _newLoading && !_newLoading) {
      widget.onLoadingCompleted?.call(widget.vm);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _appUser = context.watch<PeamanUser?>();
    final _appVm = context.watch<AppVm>();
    final _loading = widget.loading;

    if (_loading)
      return Center(
        child: Spinner(),
      );

    return ChangeNotifierProvider<T>(
      create: (_) => widget.vm,
      builder: (context, child) => Consumer<T>(
        builder: (context, vm, child) {
          return widget.builder(context, vm, _appVm, _appUser);
        },
      ),
    );
  }
}
