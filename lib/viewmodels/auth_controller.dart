import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exceptions.dart';
import '../../core/storage/app_storage.dart';
import '../../data/models/user.dart';
import '../../data/repositories/auth_repository.dart';
import '../../routes/app_routes.dart';

class AuthController extends GetxController {
  AuthController(this._repository);

  final AuthRepository _repository;

  final Rx<User?> user = Rx<User?>(null);
  final RxBool restoring = RxBool(true);
  final RxBool loading = RxBool(false);
  final Rx<String?> error = Rx<String?>(null);

  final RxBool obscurePassword = RxBool(true);

  bool get isLoggedIn => user.value != null;

  @override
  void onInit() {
    super.onInit();
    restoreSession();
  }

  Future<void> restoreSession() async {
    restoring.value = true;
    final token = await AppStorage.instance.readString(AppConstants.kToken);
    final cached = await AppStorage.instance.readMap(AppConstants.kUser);

    if (token == null || token.isEmpty) {
      user.value = null;
      restoring.value = false;
      return;
    }

    ApiClient.instance.token = token;
    ApiClient.instance.authCookie = token;

    if (cached != null) {
      user.value = User.fromJson(cached);
    }

    try {
      final fresh = await _repository.me();
      if (fresh != null) {
        user.value = fresh;
        await AppStorage.instance.writeMap(AppConstants.kUser, fresh.toJson());
      } else {
        await _signOutLocal();
      }
    } on ApiException catch (e) {
      if (e.isUnauthorized) {
        await _signOutLocal();
      }
    } catch (_) {
      // Offline — keep using cached user.
    } finally {
      restoring.value = false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    if (!_validate(email.trim(), password)) return false;
    loading.value = true;
    error.value = null;
    try {
      final (token, loggedUser) = await _repository.login(
        email: email.trim(),
        password: password,
      );
      await _persist(token, loggedUser);
      Get.offAllNamed(AppRoutes.main);
      return true;
    } on ApiException catch (e) {
      error.value = e.message;
      return false;
    } catch (_) {
      error.value = 'Something went wrong. Please try again.';
      return false;
    } finally {
      loading.value = false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String gender,
  }) async {
    if (name.trim().length < 2) {
      error.value = 'Please enter your full name.';
      return false;
    }
    if (!_validate(email.trim(), password)) return false;
    loading.value = true;
    error.value = null;
    try {
      final (token, newUser) = await _repository.register(
        name: name.trim(),
        email: email.trim(),
        password: password,
        gender: gender,
      );
      await _persist(token, newUser);
      Get.offAllNamed(AppRoutes.main);
      return true;
    } on ApiException catch (e) {
      error.value = e.message;
      return false;
    } catch (_) {
      error.value = 'Something went wrong. Please try again.';
      return false;
    } finally {
      loading.value = false;
    }
  }

  Future<void> _persist(String token, User newUser) async {
    ApiClient.instance.token = token;
    ApiClient.instance.authCookie = token;
    user.value = newUser;
    await AppStorage.instance.writeString(AppConstants.kToken, token);
    await AppStorage.instance.writeMap(AppConstants.kUser, newUser.toJson());
  }

  Future<void> logout() async {
    user.value = null;
    await _repository.logout();
    await AppStorage.instance.clear();
    ApiClient.instance.clearAuth();
    Get.offAllNamed(AppRoutes.login);
  }

  Future<void> _signOutLocal() async {
    user.value = null;
    ApiClient.instance.clearAuth();
    await AppStorage.instance.clear();
  }

  bool _validate(String email, String password) {
    if (!GetUtils.isEmail(email)) {
      error.value = 'Please enter a valid email address.';
      return false;
    }
    if (password.length < 6) {
      error.value = 'Password must be at least 6 characters.';
      return false;
    }
    return true;
  }

  void togglePasswordVisibility() => obscurePassword.toggle();

  void clearError() => error.value = null;
}
