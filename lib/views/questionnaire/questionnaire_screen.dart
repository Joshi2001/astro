import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/animated_entrance.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/gradient_button.dart';
import '../../data/models/questionnaire_meta.dart';
import '../../viewmodels/questionnaire_controller.dart';

class QuestionnaireScreen extends GetView<QuestionnaireController> {
  const QuestionnaireScreen({super.key});

  static const Map<String, IconData> categoryIcons = {
    'Personality': Icons.psychology_outlined,
    'Emotions & Support': Icons.favorite_outline_rounded,
    'Communication': Icons.forum_outlined,
    'Trust & Commitment': Icons.shield_outlined,
    'Lifestyle & Routine': Icons.light_mode_outlined,
    'Career & Money': Icons.trending_up_rounded,
    'Family': Icons.family_restroom_rounded,
    'Relationship Vision': Icons.visibility_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compatibility questionnaire'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${controller.answered} of ${controller.total} answered',
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                    if (controller.isComplete)
                      Text(
                        'Complete',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Obx(
                  () => ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: controller.progress,
                      minHeight: 8,
                      backgroundColor: AppColors.brandOrange.withValues(
                        alpha: 0.14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const AstroLoading(message: 'Loading your answers…');
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
          children: [
            for (final category in QuestionnaireMeta.categories) ...[
              AnimatedEntrance(
                delay: const Duration(milliseconds: 100),
                child: _categoryHeader(context, category),
              ),
              for (
                var index = 0;
                index <
                    QuestionnaireMeta.fields
                        .where((f) => f.category == category)
                        .length;
                index++
              )
                AnimatedEntrance(
                  delay: Duration(milliseconds: 160 + index * 60),
                  beginOffset: const Offset(0, 0.05),
                  child: _questionCard(
                    context,
                    QuestionnaireMeta.fields
                        .where((f) => f.category == category)
                        .elementAt(index),
                  ),
                ),
              const SizedBox(height: 10),
            ],
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.loading.value) return const SizedBox.shrink();
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
            child: GradientButton(
              label: controller.saving.value ? 'Saving…' : 'Save questionnaire',
              icon: Icons.check_rounded,
              loading: controller.saving.value,
              onPressed: controller.save,
            ),
          ),
        );
      }),
    );
  }

  Widget _categoryHeader(BuildContext context, String category) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 12),
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
            child: Icon(categoryIcons[category], color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Text(category, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _questionCard(BuildContext context, QuestionnaireField field) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0E7F4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.question,
            style: theme.textTheme.titleSmall?.copyWith(height: 1.35),
          ),
          const SizedBox(height: 12),
          for (final option in field.options)
            _optionTile(context, field, option),
        ],
      ),
    );
  }

  Widget _optionTile(
    BuildContext context,
    QuestionnaireField field,
    String option,
  ) {
    final theme = Theme.of(context);
    final selected = controller.answerFor(field.key) == option;
    return GestureDetector(
      onTap: () => controller.select(field.key, option),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.brandGradient : null,
          color: selected ? null : AppColors.canvas,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? Colors.transparent : const Color(0xFFEFE6F3),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.brandPink.withValues(alpha: 0.22),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? Colors.white : Colors.transparent,
                border: Border.all(
                  color: selected ? Colors.white : AppColors.textHint,
                  width: 1.6,
                ),
              ),
              alignment: Alignment.center,
              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 15,
                      color: AppColors.brandPink,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: selected ? Colors.white : AppColors.textPrimary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
