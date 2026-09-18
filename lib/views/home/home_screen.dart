import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/animated_entrance.dart';
import '../../core/widgets/astro_avatar.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/score_ring.dart';
import '../../data/models/horoscope.dart';
import '../../data/models/match.dart';
import '../../data/models/recommendation.dart';
import '../../routes/app_routes.dart';
import '../../viewmodels/dashboard_controller.dart';
import '../../viewmodels/main_tab_controller.dart';

class HomeScreen extends GetView<DashboardController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.brandOrange,
        onRefresh: () => controller.load(silent: true),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverToBoxAdapter(
                child: AnimatedEntrance(child: _header(context)),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              sliver: SliverToBoxAdapter(
                child: AnimatedEntrance(
                  delay: const Duration(milliseconds: 120),
                  child: _setupCard(context),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              sliver: SliverToBoxAdapter(
                child: AnimatedEntrance(
                  delay: const Duration(milliseconds: 240),
                  child: _astroCard(context),
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(top: 28),
              sliver: SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Recent matches',
                  subtitle: 'Your latest compatibility reports',
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              sliver: _recentMatches(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final theme = Theme.of(context);
    final user = controller.user;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Namaste, ${user?.firstName ?? 'there'}',
                style: theme.textTheme.headlineMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Your cosmic dashboard awaits.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: controller.user == null
              ? null
              : MainTabController.to.goToProfile,
          child: AstroAvatar(name: user?.name, size: 48),
        ),
      ],
    );
  }

  Widget _setupCard(BuildContext context) {
    if (controller.setupCompleteCount == 3) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: AppColors.nightGradient,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandPink.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Complete your cosmic profile',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${controller.setupCompleteCount} of 3 done — unlock recommendations and matches.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 14),
            _stepTile(
              context,
              icon: Icons.badge_outlined,
              title: 'Personal profile',
              done: controller.hasProfile,
              onTap: () => Get.toNamed(AppRoutes.profileEdit),
            ),
            const SizedBox(height: 10),
            _stepTile(
              context,
              icon: Icons.nightlight_round,
              title: 'Birth chart & horoscope',
              done: controller.hasHoroscope,
              onTap: () => Get.toNamed(AppRoutes.horoscope),
            ),
            const SizedBox(height: 10),
            _stepTile(
              context,
              icon: Icons.favorite_outline_rounded,
              title: 'Compatibility questionnaire',
              done: controller.hasQuestionnaire,
              onTap: () => Get.toNamed(AppRoutes.questionnaire),
            ),
          ],
        ),
      );
    });
  }

  Widget _stepTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool done,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.white.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              if (done)
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 22,
                )
              else
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white70,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _astroCard(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      final horoscope = controller.horoscope.value;
      if (horoscope == null || !horoscope.hasChart) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.brandPink.withValues(alpha: 0.3),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.nightlight_round, color: Colors.white, size: 32),
              const SizedBox(height: 12),
              Text(
                'Reveal your birth chart',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Add your birth details and let the planets tell your story.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.horoscope),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'Add birth details',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.brandOrangeDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return _chartCard(context, theme, horoscope);
    });
  }

  Widget _chartCard(
    BuildContext context,
    ThemeData theme,
    Horoscope horoscope,
  ) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.horoscope),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.nightGradient,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandPink.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.nightlight_round,
                  color: Colors.white,
                  size: 26,
                ),
                const SizedBox(width: 10),
                Text(
                  'Your Birth Chart',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right_rounded, color: Colors.white70),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _chartStat(
                    context,
                    label: 'Sun sign',
                    value: horoscope.sunSign ?? 'Unknown',
                    icon: Icons.wb_sunny_outlined,
                  ),
                ),
                Expanded(
                  child: _chartStat(
                    context,
                    label: 'Moon sign',
                    value:
                        horoscope.calculatedMoonSign ??
                        horoscope.moonSign ??
                        'Unknown',
                    icon: Icons.brightness_2_outlined,
                  ),
                ),
                Expanded(
                  child: _chartStat(
                    context,
                    label: 'Nakshatra',
                    value: horoscope.nakshatra ?? '—',
                    icon: Icons.star_outline_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chartStat(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 26),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _recentMatches(BuildContext context) {
    return Obx(() {
      if (controller.recentMatches.isNotEmpty) {
        return SliverList.builder(
          itemCount: controller.recentMatches.length + 1,
          itemBuilder: (context, index) {
            if (index == controller.recentMatches.length) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: TextButton.icon(
                    onPressed: MainTabController.to.goToMatches,
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    label: const Text('View all matches'),
                  ),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _matchCard(context, controller.recentMatches[index]),
            );
          },
        );
      }

      if (controller.recommendations.isNotEmpty) {
        return SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Text(
                  'Recommended for you',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            SliverList.builder(
              itemCount: controller.recommendations.length + 1,
              itemBuilder: (context, index) {
                if (index == controller.recommendations.length) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: TextButton.icon(
                        onPressed: MainTabController.to.goToDiscover,
                        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                        label: const Text('View all in Discover'),
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _recommendationCard(
                    context,
                    controller.recommendations[index],
                  ),
                );
              },
            ),
          ],
        );
      }

      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: EmptyState(
            icon: Icons.favorite_outline_rounded,
            title: 'No matches yet',
            message:
                'Complete your profile and questionnaire to get love compatibility reports.',
            action: GradientButtonWidget(
              label: 'Discover people',
              onPressed: MainTabController.to.goToDiscover,
            ),
          ),
        ),
      );
    });
  }

  Widget _recommendationCard(BuildContext context, Recommendation rec) {
    final theme = Theme.of(context);
    final partner = rec.user.name.isNotEmpty ? rec.user.name : 'Your match';
    final subtitle = [
      if (rec.city.isNotEmpty) rec.city,
      if (rec.occupation.isNotEmpty) rec.occupation,
    ].join(' · ');
    return PressableScale(
      onTap: () => MainTabController.to.goToDiscover,
      child: Container(
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
            AstroAvatar(name: partner, size: 48),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(partner, style: theme.textTheme.titleMedium),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            ScoreRing(
              score: rec.match.score.toDouble(),
              size: 64,
              strokeWidth: 7,
            ),
          ],
        ),
      ),
    );
  }

  Widget _matchCard(BuildContext context, Match match) {
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
            AstroAvatar(name: partner, size: 48),
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
                ],
              ),
            ),
            ScoreRing(score: match.score.toDouble(), size: 64, strokeWidth: 7),
          ],
        ),
      ),
    );
  }
}

class GradientButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const GradientButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandPink.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
