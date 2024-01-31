import 'package:event/views/splash_screen.dart';
import 'package:get/get.dart';

class Routes {
  static String splash = '/';
}

final getPages = [
  GetPage(
    name: Routes.splash,
    page: () => const Splash(),
  ),
];
