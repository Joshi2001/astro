class MatchCategory {
  final String key;
  final String level;
  final double score;
  final String description;
  final List<String> details;

  const MatchCategory({
    required this.key,
    required this.level,
    required this.score,
    required this.description,
    this.details = const [],
  });

  factory MatchCategory.fromKey(String key, Map<String, dynamic> json) {
    final details = json['details'];
    return MatchCategory(
      key: key,
      level: json['level']?.toString() ?? 'Unknown',
      score: json['score'] is num ? (json['score'] as num).toDouble() : 0,
      description: json['description']?.toString() ?? '',
      details: details is List
          ? details.map((e) => e.toString()).toList()
          : const [],
    );
  }
}

class MatchAstrology {
  final String level;
  final double score;
  final String description;
  final List<String> details;
  final Map<String, dynamic>? chartA;
  final Map<String, dynamic>? chartB;

  const MatchAstrology({
    required this.level,
    required this.score,
    required this.description,
    this.details = const [],
    this.chartA,
    this.chartB,
  });

  factory MatchAstrology.fromJson(Map<String, dynamic> json) {
    final details = json['details'];
    return MatchAstrology(
      level: json['level']?.toString() ?? 'Unknown',
      score: json['score'] is num ? (json['score'] as num).toDouble() : 0,
      description: json['description']?.toString() ?? '',
      details: details is List
          ? details.map((e) => e.toString()).toList()
          : const [],
      chartA: json['chartA'] is Map
          ? Map<String, dynamic>.from(json['chartA'] as Map)
          : null,
      chartB: json['chartB'] is Map
          ? Map<String, dynamic>.from(json['chartB'] as Map)
          : null,
    );
  }
}

class SimpleUserRef {
  final String id;
  final String name;
  final String gender;

  const SimpleUserRef({required this.id, required this.name, this.gender = ''});

  String get firstName => name.trim().split(' ').first;

  factory SimpleUserRef.fromJson(Map<String, dynamic> json) {
    return SimpleUserRef(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: json['name']?.toString() ?? 'Unknown',
      gender: json['gender']?.toString() ?? '',
    );
  }
}

class Match {
  final String id;
  final SimpleUserRef? userA;
  final SimpleUserRef? userB;
  final String overallLabel;
  final int score;
  final String overallConclusion;
  final List<MatchCategory> categories;
  final MatchAstrology? astrology;
  final List<String> strengths;
  final List<String> potentialChallenges;
  final List<String> recommendations;
  final DateTime? updatedAt;

  Match({
    required this.id,
    this.userA,
    this.userB,
    required this.overallLabel,
    required this.score,
    required this.overallConclusion,
    this.categories = const [],
    this.astrology,
    this.strengths = const [],
    this.potentialChallenges = const [],
    this.recommendations = const [],
    this.updatedAt,
  });

  static const List<String> categoryOrder = [
    'personality',
    'emotional',
    'communication',
    'trustAndCommitment',
    'maturity',
    'understanding',
    'lifestyle',
    'familyValues',
    'careerAndFinance',
    'relationshipExpectations',
    'longTermPotential',
  ];

  static String categoryTitle(String key) =>
      categoryTitles[key] ?? _humanize(key);

  static String _humanize(String key) {
    final words = key
        .replaceAllMapped(RegExp('[A-Z]'), (m) => ' ${m.group(0)}')
        .trim();
    return words[0].toUpperCase() + words.substring(1);
  }

  static const Map<String, String> categoryTitles = {
    'personality': 'Personality Sync',
    'emotional': 'Emotional Connection',
    'communication': 'Communication',
    'trustAndCommitment': 'Trust & Commitment',
    'maturity': 'Emotional Maturity',
    'understanding': 'Mutual Understanding',
    'lifestyle': 'Lifestyle Match',
    'familyValues': 'Family Values',
    'careerAndFinance': 'Career & Finance',
    'relationshipExpectations': 'Expectations',
    'longTermPotential': 'Long-term Potential',
  };

  List<MapEntry<String, MatchCategory>> get categoriesOrdered => [
    for (final key in categoryOrder)
      if (_lookup.containsKey(key)) MapEntry(key, _lookup[key]!),
  ];

  MatchCategory? categoryFor(String key) => _lookup[key];

  late final Map<String, MatchCategory> _lookup = {
    for (final c in categories) c.key: c,
  };

  factory Match.fromJson(Map<String, dynamic> json) {
    final cats = <MatchCategory>[];
    for (final key in categoryOrder) {
      final raw = json[key];
      if (raw is Map) {
        cats.add(MatchCategory.fromKey(key, Map<String, dynamic>.from(raw)));
      }
    }
    MatchAstrology? astrologyRaw;
    final a = json['astrology'];
    if (a is Map) {
      astrologyRaw = MatchAstrology.fromJson(Map<String, dynamic>.from(a));
    }
    return Match(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      userA: json['userA'] is Map
          ? SimpleUserRef.fromJson(Map<String, dynamic>.from(json['userA']))
          : null,
      userB: json['userB'] is Map
          ? SimpleUserRef.fromJson(Map<String, dynamic>.from(json['userB']))
          : null,
      overallLabel: json['overallLabel']?.toString() ?? 'Compatible',
      score: json['score'] is num ? (json['score'] as num).round() : 0,
      overallConclusion: json['overallConclusion']?.toString() ?? '',
      categories: cats,
      astrology: astrologyRaw,
      strengths: _stringList(json['strengths']),
      potentialChallenges: _stringList(json['potentialChallenges']),
      recommendations: _stringList(json['recommendations']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  factory Match.fromRecommendation(Map<String, dynamic> recommendation) {
    final comp = recommendation['compatibility'];
    final user = recommendation['user'];
    return Match(
      id: (user?['_id'] ?? user?['id'] ?? '').toString(),
      userB: user is Map
          ? SimpleUserRef.fromJson(Map<String, dynamic>.from(user))
          : null,
      overallLabel:
          (comp is Map ? comp['label']?.toString() : null) ?? 'Compatible',
      score: (comp is Map && comp['score'] is num)
          ? (comp['score'] as num).round()
          : 0,
      overallConclusion:
          (comp is Map ? comp['conclusion']?.toString() : null) ?? '',
      strengths: (comp is Map && comp['strengths'] is List)
          ? (comp['strengths'] as List).map((e) => e.toString()).toList()
          : const [],
      updatedAt: DateTime.now(),
    );
  }

  static List<String> _stringList(dynamic value) {
    if (value is List) return value.map((e) => e.toString()).toList();
    return const [];
  }
}
