class StripeSubscriptionPrice {
  final String? id;
  final String interval;
  final int intervalCount;
  final String currency;
  final bool active;
  final double unitAmount;

  StripeSubscriptionPrice({
    this.id,
    this.interval = '',
    this.intervalCount = 0,
    this.currency = 'usd',
    this.unitAmount = 0.0,
    this.active = true,
  });

  static StripeSubscriptionPrice fromJson(final Map<String, dynamic> data) {
    return StripeSubscriptionPrice(
      id: data['id'],
      interval: data['interval'] ?? '',
      intervalCount: data['interval_count'] ?? 0,
      currency: data['currency'] ?? 'usd',
      unitAmount: double.parse('${data['unit_amount'] ?? 0.0}'),
      active: data['active'] ?? true,
    );
  }
}
