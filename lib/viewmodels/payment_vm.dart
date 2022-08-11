import 'package:flutter/material.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/enums/subscription_type.dart';
import 'package:imhotep/helpers/dialog_provider.dart';
import 'package:imhotep/models/stripe_subscription_model.dart';
import 'package:imhotep/models/stripe_subscription_price_model.dart';
import 'package:imhotep/models/user_subscription_model.dart';
import 'package:imhotep/screens/web_view_screen.dart';
import 'package:imhotep/services/firebase/functions/payment_provider.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentVm extends BaseVm {
  final BuildContext context;
  PaymentVm(this.context);

  final TextEditingController _donationController = TextEditingController();
  StripeSubscription? _selectedSubscription;
  StripeSubscriptionPrice? _selectedSubscriptionPrice;
  SubscriptionType _selectedSubscriptionType = SubscriptionType.none;

  TextEditingController get donationController => _donationController;
  StripeSubscription? get selectedSubscription => _selectedSubscription;
  StripeSubscriptionPrice? get selectedSubscriptionPrice =>
      _selectedSubscriptionPrice;
  List<StripeSubscription> get subscriptions =>
      context.watch<List<StripeSubscription>>();
  UserSubscription? get userSubscription => context.watch<UserSubscription?>();
  SubscriptionType get selectedSubscriptionType => _selectedSubscriptionType;

  // init function
  void onInit() {
    manageSubscription(requiredPop: true);
  }

  // donate
  void donate(final PeamanUser appUser) async {
    if (_donationController.text.trim() == '')
      return showToast('Please enter the amount!');

    final _amount = double.parse(_donationController.text.trim()) * 100;
    updateStateType(StateType.busy);
    PaymentProvider.donate(
      appUser: appUser,
      amount: _amount,
      onSuccess: () {
        updateStateType(StateType.idle);
        showToast(
          'Successfully donated \$${_donationController.text.trim()}',
        );
        _donationController.clear();
      },
      onError: () {
        updateStateType(StateType.idle);
        showToast('Could not complete the donation!');
      },
    );
  }

  // subscribe
  void subscribe(final PeamanUser appUser) async {
    updateStateType(StateType.busy);
    PaymentProvider.subscribe(
      uid: appUser.uid!,
      subscriptionPrice: _selectedSubscriptionPrice!,
      onSuccess: (url) {
        updateStateType(StateType.idle);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WebViewScreen(
              url: url,
              navigationDelegate: (val) {
                Navigator.pop(context);
                if (val.url == 'https://mrimhotep.org/success') {
                  if (_selectedSubscriptionType == SubscriptionType.level3) {
                    Future.delayed(Duration(milliseconds: 1000), () {
                      DialogProvider(context).showBadgeDialog(
                        badgeUrl: 'assets/images/premium_user_badge.png',
                      );
                    });
                  }
                }
                return NavigationDecision.prevent;
              },
            ),
          ),
        );
      },
      onError: () {
        updateStateType(StateType.idle);
        showToast(
          'Could not complete the subscription! Please try again later!',
        );
      },
    );
  }

  // manage subscriptions
  void manageSubscription({
    final bool requiredPop = false,
  }) async {
    updateStateType(StateType.busy);
    PaymentProvider.manageSubscription(
      onSuccess: (url) async {
        updateStateType(StateType.idle);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WebViewScreen(
              url: url,
              navigationDelegate: (val) {
                Navigator.pop(context);
                return NavigationDecision.prevent;
              },
            ),
          ),
        );
        if (requiredPop) Navigator.pop(context);
      },
      onError: () {
        updateStateType(StateType.idle);
        showToast(
          'Could not complete the subscription! Please try again later!',
        );
      },
    );
  }

  // update value of selectedSubscription
  void updateSelectedSubscription(
    final StripeSubscription? newVal1,
    final StripeSubscriptionPrice? newVal2,
  ) {
    _selectedSubscription = newVal1;
    _selectedSubscriptionPrice = newVal2;
    _selectedSubscriptionType = subscriptionType[_selectedSubscription!.role]!;
    notifyListeners();
  }

  // update value of selectedSubscriptionType
  void updateSelectedSubscriptionType(final SubscriptionType newVal) {
    _selectedSubscriptionType = newVal;
    notifyListeners();
  }
}
