import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  AppStorage._();

  static final AppStorage instance = AppStorage._();

  SharedPreferences? _prefs;

  Future<void> _ensure() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<String?> readString(String key) async {
    await _ensure();
    return _prefs?.getString(key);
  }

  Future<void> writeString(String key, String value) async {
    await _ensure();
    await _prefs?.setString(key, value);
  }

  Future<Map<String, dynamic>?> readMap(String key) async {
    final raw = await readString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return null;
  }

  Future<void> writeMap(String key, Map<String, dynamic> value) async {
    await writeString(key, jsonEncode(value));
  }

  Future<void> clear() async {
    await _ensure();
    await _prefs?.clear();
  }

  Future<void> remove(String key) async {
    await _ensure();
    await _prefs?.remove(key);
  }
}
