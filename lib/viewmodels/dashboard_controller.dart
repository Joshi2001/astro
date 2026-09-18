import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/network/api_exceptions.dart';
import '../../data/models/horoscope.dart';
import '../../data/models/match.dart';
import '../../data/models/profile.dart';
import '../../data/models/questionnaire.dart';
import '../../data/models/recommendation.dart';
import '../../data/models/user.dart';
import '../../data/repositories/horoscope_repository.dart';
import '../../data/repositories/matchmaking_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/questionnaire_repository.dart';
import 'auth_controller.dart';

class DashboardController extends GetxController {
  final _auth = Get.find<AuthController>();

  final RxBool loading = RxBool(true);
  final Rx<String?> error = Rx<String?>(null);
  final Rx<Profile?> profile = Rx<Profile?>(null);
  final Rx<Horoscope?> horoscope = Rx<Horoscope?>(null);
  final Rx<Questionnaire?> questionnaire = Rx<Questionnaire?>(null);
  final RxList<Match> recentMatches = RxList<Match>([]);
  final RxList<Recommendation> recommendations = RxList<Recommendation>([]);

  User? get user => _auth.user.value;

  bool get hasProfile => profile.value?.profileCompleted ?? false;
  bool get hasHoroscope => horoscope.value != null && horoscope.value!.hasChart;
  bool get hasQuestionnaire => questionnaire.value?.isComplete ?? false;

  int get setupCompleteCount =>
      [hasProfile, hasHoroscope, hasQuestionnaire].where((v) => v).length;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load({bool silent = false}) async {
    if (!silent) loading.value = true;
    error.value = null;
    try {
      final results = await Future.wait([
        _fetchOrNull(() => Get.find<ProfileRepository>().getMyProfile()),
        _fetchOrNull(() => Get.find<HoroscopeRepository>().getMyHoroscope()),
        _fetchOrNull(
          () => Get.find<QuestionnaireRepository>().getMyQuestionnaire(),
        ),
        _fetchMatches(),
        _fetchRecommendations(),
      ]);
      profile.value = results[0] as Profile?;
      horoscope.value = results[1] as Horoscope?;
      questionnaire.value = results[2] as Questionnaire?;
      recentMatches.assignAll(
        List<Match>.from(results[3] as List? ?? const []).take(3),
      );
      recommendations.assignAll(
        List<Recommendation>.from(results[4] as List? ?? const []).take(6),
      );
    } on ApiException catch (e) {
      error.value = e.message;
    } catch (e, st) {
      debugPrint('DASH_EXC $e\n$st');
      error.value = 'Could not load your dashboard.';
    } finally {
      loading.value = false;
    }
  }

  Future<Object?> _fetchOrNull(Future<Object?> Function() fetch) async {
    try {
      return await fetch();
    } catch (_) {
      return null;
    }
  }

  Future<List<Match>> _fetchMatches() async {
    try {
      final result = await Get.find<MatchmakingRepository>().getMyMatches();
      return result.items;
    } catch (_) {
      return const [];
    }
  }

  Future<List<Recommendation>> _fetchRecommendations() async {
    try {
      final result =
          await Get.find<MatchmakingRepository>().getRecommendations();
      return result.items;
    } catch (_) {
      return const [];
    }
  }
}
