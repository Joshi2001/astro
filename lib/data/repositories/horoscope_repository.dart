import '../../core/network/api_client.dart';
import '../models/horoscope.dart';

class HoroscopeRepository {
  HoroscopeRepository(this._client);

  final ApiClient _client;

  Future<Horoscope?> getMyHoroscope() async {
    final json = await _client.get('/horoscope/me');
    final data = json is Map && json['data'] is Map ? json['data'] : null;
    if (data is Map) return Horoscope.fromJson(Map<String, dynamic>.from(data));
    return null;
  }

  Future<Horoscope> createHoroscope(Horoscope horoscope) async {
    final json = await _client.post(
      '/horoscope',
      body: horoscope.toCreateJson(),
    );
    return Horoscope.fromJson(Map<String, dynamic>.from(json['data'] as Map));
  }

  Future<Horoscope> updateHoroscope(Horoscope horoscope) async {
    final json = await _client.put(
      '/horoscope',
      body: horoscope.toCreateJson(),
    );
    return Horoscope.fromJson(Map<String, dynamic>.from(json['data'] as Map));
  }
}
