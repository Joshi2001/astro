import 'package:get/get.dart';

class MainTabController extends GetxController {
  static MainTabController get to => Get.find<MainTabController>();

  final RxInt index = RxInt(0);

  void goTo(int tab) => index.value = tab;

  void goToDiscover() => goTo(1);

  void goToMatches() => goTo(2);

  void goToAstro() => goTo(3);

  void goToProfile() => goTo(4);
}
