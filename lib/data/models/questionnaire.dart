import 'questionnaire_meta.dart';

class Questionnaire {
  final Map<String, String> answers;

  const Questionnaire({this.answers = const {}});

  int get answeredCount =>
      answers.values.where((v) => v.trim().isNotEmpty).length;

  int get totalCount => QuestionnaireMeta.fields.length;

  double get progress => totalCount == 0 ? 0 : answeredCount / totalCount;

  bool get isComplete => answeredCount == totalCount;

  String? answerFor(String key) => answers[key];

  Map<String, dynamic> toCreateJson() => Map<String, dynamic>.from(answers);

  factory Questionnaire.fromJson(Map<String, dynamic> json) {
    final answers = <String, String>{};
    for (final field in QuestionnaireMeta.fields) {
      final value = json[field.key];
      if (value is String && value.trim().isNotEmpty) {
        answers[field.key] = value;
      }
    }
    return Questionnaire(answers: answers);
  }
}
