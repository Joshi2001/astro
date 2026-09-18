import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/network/api_exceptions.dart';
import '../../data/models/match.dart';
import '../../data/models/recommendation.dart';
import '../../data/repositories/matchmaking_repository.dart';

class MatchmakingController extends GetxController {
  final _repository = Get.find<MatchmakingRepository>();

  final RxList<Recommendation> recommendations = RxList<Recommendation>([]);
  final RxList<Match> myMatches = RxList<Match>([]);

  final RxBool loadingRecommendations = RxBool(false);
  final RxBool loadingMatches = RxBool(false);
  final RxBool loadingMore = RxBool(false);
  final Rx<String?> error = Rx<String?>(null);

  final RxString filterCity = RxString('');
  final RxString filterGender = RxString('');
  final RxString filterGoal = RxString('');
  final RxInt page = RxInt(1);
  final RxInt pages = RxInt(1);

  bool get hasFilters =>
      filterCity.value.isNotEmpty ||
      filterGender.value.isNotEmpty ||
      filterGoal.value.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    loadMatches();
    loadRecommendations();
  }

  Future<void> loadRecommendations({bool reset = true}) async {
    if (reset) {
      loadingRecommendations.value = true;
      page.value = 1;
    } else {
      loadingMore.value = true;
    }
    error.value = null;
    try {
      final result = await _repository.getRecommendations(
        page: page.value,
        city: filterCity.value,
        gender: filterGender.value,
        relationshipGoal: filterGoal.value,
      );
      pages.value = result.pages;
      if (reset) {
        recommendations.assignAll(result.items);
      } else {
        recommendations.addAll(result.items);
      }
      if (!result.hasMore) pages.value = page.value;
    } on ApiException catch (e) {
      debugPrint('RECS_API_EXC ${e.message}');
      error.value = e.message;
    } catch (e, st) {
      debugPrint('RECS_EXC $e\n$st');
      error.value = 'Could not load recommendations.';
    } finally {
      loadingRecommendations.value = false;
      loadingMore.value = false;
    }
  }

  void loadMore() {
    if (!loadingMore.value && page.value < pages.value) {
      page.value++;
      loadRecommendations(reset: false);
    }
  }

  void applyFilters({String? city, String? gender, String? goal}) {
    filterCity.value = city ?? filterCity.value;
    filterGender.value = gender ?? filterGender.value;
    filterGoal.value = goal ?? filterGoal.value;
    loadRecommendations(reset: true);
  }

  void clearFilters() {
    filterCity.value = '';
    filterGender.value = '';
    filterGoal.value = '';
    loadRecommendations(reset: true);
  }

  Future<void> loadMatches() async {
    loadingMatches.value = true;
    try {
      final result = await _repository.getMyMatches();
      myMatches.assignAll(result.items);
    } on ApiException catch (e) {
      error.value = e.message;
    } catch (_) {
      error.value = 'Could not load your matches.';
    } finally {
      loadingMatches.value = false;
    }
  }
}
