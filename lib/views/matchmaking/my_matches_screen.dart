import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/animated_entrance.dart';
import '../../core/widgets/astro_avatar.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/score_ring.dart';
import '../../data/models/match.dart';
import '../../routes/app_routes.dart';
import '../../viewmodels/matchmaking_controller.dart';

class MyMatchesScreen extends GetView<MatchmakingController> {
  const MyMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: SectionHeader(
              title: 'Your matches',
              subtitle: 'Compatibility reports you\u2019ve calculated',
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.loadingMatches.value &&
                  controller.myMatches.isEmpty) {
                return const AstroLoading(message: 'Loading your matches…');
              }
              if (controller.myMatches.isEmpty) {
                return EmptyState(
                  icon: Icons.favorite_outline_rounded,
                  title: 'No matches yet',
                  message:
                      'Calculate compatibility with someone to see your reports here.',
                );
              }
              return RefreshIndicator(
                color: AppColors.brandOrange,
                onRefresh: controller.loadMatches,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  itemCount: controller.myMatches.length,
                  itemBuilder: (context, index) => AnimatedEntrance(
                    delay: Duration(milliseconds: index.clamp(0, 8) * 60),
                    beginOffset: const Offset(0, 0.06),
                    child: _matchTile(context, controller.myMatches[index]),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _matchTile(BuildContext context, Match match) {
    final theme = Theme.of(context);
    final partner =
        match.userB?.firstName ?? match.userA?.firstName ?? 'Your match';
    final hasId = match.id.isNotEmpty;
    return PressableScale(
      onTap: () {
        if (hasId) {
          Get.toNamed(AppRoutes.matchDetail, arguments: {'matchId': match.id});
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.night.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            AstroAvatar(name: partner, size: 52),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(partner, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    match.overallLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.brandOrangeDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (match.updatedAt != null)
                    Text(
                      'Calculated ${_timeAgo(match.updatedAt!)}',
                      style: theme.textTheme.labelSmall,
                    ),
                ],
              ),
            ),
            ScoreRing(score: match.score.toDouble(), size: 64, strokeWidth: 7),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 30) return '${diff.inDays}d ago';
    return 'long ago';
  }
}
