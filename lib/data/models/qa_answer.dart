class QASource {
  final String id;
  final String title;
  final String section;

  const QASource({
    required this.id,
    required this.title,
    required this.section,
  });

  factory QASource.fromJson(Map<String, dynamic> json) {
    return QASource(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      section: json['section']?.toString() ?? '',
    );
  }
}

class QAAnswer {
  final String answer;
  final List<QASource> sources;

  const QAAnswer({required this.answer, this.sources = const []});

  factory QAAnswer.fromJson(Map<String, dynamic> json) {
    final raw = json['data'] is Map ? json['data'] : json;
    final sources = raw['sources'];
    return QAAnswer(
      answer: raw['answer']?.toString() ?? '',
      sources: sources is List
          ? sources
                .whereType<Map>()
                .map((e) => QASource.fromJson(Map<String, dynamic>.from(e)))
                .toList()
          : const [],
    );
  }
}
