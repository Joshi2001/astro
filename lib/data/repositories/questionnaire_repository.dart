import '../../core/network/api_client.dart';
import '../models/questionnaire.dart';

class QuestionnaireRepository {
  QuestionnaireRepository(this._client);

  final ApiClient _client;

  Future<Questionnaire?> getMyQuestionnaire() async {
    final json = await _client.get('/questionnaire/me');
    final data = json is Map && json['data'] is Map ? json['data'] : null;
    if (data is Map) {
      return Questionnaire.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  Future<Questionnaire> createQuestionnaire(Questionnaire questionnaire) async {
    final json = await _client.post(
      '/questionnaire',
      body: questionnaire.toCreateJson(),
    );
    return Questionnaire.fromJson(
      Map<String, dynamic>.from(json['data'] as Map),
    );
  }

  Future<Questionnaire> updateQuestionnaire(Questionnaire questionnaire) async {
    final json = await _client.put(
      '/questionnaire',
      body: questionnaire.toCreateJson(),
    );
    return Questionnaire.fromJson(
      Map<String, dynamic>.from(json['data'] as Map),
    );
  }
}
