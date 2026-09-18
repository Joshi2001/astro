import '../../core/network/api_client.dart';
import '../models/user.dart';

class AuthRepository {
  AuthRepository(this._client);

  final ApiClient _client;

  Future<(String token, User user)> login({
    required String email,
    required String password,
  }) async {
    final json = await _client.post(
      '/auth/login',
      body: {'email': email, 'password': password},
    );
    return _parseAuthResponse(json);
  }

  Future<(String token, User user)> register({
    required String name,
    required String email,
    required String password,
    required String gender,
  }) async {
    final json = await _client.post(
      '/auth/register',
      body: {
        'name': name,
        'email': email,
        'password': password,
        'gender': gender,
      },
    );
    return _parseAuthResponse(json);
  }

  Future<User?> me() async {
    final json = await _client.get('/auth/me');
    final data = json is Map ? (json['data'] ?? json['user']) : null;
    if (data is Map) return User.fromJson(Map<String, dynamic>.from(data));
    return null;
  }

  Future<void> logout() async {
    try {
      await _client.post('/auth/logout');
    } catch (_) {
      // Logout is best-effort on the client side.
    }
  }

  (String, User) _parseAuthResponse(dynamic json) {
    final jsonToken = json is Map ? (json['token']?.toString() ?? '') : '';
    final token = jsonToken.isNotEmpty ? jsonToken : (_client.authCookie ?? '');
    final user = json is Map && json['user'] is Map
        ? User.fromJson(Map<String, dynamic>.from(json['user'] as Map))
        : throw Exception('Invalid auth response');
    _client.token = token;
    _client.authCookie = token;
    return (token, user);
  }
}
