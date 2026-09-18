import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/animated_entrance.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/gradient_button.dart';
import '../../viewmodels/profile_controller.dart';

class ProfileEditScreen extends GetView<ProfileController> {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Personal profile')),
      body: Obx(() {
        if (controller.loading.value) {
          return const AstroLoading(message: 'Loading your profile…');
        }
        return Form(
          key: controller.formKey,
          child: AnimatedEntrance(
            beginOffset: const Offset(0, 0.04),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                _datePicker(context),
                const SizedBox(height: 16),
                _textField(
                  controller: controller.currentCity,
                  label: 'Current city',
                  hint: 'e.g. Mumbai',
                  icon: Icons.location_on_outlined,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'City is required'
                      : null,
                ),
                const SizedBox(height: 16),
                _textField(
                  controller: controller.occupation,
                  label: 'Occupation',
                  hint: 'e.g. Software Engineer',
                  icon: Icons.work_outline_rounded,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Occupation is required'
                      : null,
                ),
                const SizedBox(height: 16),
                _textField(
                  controller: controller.education,
                  label: 'Education',
                  hint: 'e.g. B.Tech, Computer Science',
                  icon: Icons.school_outlined,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Education is required'
                      : null,
                ),
                const SizedBox(height: 20),
                Text('Relationship goal', style: theme.textTheme.titleSmall),
                const SizedBox(height: 10),
                Obx(
                  () => Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final entry
                          in ProfileController.relationshipGoals.entries)
                        ChoiceChip(
                          label: Text(entry.value),
                          selected:
                              controller.relationshipGoal.value == entry.key,
                          onSelected: (_) =>
                              controller.relationshipGoal.value = entry.key,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: controller.about,
                  maxLines: 4,
                  maxLength: 1000,
                  decoration: const InputDecoration(
                    labelText: 'About me',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() {
                  final error = controller.error.value;
                  if (error == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      error,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFFB3261E),
                      ),
                    ),
                  );
                }),
                Obx(
                  () => GradientButton(
                    label: 'Save profile',
                    icon: Icons.check_rounded,
                    loading: controller.saving.value,
                    onPressed: controller.save,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _datePicker(BuildContext context) {
    return Obx(() {
      final dob = controller.dateOfBirth.value;
      return GestureDetector(
        onTap: () => _pickDate(context),
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Date of birth',
            prefixIcon: Icon(Icons.cake_outlined, color: AppColors.brandOrange),
          ),
          child: Text(
            dob == null
                ? 'Choose your date of birth'
                : DateFormat('d MMM yyyy').format(dob),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: dob == null ? AppColors.textHint : AppColors.textPrimary,
            ),
          ),
        ),
      );
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.dateOfBirth.value ?? DateTime(now.year - 28),
      firstDate: DateTime(now.year - 90),
      lastDate: now,
    );
    if (picked != null) controller.dateOfBirth.value = picked;
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.brandOrange),
      ),
    );
  }
}
