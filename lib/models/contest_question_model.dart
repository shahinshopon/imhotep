class ContestQuestion {
  final String? id;
  final String title;
  final String description;
  final List<String> options;
  final int correctAnsIndex;
  final int createdAt;

  ContestQuestion({
    this.id,
    this.title = '',
    this.description = '',
    this.options = const [],
    this.correctAnsIndex = -1,
    this.createdAt = -1,
  });

  ContestQuestion copyWith({
    final String? id,
    final String? title,
    final String? description,
    final List<String>? options,
    final int? correctAnsIndex,
    final int? createdAt,
  }) {
    return ContestQuestion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      options: options ?? this.options,
      correctAnsIndex: correctAnsIndex ?? this.correctAnsIndex,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static ContestQuestion fromJson(final Map<String, dynamic> data) {
    return ContestQuestion(
      id: data['id'],
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctAnsIndex: data['correct_ans_index'] ?? -1,
      createdAt: data['created_at'] ?? -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'options': options,
      'correct_ans_index': correctAnsIndex,
      'created_at': createdAt,
    };
  }
}
