class EditorAccessConfig {
  final bool createPost;
  final bool createStory;
  final bool createContest;
  final bool updateArticles;
  final bool createCustomAd;
  final bool createCustomNotification;
  final bool createInAppAlert;

  EditorAccessConfig({
    this.createPost = false,
    this.createStory = false,
    this.createContest = false,
    this.updateArticles = false,
    this.createCustomAd = false,
    this.createCustomNotification = false,
    this.createInAppAlert = false,
  });

  static EditorAccessConfig fromJson(final Map<String, dynamic> data) {
    return EditorAccessConfig(
      createPost: data['create_post'] ?? false,
      createStory: data['create_story'] ?? false,
      createContest: data['create_contest'] ?? false,
      updateArticles: data['update_articles'] ?? false,
      createCustomAd: data['create_custom_ad'] ?? false,
      createCustomNotification: data['create_custom_notification'] ?? false,
      createInAppAlert: data['create_in_app_alert'] ?? false,
    );
  }
}
