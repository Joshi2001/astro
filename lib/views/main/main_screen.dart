import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../viewmodels/main_tab_controller.dart';
import '../astro_qa/astro_qa_screen.dart';
import '../home/home_screen.dart';
import '../matchmaking/my_matches_screen.dart';
import '../matchmaking/recommendations_screen.dart';
import '../profile/profile_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final index = MainTabController.to.index.value;
        return IndexedStack(
          index: index,
          children: const [
            HomeScreen(),
            RecommendationsScreen(),
            MyMatchesScreen(),
            AstroQaScreen(),
            ProfileScreen(),
          ],
        );
      }),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColors.brandPink.withValues(alpha: 0.22)),
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandPink.withValues(alpha: 0.16),
              blurRadius: 24,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Obx(() {
          final controller = MainTabController.to;
          return NavigationBar(
            selectedIndex: controller.index.value,
            onDestinationSelected: controller.goTo,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore_rounded),
                label: 'Discover',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_outline_rounded),
                selectedIcon: Icon(Icons.favorite_rounded),
                label: 'Matches',
              ),
              NavigationDestination(
                icon: Icon(Icons.auto_awesome_outlined),
                selectedIcon: Icon(Icons.auto_awesome_rounded),
                label: 'Astro',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          );
        }),
      ),
    );
  }
}
