class Profile {
  final String? id;
  final DateTime? dateOfBirth;
  final String currentCity;
  final String occupation;
  final String education;
  final String relationshipGoal;
  final String about;
  final bool profileCompleted;

  const Profile({
    this.id,
    this.dateOfBirth,
    this.currentCity = '',
    this.occupation = '',
    this.education = '',
    this.relationshipGoal = '',
    this.about = '',
    this.profileCompleted = false,
  });

  String get relationshipGoalLabel {
    switch (relationshipGoal) {
      case 'marriage':
        return 'Marriage';
      case 'serious_relationship':
        return 'Serious relationship';
      case 'long_term_relationship':
        return 'Long-term relationship';
      case 'not_sure':
        return 'Still exploring';
      default:
        return 'Still exploring';
    }
  }

  Map<String, dynamic> toCreateJson() => {
    'dateOfBirth': dateOfBirth?.toIso8601String(),
    'currentCity': currentCity,
    'occupation': occupation,
    'education': education,
    'relationshipGoal': relationshipGoal,
    'about': about,
  };

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: (json['id'] ?? json['_id'])?.toString(),
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'].toString())
          : null,
      currentCity: json['currentCity']?.toString() ?? '',
      occupation: json['occupation']?.toString() ?? '',
      education: json['education']?.toString() ?? '',
      relationshipGoal: json['relationshipGoal']?.toString() ?? '',
      about: json['about']?.toString() ?? '',
      profileCompleted: json['profileCompleted'] == true,
    );
  }
}
