import 'package:flutter/material.dart';
import 'package:imhotep/enums/subscription_type.dart';
import 'package:imhotep/models/stripe_subscription_model.dart';
import 'package:imhotep/models/stripe_subscription_price_model.dart';
import 'package:imhotep/services/firebase/functions/payment_provider.dart';

import '../../constants.dart';
import '../../helpers/common_helper.dart';

class SubscriptionPackagesListItem extends StatefulWidget {
  final StripeSubscription subscription;
  final SubscriptionType activeSubscriptionType;
  final Function(StripeSubscriptionPrice)? onPressed;
  const SubscriptionPackagesListItem({
    Key? key,
    required this.subscription,
    required this.activeSubscriptionType,
    this.onPressed,
  }) : super(key: key);

  @override
  State<SubscriptionPackagesListItem> createState() =>
      _SubscriptionPackagesListItemState();
}

class _SubscriptionPackagesListItemState
    extends State<SubscriptionPackagesListItem> {
  late Stream<List<StripeSubscriptionPrice>> _pricesStream;

  @override
  void initState() {
    super.initState();
    _pricesStream = PaymentProvider.subscriptionPricesBySubscriptionId(
      subscriptionId: widget.subscription.id!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _userSubType = CommonHelper.subscriptionType(context);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: StreamBuilder<List<StripeSubscriptionPrice>>(
        stream: _pricesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final _prices = snapshot.data ?? [];
            final _price = _prices.isNotEmpty ? _prices.last : null;

            final _interval = _price?.intervalCount ?? 0;
            final _amount = (_price?.unitAmount ?? 0.0) / 100;
            final _amountPerMonth = ((_price?.unitAmount ?? 0.0) / 100) /
                (_interval == 1 ? 12 : _interval);

            if (_price == null) return Container();

            return InkWell(
              onTap: () => widget.onPressed?.call(_price),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 170.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: 2,
                      color: _userSubType ==
                              subscriptionType['${widget.subscription.role}']
                          ? Colors.green
                          : widget.activeSubscriptionType ==
                                  subscriptionType[
                                      '${widget.subscription.role}']
                              ? blueColor
                              : whiteColor,
                    ),
                  ),
                  child: Column(
                    children: [
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _userSubType ==
                                    subscriptionType[
                                        '${widget.subscription.role}']
                                ? Colors.green
                                : widget.activeSubscriptionType ==
                                        subscriptionType[
                                            '${widget.subscription.role}']
                                    ? blueColor
                                    : whiteColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                          ),
                          height: 35.0,
                          child: Text(
                            widget.subscription.name,
                            style: TextStyle(
                              color: _userSubType ==
                                          subscriptionType[
                                              '${widget.subscription.role}'] ||
                                      widget.activeSubscriptionType ==
                                          subscriptionType[
                                              '${widget.subscription.role}']
                                  ? whiteColor
                                  : blackColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '${_price.intervalCount}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              '${_price.interval}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              '\$${_amountPerMonth.toStringAsFixed(2)}/month',
                              style: TextStyle(
                                color: greyColor,
                                fontSize: 12.0,
                              ),
                            ),
                            Text(
                              '\$${_amount}',
                              style: TextStyle(
                                color: _userSubType ==
                                        subscriptionType[
                                            '${widget.subscription.role}']
                                    ? Colors.green
                                    : blueColor,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'SourceSansPro-SemiBold',
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
