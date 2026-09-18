import 'package:astro/data/models/questionnaire_meta.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuestionnaireMeta', () {
    test('contains all 26 backend fields', () {
      expect(QuestionnaireMeta.fields.length, 26);
    });

    test('covers all expected field keys', () {
      const keys = {
        'decisionMaking',
        'socialNature',
        'changeVsStability',
        'emotionalHandling',
        'emotionalSupport',
        'stressResponse',
        'disagreementStyle',
        'communicationImportance',
        'problemSolving',
        'trustBuilding',
        'honesty',
        'commitment',
        'responsibility',
        'decisionHandling',
        'conflictResolution',
        'familyImportance',
        'familyInvolvement',
        'socialLifestyle',
        'travelPreferences',
        'dailyRoutine',
        'careerPriority',
        'financialApproach',
        'careerAfterMarriage',
        'idealRelationship',
        'personalSpace',
        'longTermGoals',
      };
      final actual = QuestionnaireMeta.fields.map((f) => f.key).toSet();
      expect(actual, keys);
    });

    test('every field has a question and options', () {
      for (final field in QuestionnaireMeta.fields) {
        expect(field.question, isNotEmpty);
        expect(field.options.length, greaterThanOrEqualTo(3));
      }
    });
  });
}
