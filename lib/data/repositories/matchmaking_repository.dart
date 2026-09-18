import '../../core/network/api_client.dart';
import '../models/match.dart';
import '../models/recommendation.dart';

class PagedResult<T> {
  final List<T> items;
  final int total;
  final int page;
  final int pages;
  final bool hasMore;

  const PagedResult({
    required this.items,
    this.total = 0,
    this.page = 1,
    this.pages = 1,
  }) : hasMore = false;

  const PagedResult.withMore({
    required this.items,
    required this.total,
    required this.page,
    required this.pages,
  }) : hasMore = page < pages;
}

class MatchmakingRepository {
  MatchmakingRepository(this._client);

  final ApiClient _client;

  Future<Match> calculateMatch(String partnerId) async {
    final json = await _client.post(
      '/matchmaking/calculate',
      body: {'partnerId': partnerId},
    );
    return Match.fromJson(Map<String, dynamic>.from(json['data'] as Map));
  }

  Future<PagedResult<Recommendation>> getRecommendations({
    int page = 1,
    int limit = 20,
    String? city,
    String? gender,
    String? relationshipGoal,
  }) async {
    final json = await _client.get(
      '/matchmaking/recommendations',
      query: {
        'page': page,
        'limit': limit,
        if (city != null && city.isNotEmpty) 'city': city,
        if (gender != null && gender.isNotEmpty) 'gender': gender,
        if (relationshipGoal != null && relationshipGoal.isNotEmpty)
          'relationshipGoal': relationshipGoal,
      },
    );
    return _parseRecommendations(json);
  }

  PagedResult<Recommendation> _parseRecommendations(dynamic json) {
    final data = json is Map && json['data'] is List ? json['data'] : const [];
    final pagination = json is Map && json['pagination'] is Map
        ? json['pagination'] as Map
        : const {};
    final items = <Recommendation>[
      for (final e in data.whereType<Map>())
        Recommendation.fromJson(Map<String, dynamic>.from(e)),
    ];
    return PagedResult.withMore(
      items: items,
      total: (pagination['total'] as num?)?.toInt() ?? items.length,
      page: (pagination['page'] as num?)?.toInt() ?? 1,
      pages: (pagination['pages'] as num?)?.toInt() ?? 1,
    );
  }

  Future<PagedResult<Match>> getMyMatches({
    int page = 1,
    int limit = 50,
  }) async {
    final json = await _client.get(
      '/matchmaking/my-matches',
      query: {'page': page, 'limit': limit},
    );
    final data = json is Map && json['data'] is List ? json['data'] : const [];
    final pagination = json is Map && json['pagination'] is Map
        ? json['pagination'] as Map
        : const {};
    final items = data
        .whereType<Map>()
        .map((e) => Match.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return PagedResult.withMore(
      items: items,
      total: (pagination['total'] as num?)?.toInt() ?? items.length,
      page: (pagination['page'] as num?)?.toInt() ?? 1,
      pages: (pagination['pages'] as num?)?.toInt() ?? 1,
    );
  }

  Future<Match> getMatch(String matchId) async {
    final json = await _client.get('/matchmaking/$matchId');
    return Match.fromJson(Map<String, dynamic>.from(json['data'] as Map));
  }
}
