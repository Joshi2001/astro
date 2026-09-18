import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/animated_entrance.dart';
import '../../core/widgets/astro_avatar.dart';
import '../../data/models/user.dart';
import '../../routes/app_routes.dart';
import '../../viewmodels/auth_controller.dart';
import '../../viewmodels/dashboard_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        final auth = Get.find<AuthController>();
        final dashboard = Get.find<DashboardController>();
        final user = auth.user.value;
        if (user == null) return const SizedBox.shrink();
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            AnimatedEntrance(child: _header(context, user)),
            const SizedBox(height: 24),
            AnimatedEntrance(
              delay: const Duration(milliseconds: 120),
              child: _detailsCard(context, dashboard),
            ),
            const SizedBox(height: 24),
            AnimatedEntrance(
              delay: const Duration(milliseconds: 220),
              child: _links(context, dashboard),
            ),
            const SizedBox(height: 28),
            AnimatedEntrance(
              delay: const Duration(milliseconds: 300),
              child: _logout(context, auth),
            ),
          ],
        );
      }),
    );
  }

  Widget _header(BuildContext context, User user) {
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
      child: Row(
        children: [
          AstroAvatar(name: user.name, size: 64),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    user.genderLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailsCard(BuildContext context, DashboardController controller) {
    final theme = Theme.of(context);
    final profile = controller.profile.value;
    final rows = <(String, String, IconData)>[
      ('Current city', profile?.currentCity ?? '—', Icons.location_on_outlined),
      ('Occupation', profile?.occupation ?? '—', Icons.work_outline_rounded),
      ('Education', profile?.education ?? '—', Icons.school_outlined),
      (
        'Relationship goal',
        profile?.relationshipGoalLabel ?? '—',
        Icons.favorite_border_rounded,
      ),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('About me', style: theme.textTheme.titleMedium),
            if ((profile?.about ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                profile!.about,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
            ],
            const Divider(),
            const SizedBox(height: 4),
            for (final row in rows) ...[
              _infoRow(context, row.$1, row.$2, row.$3),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.brandOrange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: AppColors.brandOrangeDark, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme.textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(label, style: theme.textTheme.labelSmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _links(BuildContext context, DashboardController controller) {
    return Column(
      children: [
        _linkTile(
          context: context,
          icon: Icons.badge_outlined,
          title: 'Edit personal profile',
          trailing: controller.hasProfile ? 'Done' : 'Pending',
          done: controller.hasProfile,
          onTap: () => Get.toNamed(AppRoutes.profileEdit),
        ),
        const SizedBox(height: 10),
        _linkTile(
          context: context,
          icon: Icons.nightlight_round,
          title: 'Birth chart & horoscope',
          trailing: controller.hasHoroscope ? 'Done' : 'Pending',
          done: controller.hasHoroscope,
          onTap: () => Get.toNamed(AppRoutes.horoscope),
        ),
        const SizedBox(height: 10),
        _linkTile(
          context: context,
          icon: Icons.quiz_outlined,
          title: 'Compatibility questionnaire',
          trailing: controller.hasQuestionnaire ? 'Done' : 'Pending',
          done: controller.hasQuestionnaire,
          onTap: () => Get.toNamed(AppRoutes.questionnaire),
        ),
      ],
    );
  }

  Widget _linkTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String trailing,
    required bool done,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(child: Text(title, style: theme.textTheme.titleSmall)),
              Text(
                trailing,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: done ? AppColors.success : AppColors.warning,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logout(BuildContext context, AuthController auth) {
    return GestureDetector(
      onTap: () => Get.dialog(
        AlertDialog(
          title: const Text('Log out'),
          content: const Text('Are you sure you want to log out of Astro?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            FilledButton(onPressed: auth.logout, child: const Text('Log out')),
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFB3261E).withValues(alpha: 0.2),
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.logout_rounded,
              color: Color(0xFFB3261E),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Log out',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: const Color(0xFFB3261E)),
            ),
          ],
        ),
      ),
    );
  }
}
