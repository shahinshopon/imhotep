import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/viewmodels/payment_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/common_widgets/hotep_button.dart';
import 'package:url_launcher/url_launcher.dart';

class DonationScreen extends StatelessWidget {
  const DonationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VMProvider<PaymentVm>(
      vm: PaymentVm(context),
      onInit: (vm) {
        vm.donationController.text = '5';
      },
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
              'Donate',
              style: TextStyle(
                color: blackColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
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
                    'Your donations keep us freely available and accessible to all. To support us, all you have to do is select one of the two options available below.',
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: greyColor),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 58.0,
                          width: 50.0,
                          decoration: BoxDecoration(
                            color: greyColorshade200,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '\$',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: vm.donationController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Amount',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 10.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  HotepButton.gradient(
                    value: 'Donate',
                    loading: vm.stateType == StateType.busy,
                    loaderSize: 20.0,
                    borderRadius: 20.0,
                    padding: const EdgeInsets.all(10.0),
                    onPressed: () => vm.donate(appUser!),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Become an architect, join the builders on Patreon:',
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  HotepButton.gradient(
                    value: 'Patreon',
                    loaderSize: 20.0,
                    borderRadius: 20.0,
                    grandientColors: [
                      redAccentColor.withOpacity(0.8),
                      redAccentColor
                    ],
                    padding: const EdgeInsets.all(10.0),
                    onPressed: () async {
                      try {
                        await launch('https://www.patreon.com/ImhotepMr');
                      } catch (e) {
                        print(e);
                        print('Error!!!: Opening link');
                      }
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
