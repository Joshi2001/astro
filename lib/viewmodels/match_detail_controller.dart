import 'package:get/get.dart';

import '../../core/network/api_exceptions.dart';
import '../../data/models/match.dart';
import '../../data/repositories/matchmaking_repository.dart';

class MatchDetailController extends GetxController {
  final _repository = Get.find<MatchmakingRepository>();

  final Rx<Match?> match = Rx<Match?>(null);
  final RxBool loading = RxBool(true);
  final Rx<String?> error = Rx<String?>(null);

  String? _matchId;
  String? _partnerId;
  bool _fromRecommendation = false;

  String get partnerName => match.value?.userB?.name ?? 'Your match';

  String? get partnerId => match.value?.userB?.id ?? _partnerId;

  void setup({
    String? matchId,
    String? partnerId,
    bool fromRecommendation = false,
  }) {
    _matchId = matchId;
    _partnerId = partnerId;
    _fromRecommendation = fromRecommendation;
  }

  @override
  void onReady() {
    super.onReady();
    if (_fromRecommendation) {
      calculate();
    } else if (_matchId != null) {
      fetchDetail();
    } else {
      calculate();
    }
  }

  Future<void> fetchDetail() async {
    loading.value = true;
    error.value = null;
    try {
      match.value = await _repository.getMatch(_matchId!);
    } on ApiException catch (e) {
      error.value = e.message;
    } catch (_) {
      error.value = 'Could not load this match.';
    } finally {
      loading.value = false;
    }
  }

  Future<void> calculate() async {
    loading.value = true;
    error.value = null;
    try {
      match.value = await _repository.calculateMatch(_partnerId!);
    } on ApiException catch (e) {
      error.value = e.message;
    } catch (_) {
      error.value = 'Could not calculate compatibility.';
    } finally {
      loading.value = false;
    }
  }
}
