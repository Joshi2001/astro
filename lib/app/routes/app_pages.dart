import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../bindings/initial_binding.dart';
import '../../viewmodels/astro_qa_controller.dart';
import '../../viewmodels/dashboard_controller.dart';
import '../../viewmodels/horoscope_controller.dart';
import '../../viewmodels/main_tab_controller.dart';
import '../../viewmodels/match_detail_controller.dart';
import '../../viewmodels/matchmaking_controller.dart';
import '../../viewmodels/profile_controller.dart';
import '../../viewmodels/questionnaire_controller.dart';
import '../../views/auth/login_screen.dart';
import '../../views/auth/register_screen.dart';
import '../../views/horoscope/horoscope_screen.dart';
import '../../views/main/main_screen.dart';
import '../../views/matchmaking/match_detail_screen.dart';
import '../../views/profile/profile_edit_screen.dart';
import '../../views/questionnaire/questionnaire_screen.dart';
import '../../views/splash/splash_screen.dart';
import '../../routes/app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: InitialBinding(),
      transition: Transition.zoom,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => MainTabController());
        Get.lazyPut(() => DashboardController());
        Get.lazyPut(() => MatchmakingController());
        Get.lazyPut(() => AstroQaController());
      }),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.horoscope,
      page: () => const HoroscopeScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HoroscopeController());
      }),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    ),
    GetPage(
      name: AppRoutes.questionnaire,
      page: () => const QuestionnaireScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => QuestionnaireController());
      }),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    ),
    GetPage(
      name: AppRoutes.profileEdit,
      page: () => const ProfileEditScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ProfileController());
      }),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    ),
    GetPage(
      name: AppRoutes.matchDetail,
      page: () => const MatchDetailScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() {
          final args = Get.arguments as Map<String, dynamic>? ?? const {};
          final controller = MatchDetailController();
          controller.setup(
            matchId: args['matchId']?.toString(),
            partnerId: args['partnerId']?.toString(),
            fromRecommendation: args['recommendation'] == true,
          );
          return controller;
        });
      }),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    ),
  ];
}
