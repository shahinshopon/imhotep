class StripeSubscription {
  final String? id;
  final String name;
  final String description;
  final String role;
  final bool active;

  StripeSubscription({
    this.id,
    this.name = '',
    this.description = '',
    this.role = '',
    this.active = true,
  });

  static StripeSubscription fromJson(final Map<String, dynamic> data) {
    return StripeSubscription(
      id: data['id'],
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      role: data['role'] ?? '',
      active: data['active'] ?? true,
    );
  }
}
