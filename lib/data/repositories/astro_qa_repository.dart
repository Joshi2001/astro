import '../../core/network/api_client.dart';
import '../models/qa_answer.dart';

class AstroQaRepository {
  AstroQaRepository(this._client);

  final ApiClient _client;

  Future<QAAnswer> ask(String question, {String? partnerId}) async {
    final json = await _client.post(
      '/astro-qa/ask',
      body: {'question': question, 'partnerId': ?partnerId},
    );
    return QAAnswer.fromJson(
      json is Map ? Map<String, dynamic>.from(json) : const {},
    );
  }
}
