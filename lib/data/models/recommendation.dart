import 'match.dart';

class Recommendation {
  final SimpleUserRef user;
  final String city;
  final String occupation;
  final String education;
  final String relationshipGoal;
  final String about;
  final Match match;

  const Recommendation({
    required this.user,
    required this.city,
    required this.occupation,
    required this.education,
    required this.relationshipGoal,
    required this.about,
    required this.match,
  });

  String get relationshipGoalLabel {
    switch (relationshipGoal) {
      case 'marriage':
        return 'Marriage';
      case 'serious_relationship':
        return 'Serious relationship';
      case 'long_term_relationship':
        return 'Long-term relationship';
      default:
        return 'Still exploring';
    }
  }

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map
        ? SimpleUserRef.fromJson(Map<String, dynamic>.from(json['user']))
        : const SimpleUserRef(id: '', name: 'Unknown');
    final profile = json['profile'] is Map
        ? Map<String, dynamic>.from(json['profile'] as Map)
        : const <String, dynamic>{};
    return Recommendation(
      user: user,
      city: profile['currentCity']?.toString() ?? '',
      occupation: profile['occupation']?.toString() ?? '',
      education: profile['education']?.toString() ?? '',
      relationshipGoal: profile['relationshipGoal']?.toString() ?? '',
      about: profile['about']?.toString() ?? '',
      match: Match.fromRecommendation(json),
    );
  }
}
