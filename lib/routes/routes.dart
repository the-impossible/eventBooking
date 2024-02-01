import 'package:event/views/auth/sign_in.dart';
import 'package:event/views/auth/sign_up.dart';
import 'package:event/views/splash_screen.dart';
import 'package:event/views/wrapper.dart';
import 'package:get/get.dart';

class Routes {
  static String splash = '/';
  static String wrapper = '/wrapper';
  static String signUp = '/sign_up';
}

final getPages = [
  GetPage(
    name: Routes.splash,
    page: () => const Splash(),
  ),
  GetPage(
    name: Routes.wrapper,
    page: () => const Wrapper(),
  ),
];
