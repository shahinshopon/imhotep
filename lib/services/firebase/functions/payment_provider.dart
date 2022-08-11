import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:imhotep/models/stripe_subscription_model.dart';
import 'package:imhotep/models/stripe_subscription_price_model.dart';
import 'package:peaman/peaman.dart';

import '../../../models/user_subscription_model.dart';

class PaymentProvider {
  static final _ref = Peaman.ref;
  static final _functions = FirebaseFunctions.instance;
  static final _stripe = Stripe.instance;

  // donate to app
  static Future<void> donate({
    required final PeamanUser appUser,
    required final double amount,
    final Function()? onSuccess,
    final Function()? onError,
  }) async {
    try {
      final _callable = _functions.httpsCallable(
        'createStripePaymentIntent',
      );
      final _desc =
          'User with id - ${appUser.uid}, name - ${appUser.name} and email - ${appUser.email} just donated \$${amount / 100}';
      final _result = await _callable.call(
        {
          'amount': amount,
          'currency': 'USD',
          'description': _desc,
        },
      );
      final _paymentIntentData = _result.data;

      if (_paymentIntentData == null) throw Future.error('');

      final bool _error = _paymentIntentData['error'] ?? false;
      final _clientSecret = _paymentIntentData['data'];

      if (_error) throw Future.error(_clientSecret);

      await _stripe.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: _clientSecret,
          applePay: true,
          googlePay: true,
          style: ThemeMode.dark,
          merchantCountryCode: 'US',
          merchantDisplayName: 'Shrijan Regmi',
        ),
      );

      await _stripe.presentPaymentSheet();
      print('Success: Making donation');
      onSuccess?.call();
    } catch (e) {
      print(e);
      print('Error!!!: Making donation');
      onError?.call();
    }
  }

  // subscribe to app
  static Future<void> subscribe({
    required final String uid,
    required final StripeSubscriptionPrice subscriptionPrice,
    final Function(String)? onSuccess,
    final Function()? onError,
  }) async {
    try {
      final _checkoutSessionsRef =
          _ref.collection('users').doc(uid).collection('checkout_sessions');
      final _dataToAdd = {
        'price': '${subscriptionPrice.id}',
        'success_url': 'https://mrimhotep.org/success',
        'cancel_url': 'https://mrimhotep.org/cancel',
      };

      await _checkoutSessionsRef.add(_dataToAdd).then((checkoutSessionRef) {
        checkoutSessionRef.snapshots().listen((event) {
          final _checkoutSessionData = event.data();
          final _sessionId = _checkoutSessionData?['url'];

          if (_sessionId != null) {
            onSuccess?.call(_sessionId);
          }
        });
      }).catchError((e) {
        throw Future.error(e);
      });
    } catch (e) {
      print(e);
      print('Error!!!: Making subscription');
      onError?.call();
    }
  }

  // manage subscription
  static Future<void> manageSubscription({
    final Function(String)? onSuccess,
    final Function()? onError,
  }) async {
    try {
      final _callable = _functions.httpsCallable(
        'ext-firestore-stripe-payments-createPortalLink',
      );
      final _result = await _callable.call({
        'returnUrl': 'https://mrimhotep.org',
      });
      final _url = _result.data?['url'];
      if (_url == null) throw Future.error('url returned null');
      onSuccess?.call(_url);
    } catch (e) {
      print(e);
      print('Error!!!: Managing subscription');
      onError?.call();
    }
  }

  // list subscriptions from firestore
  static List<StripeSubscription> _subscriptionsFromFirestore(
    dynamic querySnap,
  ) {
    return List<StripeSubscription>.from(querySnap.docs
        .map(
          (e) => StripeSubscription.fromJson({
            ...(e.data() ?? {}),
            'id': e.id,
          }),
        )
        .toList());
  }

  // list subscription prices from firestore
  static List<StripeSubscriptionPrice> _subscriptionPricesFromFirestore(
    dynamic querySnap,
  ) {
    return List<StripeSubscriptionPrice>.from(querySnap.docs
        .map(
          (e) => StripeSubscriptionPrice.fromJson({
            ...(e.data() ?? {}),
            'id': e.id,
          }),
        )
        .toList());
  }

  // user subscription from firestore
  static UserSubscription? _userSubscriptionFromFirestore(
    final dynamic querySnap,
  ) {
    return querySnap.docs.isEmpty
        ? null
        : UserSubscription.fromJson(
            querySnap.docs.first.data() ?? {},
          );
  }

  // stream of list of subscriptions
  static Stream<List<StripeSubscription>> get subscriptions {
    return _ref
        .collection('stripe_subscriptions')
        .limit(3)
        .snapshots()
        .map(_subscriptionsFromFirestore);
  }

  // stream of list of subscription prices by subscription id
  static Stream<List<StripeSubscriptionPrice>>
      subscriptionPricesBySubscriptionId({
    required final String subscriptionId,
  }) {
    return _ref
        .collection('stripe_subscriptions')
        .doc(subscriptionId)
        .collection('prices')
        .snapshots()
        .map(_subscriptionPricesFromFirestore);
  }

  static Stream<UserSubscription?> getUserSubscription({
    required final String uid,
  }) {
    return _ref
        .collection('users')
        .doc(uid)
        .collection('subscriptions')
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map(_userSubscriptionFromFirestore);
  }
}
