import 'package:get/get.dart';

import '../../core/network/api_client.dart';
import '../../data/repositories/astro_qa_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/horoscope_repository.dart';
import '../../data/repositories/matchmaking_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/questionnaire_repository.dart';
import '../../viewmodels/auth_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository(ApiClient.instance), permanent: true);
    Get.put(ProfileRepository(ApiClient.instance), permanent: true);
    Get.put(HoroscopeRepository(ApiClient.instance), permanent: true);
    Get.put(QuestionnaireRepository(ApiClient.instance), permanent: true);
    Get.put(MatchmakingRepository(ApiClient.instance), permanent: true);
    Get.put(AstroQaRepository(ApiClient.instance), permanent: true);
    Get.put(AuthController(Get.find<AuthRepository>()), permanent: true);
  }
}