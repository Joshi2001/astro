import 'package:get/get.dart';

import '../../core/network/api_exceptions.dart';
import '../../data/models/questionnaire.dart';
import '../../data/models/questionnaire_meta.dart';
import '../../data/repositories/questionnaire_repository.dart';

class QuestionnaireController extends GetxController {
  final _repository = Get.find<QuestionnaireRepository>();

  final RxMap<String, String> answers = RxMap<String, String>({});
  final RxBool loading = RxBool(false);
  final RxBool saving = RxBool(false);
  final Rx<String?> error = Rx<String?>(null);
  final RxBool existing = RxBool(false);

  int get total => QuestionnaireMeta.fields.length;

  int get answered => answers.values.where((v) => v.trim().isNotEmpty).length;

  double get progress => total == 0 ? 0 : answered / total;

  bool get isComplete => answered == total;

  @override
  void onInit() {
    super.onInit();
    loadExisting();
  }

  Future<void> loadExisting() async {
    loading.value = true;
    error.value = null;
    try {
      final q = await _repository.getMyQuestionnaire();
      if (q != null) {
        existing.value = true;
        answers.assignAll(q.answers);
      }
    } on ApiException catch (e) {
      if (!e.isUnauthorized) error.value = e.message;
    } catch (_) {
      error.value = 'Could not load your questionnaire.';
    } finally {
      loading.value = false;
    }
  }

  String? answerFor(String key) => answers[key];

  void select(String key, String option) {
    answers[key] = option;
  }

  Future<bool> save() async {
    if (!isComplete) {
      Get.snackbar(
        'Almost there',
        'Please answer all ${total - answered} remaining question${total - answered == 1 ? '' : 's'}.',
      );
      return false;
    }
    saving.value = true;
    error.value = null;
    try {
      final q = Questionnaire(answers: Map<String, String>.from(answers));
      if (existing.value) {
        await _repository.updateQuestionnaire(q);
      } else {
        await _repository.createQuestionnaire(q);
        existing.value = true;
      }
      Get.back();
      Get.snackbar(
        'Questionnaire saved',
        'Thank you — your compatibility profile is complete.',
      );
      return true;
    } on ApiException catch (e) {
      error.value = e.message;
      return false;
    } catch (_) {
      error.value = 'Could not save your questionnaire.';
      return false;
    } finally {
      saving.value = false;
    }
  }
}
