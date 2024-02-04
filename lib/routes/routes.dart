import 'package:event/views/home/users/create_event.dart';
import 'package:event/views/splash_screen.dart';
import 'package:event/views/wrapper.dart';
import 'package:get/get.dart';

class Routes {
  static String splash = '/';
  static String wrapper = '/wrapper';
  static String signUp = '/sign_up';
  static String createEvent = '/createEvent';
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
  GetPage(
    name: Routes.createEvent,
    page: () => const CreateEvent(),
  ),
];
