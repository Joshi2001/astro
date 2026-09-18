import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/animated_entrance.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/score_ring.dart';
import '../../data/models/match.dart';
import '../../viewmodels/astro_qa_controller.dart';
import '../../viewmodels/main_tab_controller.dart';
import '../../viewmodels/match_detail_controller.dart';

class MatchDetailScreen extends GetView<MatchDetailController> {
  const MatchDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(controller.partnerName)),
      body: Obx(() {
        if (controller.loading.value) {
          return const AstroLoading(message: 'Consulting the stars…');
        }
        final error = controller.error.value;
        if (error != null) {
          return EmptyState(
            icon: Icons.cloud_off_outlined,
            title: 'Could not load the report',
            message: error,
            action: GradientButton(
              label: 'Try again',
              icon: Icons.refresh_rounded,
              onPressed: _isRecommendation
                  ? controller.calculate
                  : controller.fetchDetail,
            ),
          );
        }
        final match = controller.match.value;
        if (match == null) {
          return const AstroLoading(message: 'Consulting the stars…');
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            AnimatedEntrance(child: _heroCard(context, match)),
            if (match.overallConclusion.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                match.overallConclusion,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.55,
                ),
              ),
            ],
            const SizedBox(height: 28),
            if (match.astrology != null) ...[
              _astrologyCard(context, match.astrology!),
              const SizedBox(height: 24),
            ],
            const SectionHeader(
              title: 'Compatibility breakdown',
              subtitle: 'How you align in each area',
            ),
            const SizedBox(height: 14),
            for (final entry in match.categoriesOrdered)
              _categoryCard(context, entry.key, entry.value),
            const SizedBox(height: 20),
            if (match.strengths.isNotEmpty) ...[
              _listCard(
                context,
                'Strengths',
                match.strengths,
                Icons.thumb_up_outlined,
                AppColors.success,
              ),
              const SizedBox(height: 12),
            ],
            if (match.potentialChallenges.isNotEmpty) ...[
              _listCard(
                context,
                'Growth areas',
                match.potentialChallenges,
                Icons.lightbulb_outline_rounded,
                AppColors.warning,
              ),
              const SizedBox(height: 12),
            ],
            if (match.recommendations.isNotEmpty) ...[
              _listCard(
                context,
                'Recommendations',
                match.recommendations,
                Icons.auto_awesome_rounded,
                AppColors.brandOrangeDark,
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 12),
            _askAstro(context, match),
          ],
        );
      }),
    );
  }

  bool get _isRecommendation =>
      Get.arguments is Map<String, dynamic> &&
      Get.arguments['recommendation'] == true;

  Widget _heroCard(BuildContext context, Match match) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.nightGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandPink.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Compatibility',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      match.overallLabel,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      controller.partnerName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.brandOrange,
                      ),
                    ),
                  ],
                ),
              ),
              ScoreRing(
                score: match.score.toDouble(),
                size: 92,
                strokeWidth: 11,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Divider(color: Colors.white.withValues(alpha: 0.14)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.insights_rounded,
                color: AppColors.starGold,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Overall score ${match.score}% — a cosmic read on your connection.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _categoryCard(
    BuildContext context,
    String key,
    MatchCategory category,
  ) {
    final theme = Theme.of(context);
    final percent = (category.score * 100).round();
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    Match.categoryTitle(key),
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                LevelBadge(level: category.level),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: category.score),
                duration: const Duration(milliseconds: 700),
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value.clamp(0, 1),
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(6),
                  backgroundColor: AppColors.brandOrange.withValues(
                    alpha: 0.14,
                  ),
                  valueColor: AlwaysStoppedAnimation<Color>(_barColor(percent)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '$percent%',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: _barColor(percent),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    category.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _barColor(int percent) {
    if (percent >= 75) return AppColors.success;
    if (percent >= 50) return AppColors.brandOrange;
    if (percent >= 35) return AppColors.warning;
    return AppColors.brandRed;
  }

  Widget _astrologyCard(BuildContext context, MatchAstrology astrology) {
    final theme = Theme.of(context);
    final percent = (astrology.score * 100).round();
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.starGold,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Astrological compatibility',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                '$percent%',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.brandOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            astrology.description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.55,
            ),
          ),
          if (astrology.details.isNotEmpty) ...[
            const SizedBox(height: 12),
            for (final detail in astrology.details.take(4))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Icon(
                        Icons.circle,
                        size: 6,
                        color: AppColors.brandOrange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        detail,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _listCard(
    BuildContext context,
    String title,
    List<String> items,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(title, style: theme.textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 12),
            for (final item in items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Icon(Icons.circle, size: 6, color: color),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _askAstro(BuildContext context, Match match) {
    final theme = Theme.of(context);
    if (controller.partnerId == null) return const SizedBox.shrink();
    return GestureDetector(
      onTap: () {
        Get.find<AstroQaController>().askAbout(controller.partnerName);
        MainTabController.to.goToAstro();
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandPink.withValues(alpha: 0.28),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.chat_bubble_outline_rounded,
              color: Colors.white,
              size: 26,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ask Astro about this match',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Get a personalised Vedic reading for you and ${controller.partnerName}.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
