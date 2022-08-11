import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/enums/subscription_type.dart';
import 'package:imhotep/helpers/common_helper.dart';
import 'package:imhotep/viewmodels/payment_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/common_widgets/hotep_button.dart';
import '../constants.dart';
import '../widgets/subscription_widgets/subscription_packages_list.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userSubType = CommonHelper.subscriptionType(context);

    return VMProvider<PaymentVm>(
      vm: PaymentVm(context),
      onInit: (vm) {
        vm.updateSelectedSubscriptionType(
          _userSubType == SubscriptionType.none
              ? SubscriptionType.level3
              : _userSubType,
        );
      },
      builder: (context, vm, appVm, appUser) {
        final _userSubs = vm.userSubscription;

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
              'Subscriptions',
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
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Having our own app requires paying for servers and it is costly. We are also currently working on improving this app, this version is only a prototype. That's why your involvement can make a huge impact.",
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Select a subscription pack:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SubscriptionPackagesList(
                    subscriptions: vm.subscriptions,
                    activeSubscriptionType: vm.selectedSubscriptionType,
                    onPressedPackage: (val1, val2) {
                      vm.updateSelectedSubscription(val1, val2);
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  _featuresList(vm),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: vm.selectedSubscription == null
              ? null
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: HotepButton.filled(
                    value:
                        _userSubs == null ? 'Confirm' : 'Manage Subscription',
                    textStyle: TextStyle(
                      color: whiteColor,
                      fontSize: 18.0,
                    ),
                    borderRadius: 15.0,
                    loading: vm.stateType == StateType.busy,
                    color: _userSubs == null ? blueColor : Colors.green,
                    onPressed: () {
                      _userSubs == null
                          ? vm.subscribe(appUser!)
                          : vm.manageSubscription();
                    },
                  ),
                ),
        );
      },
    );
  }

  Widget _featuresList(final PaymentVm vm) {
    return Column(
      children: [
        _featuresListItem(
          title: 'Chat With Mr. Imhotep',
          locked: vm.selectedSubscriptionType != SubscriptionType.level3,
        ),
        _featuresListItem(
          title: 'No Ads (Google)',
          locked: vm.selectedSubscriptionType != SubscriptionType.level3,
        ),
        _featuresListItem(
          title: 'Get Premium Badge',
          locked: vm.selectedSubscriptionType != SubscriptionType.level3,
        ),
        _featuresListItem(
          title: 'Access Story Creation',
          locked: vm.selectedSubscriptionType == SubscriptionType.level1,
        ),
        _featuresListItem(
          title: "Access Mr.Imhotep's Stories",
          locked: vm.selectedSubscriptionType == SubscriptionType.level1,
        ),
        _featuresListItem(
          title: 'Access Premium Posts',
          locked: vm.selectedSubscriptionType == SubscriptionType.level1,
        ),
        _featuresListItem(
          title: 'Access Sources Of Your Choice',
        ),
        _featuresListItem(
          title: "Download Any Content Directly On The App",
        ),
        _featuresListItem(
          title: 'Become An Architect Of This Platform',
        ),
      ],
    );
  }

  Widget _featuresListItem({
    required final String title,
    final bool locked = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            locked ? 'assets/padlock.svg' : 'assets/tickbold.svg',
            height: 18,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}
