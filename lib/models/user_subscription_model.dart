class UserSubscription {
  final String status;
  final String role;

  UserSubscription({
    this.role = '',
    this.status = '',
  });

  static UserSubscription fromJson(final Map<String, dynamic> data) {
    return UserSubscription(
      role: data['role'] ?? '',
      status: data['status'] ?? '',
    );
  }
}
