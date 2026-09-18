import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/animated_entrance.dart';
import '../../core/widgets/astro_avatar.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/score_ring.dart';
import '../../data/models/recommendation.dart';
import '../../routes/app_routes.dart';
import '../../viewmodels/matchmaking_controller.dart';

class RecommendationsScreen extends GetView<MatchmakingController> {
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Row(
              children: [
                Expanded(
                  child: SectionHeader(
                    title: 'Discover',
                    subtitle: 'Astrologically matched people near you',
                  ),
                ),
                GestureDetector(
                  onTap: () => _openFilters(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: controller.hasFilters
                            ? AppColors.brandOrange
                            : const Color(0xFFEFE6F3),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.tune_rounded,
                      color: controller.hasFilters
                          ? AppColors.brandOrangeDark
                          : AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (controller.hasFilters)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: _activeFilters(context),
            ),
          Expanded(
            child: Obx(() {
              if (controller.loadingRecommendations.value &&
                  controller.recommendations.isEmpty) {
                return const AstroLoading(message: 'Finding cosmic matches…');
              }
              if (controller.recommendations.isEmpty) {
                return EmptyState(
                  icon: Icons.explore_outlined,
                  title: 'No matches found',
                  message:
                      'Complete your profile and questionnaire to see your cosmic matches.',
                  action: GradientButton(
                    label: 'Refresh',
                    icon: Icons.refresh_rounded,
                    onPressed: () => controller.loadRecommendations(),
                  ),
                );
              }
              return RefreshIndicator(
                color: AppColors.brandOrange,
                onRefresh: () => controller.loadRecommendations(),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: ScrollController(),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  itemCount: controller.recommendations.length,
                  itemBuilder: (context, index) {
                    final rec = controller.recommendations[index];
                    if (index == controller.recommendations.length - 1) {
                      controller.loadMore();
                    }
                    return AnimatedEntrance(
                      delay: Duration(milliseconds: index.clamp(0, 8) * 60),
                      beginOffset: const Offset(0, 0.06),
                      child: _recommendationCard(context, rec),
                    );
                  },
                ),
              );
            }),
          ),
          if (controller.loadingMore.value)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
            ),
        ],
      ),
    );
  }

  Widget _activeFilters(BuildContext context) {
    return Obx(() {
      final values = <String>[
        if (controller.filterCity.value.isNotEmpty) controller.filterCity.value,
        if (controller.filterGender.value.isNotEmpty)
          controller.filterGender.value.capitalizeFirst ??
              controller.filterGender.value,
        if (controller.filterGoal.value.isNotEmpty)
          controller.filterGoal.value.replaceAll('_', ' ').capitalizeFirst ??
              controller.filterGoal.value,
      ];
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final v in values)
            Chip(
              label: Text(v),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: controller.clearFilters,
            ),
          TextButton(
            onPressed: controller.clearFilters,
            child: const Text('Clear all'),
          ),
        ],
      );
    });
  }

  Widget _recommendationCard(BuildContext context, Recommendation rec) {
    final theme = Theme.of(context);
    final match = rec.match;
    return PressableScale(
      onTap: () => Get.toNamed(
        AppRoutes.matchDetail,
        arguments: {'partnerId': rec.user.id, 'recommendation': true},
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.night.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AstroAvatar(name: rec.user.name, size: 54),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rec.user.name,
                        style: theme.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        [
                          if (rec.city.isNotEmpty) rec.city,
                          if (rec.occupation.isNotEmpty) rec.occupation,
                        ].join(' • '),
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _miniChip(
                            context,
                            rec.relationshipGoalLabel,
                            Icons.favorite_rounded,
                          ),
                          _miniChip(
                            context,
                            match.overallLabel,
                            Icons.auto_awesome_rounded,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ScoreRing(
                  score: match.score.toDouble(),
                  size: 68,
                  strokeWidth: 7,
                ),
              ],
            ),
            if (rec.about.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                rec.about,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (match.strengths.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                'Compatibility strengths',
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final s in match.strengths.take(3))
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.brandOrange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        s,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.brandOrangeDark,
                        ),
                      ),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            GradientButton(
              label: 'View compatibility',
              icon: Icons.favorite_border_rounded,
              expanded: true,
              onPressed: () => Get.toNamed(
                AppRoutes.matchDetail,
                arguments: {'partnerId': rec.user.id, 'recommendation': true},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniChip(BuildContext context, String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.brandOrangeDark),
          const SizedBox(width: 4),
          Text(text, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }

  void _openFilters(BuildContext context) {
    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setSheetState) {
          var gender = controller.filterGender.value;
          var goal = controller.filterGoal.value;
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter matches',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: TextEditingController(
                      text: controller.filterCity.value,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'City',
                      prefixIcon: Icon(
                        Icons.location_on_outlined,
                        color: AppColors.brandOrange,
                      ),
                    ),
                    onChanged: (value) => controller.filterCity.value = value,
                  ),
                  const SizedBox(height: 18),
                  Text('Gender', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      for (final option in const [
                        '',
                        'male',
                        'female',
                        'other',
                      ])
                        ChoiceChip(
                          label: Text(
                            option.isEmpty ? 'Any' : option.capitalize!,
                          ),
                          selected: gender == option,
                          onSelected: (_) =>
                              setSheetState(() => gender = option),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Relationship goal',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      for (final option in const [
                        ('', 'Any'),
                        ('marriage', 'Marriage'),
                        ('serious_relationship', 'Serious'),
                        ('long_term_relationship', 'Long-term'),
                        ('not_sure', 'Exploring'),
                      ])
                        ChoiceChip(
                          label: Text(option.$2),
                          selected: goal == option.$1,
                          onSelected: (_) =>
                              setSheetState(() => goal = option.$1),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            controller.clearFilters();
                            Get.back();
                          },
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: GradientButton(
                          label: 'Apply filters',
                          onPressed: () {
                            controller.applyFilters(
                              city: controller.filterCity.value,
                              gender: gender,
                              goal: goal,
                            );
                            Get.back();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
