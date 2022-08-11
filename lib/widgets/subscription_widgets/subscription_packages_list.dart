import 'package:flutter/material.dart';
import 'package:imhotep/enums/subscription_type.dart';
import 'package:imhotep/models/stripe_subscription_model.dart';
import 'package:imhotep/models/stripe_subscription_price_model.dart';
import 'package:imhotep/widgets/subscription_widgets/subscription_pakages_list_item.dart';

class SubscriptionPackagesList extends StatelessWidget {
  final List<StripeSubscription> subscriptions;
  final SubscriptionType activeSubscriptionType;
  final Function(StripeSubscription, StripeSubscriptionPrice)? onPressedPackage;
  const SubscriptionPackagesList({
    Key? key,
    required this.subscriptions,
    required this.activeSubscriptionType,
    this.onPressedPackage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final subscription in subscriptions)
          Expanded(
            child: SubscriptionPackagesListItem(
              subscription: subscription,
              onPressed: (val) => onPressedPackage?.call(subscription, val),
              activeSubscriptionType: activeSubscriptionType,
            ),
          ),
      ],
    );
  }
}
