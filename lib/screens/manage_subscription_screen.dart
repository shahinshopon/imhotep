import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/viewmodels/payment_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/common_widgets/spinner.dart';

class ManageSubscription extends StatelessWidget {
  const ManageSubscription({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VMProvider<PaymentVm>(
      vm: PaymentVm(context),
      onInit: (vm) => vm.onInit(),
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
              'Manage Subscriptions',
              style: TextStyle(
                color: blackColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: Spinner(),
          ),
        );
      },
    );
  }
}
