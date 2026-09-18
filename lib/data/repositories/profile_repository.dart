import '../../core/network/api_client.dart';
import '../models/profile.dart';

class ProfileRepository {
  ProfileRepository(this._client);

  final ApiClient _client;

  Future<Profile?> getMyProfile() async {
    final json = await _client.get('/profile/me');
    final data = json is Map && json['data'] is Map ? json['data'] : null;
    if (data is Map) return Profile.fromJson(Map<String, dynamic>.from(data));
    return null;
  }

  Future<Profile> createProfile(Profile profile) async {
    final json = await _client.post('/profile', body: profile.toCreateJson());
    return Profile.fromJson(Map<String, dynamic>.from(json['data'] as Map));
  }

  Future<Profile> updateProfile(Profile profile) async {
    final json = await _client.put('/profile', body: profile.toCreateJson());
    return Profile.fromJson(Map<String, dynamic>.from(json['data'] as Map));
  }
}
