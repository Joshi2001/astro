import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/network/api_exceptions.dart';
import '../../data/models/horoscope.dart';
import '../../data/repositories/horoscope_repository.dart';

class HoroscopeController extends GetxController {
  final _repository = Get.find<HoroscopeRepository>();

  final formKey = GlobalKey<FormState>();

  final Rx<DateTime?> dateOfBirth = Rx<DateTime?>(null);
  final RxString timeOfBirth = RxString('');
  final placeOfBirth = TextEditingController();
  final RxInt timeZoneOffsetMinutes = RxInt(-300);

  final Rx<Horoscope?> chart = Rx<Horoscope?>(null);
  final RxBool loading = RxBool(false);
  final RxBool saving = RxBool(false);
  final Rx<String?> error = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadExisting();
  }

  @override
  void onClose() {
    placeOfBirth.dispose();
    super.onClose();
  }

  Future<void> loadExisting() async {
    loading.value = true;
    error.value = null;
    try {
      final h = await _repository.getMyHoroscope();
      if (h != null) {
        chart.value = h;
        dateOfBirth.value = h.dateOfBirth;
        timeOfBirth.value = h.timeOfBirth;
        placeOfBirth.text = h.placeOfBirth;
        timeZoneOffsetMinutes.value = h.timeZoneOffsetMinutes ?? -300;
      }
    } on ApiException catch (e) {
      if (!e.isUnauthorized) error.value = e.message;
    } catch (_) {
      error.value = 'Could not load your horoscope.';
    } finally {
      loading.value = false;
    }
  }

  void pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate:
          dateOfBirth.value ?? DateTime(now.year - 28, now.month, now.day),
      firstDate: DateTime(now.year - 90),
      lastDate: now,
      helpText: 'Select birth date',
    );
    if (picked != null) {
      dateOfBirth.value = picked;
      if (timeOfBirth.value.isEmpty) timeOfBirth.value = '09:00';
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final pattern = RegExp(r'^(\d{2}):(\d{2})$');
    TimeOfDay initial = const TimeOfDay(hour: 9, minute: 0);
    final match = pattern.firstMatch(timeOfBirth.value);
    if (match != null) {
      initial = TimeOfDay(
        hour: int.parse(match.group(1)!),
        minute: int.parse(match.group(2)!),
      );
    }
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      helpText: 'Select birth time',
    );
    if (picked != null) {
      final hh = picked.hour.toString().padLeft(2, '0');
      final mm = picked.minute.toString().padLeft(2, '0');
      timeOfBirth.value = '$hh:$mm';
    }
  }

  Future<bool> save() async {
    final dob = dateOfBirth.value;
    if (dob == null) {
      Get.snackbar('Birth date', 'Please choose your date of birth.');
      return false;
    }
    final horoscope = Horoscope(
      dateOfBirth: dob,
      timeOfBirth: timeOfBirth.value,
      placeOfBirth: placeOfBirth.text.trim(),
      timeZoneOffsetMinutes: timeZoneOffsetMinutes.value,
    );
    saving.value = true;
    error.value = null;
    try {
      final saved = chart.value == null
          ? await _repository.createHoroscope(horoscope)
          : await _repository.updateHoroscope(horoscope);
      chart.value = saved;
      Get.snackbar('Chart updated', 'Your birth chart has been calculated.');
      return true;
    } on ApiException catch (e) {
      error.value = e.message;
      return false;
    } catch (_) {
      error.value = 'Could not save your horoscope.';
      return false;
    } finally {
      saving.value = false;
    }
  }
}
