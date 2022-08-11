import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imhotep/constants.dart';

import '../../screens/subscription_screen.dart';
import 'hotep_button.dart';

class PremiumFeatureDialogContent extends StatelessWidget {
  const PremiumFeatureDialogContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20.0,
          ),
          SvgPicture.asset(
            'assets/svgs/lock.svg',
            color: blackColor,
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'Unlock this feature\nby becoming premium',
            style: TextStyle(
              fontSize: 26.0,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HotepButton.gradient(
                value: 'Join now',
                width: 150.0,
                padding: const EdgeInsets.all(3.0),
                borderRadius: 50.0,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SubscriptionScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HotepButton.bordered(
                value: 'Close',
                width: 150.0,
                borderColor: blueColor,
                padding: const EdgeInsets.all(3.0),
                borderRadius: 50.0,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
