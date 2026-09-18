import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/network/api_exceptions.dart';
import '../../data/models/profile.dart';
import '../../data/repositories/profile_repository.dart';

class ProfileController extends GetxController {
  final _repository = Get.find<ProfileRepository>();

  final formKey = GlobalKey<FormState>();

  final Rx<DateTime?> dateOfBirth = Rx<DateTime?>(null);
  final currentCity = TextEditingController();
  final occupation = TextEditingController();
  final education = TextEditingController();
  final about = TextEditingController();
  final RxString relationshipGoal = RxString('marriage');

  final RxBool loading = RxBool(false);
  final RxBool saving = RxBool(false);
  final Rx<String?> error = Rx<String?>(null);
  final RxBool existing = RxBool(false);

  static const Map<String, String> relationshipGoals = {
    'marriage': 'Marriage',
    'serious_relationship': 'Serious relationship',
    'long_term_relationship': 'Long-term relationship',
    'not_sure': 'Still exploring',
  };

  @override
  void onInit() {
    super.onInit();
    loadExisting();
  }

  @override
  void onClose() {
    currentCity.dispose();
    occupation.dispose();
    education.dispose();
    about.dispose();
    super.onClose();
  }

  Future<void> loadExisting() async {
    loading.value = true;
    error.value = null;
    try {
      final profile = await _repository.getMyProfile();
      if (profile != null) {
        existing.value = true;
        dateOfBirth.value = profile.dateOfBirth;
        currentCity.text = profile.currentCity;
        occupation.text = profile.occupation;
        education.text = profile.education;
        relationshipGoal.value = profile.relationshipGoal.isEmpty
            ? 'marriage'
            : profile.relationshipGoal;
        about.text = profile.about;
      }
    } on ApiException catch (e) {
      if (!e.isUnauthorized) error.value = e.message;
    } catch (_) {
      error.value = 'Could not load your profile.';
    } finally {
      loading.value = false;
    }
  }

  Future<bool> save() async {
    if (!formKey.currentState!.validate()) return false;
    final dob = dateOfBirth.value;
    if (dob == null) {
      Get.snackbar('Date of birth', 'Please choose your date of birth.');
      return false;
    }
    final profile = Profile(
      dateOfBirth: dob,
      currentCity: currentCity.text.trim(),
      occupation: occupation.text.trim(),
      education: education.text.trim(),
      relationshipGoal: relationshipGoal.value,
      about: about.text.trim(),
    );
    saving.value = true;
    error.value = null;
    try {
      if (existing.value) {
        await _repository.updateProfile(profile);
      } else {
        await _repository.createProfile(profile);
        existing.value = true;
      }
      Get.back();
      Get.snackbar('Profile saved', 'Your profile has been updated.');
      return true;
    } on ApiException catch (e) {
      error.value = e.message;
      return false;
    } catch (_) {
      error.value = 'Could not save your profile.';
      return false;
    } finally {
      saving.value = false;
    }
  }
}
