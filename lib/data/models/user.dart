class User {
  final String id;
  final String name;
  final String email;
  final String gender;
  final bool isActive;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.isActive,
  });

  String get firstName => name.trim().split(' ').first;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'gender': gender,
    'isActive': isActive,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? json['_id'] ?? '').toString();
    return User(
      id: id,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      gender: json['gender']?.toString() ?? 'other',
      isActive: json['isActive'] == null ? true : json['isActive'] == true,
    );
  }

  Map<String, String> get genderLabelMap => {
    'male': 'Male',
    'female': 'Female',
    'other': 'Other',
  };

  String get genderLabel => genderLabelMap[gender] ?? 'Other';
}
