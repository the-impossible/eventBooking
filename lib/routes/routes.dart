import 'package:event/views/home/profile.dart';
import 'package:event/views/home/rest_password.dart';
import 'package:event/views/home/users/create_event.dart';
import 'package:event/views/home/users/event_detail.dart';
import 'package:event/views/home/users/people_attending.dart';
import 'package:event/views/splash_screen.dart';
import 'package:event/views/wrapper.dart';
import 'package:get/get.dart';

class Routes {
  static String splash = '/';
  static String wrapper = '/wrapper';
  static String signUp = '/sign_up';
  static String createEvent = '/createEvent';
  static String eventDetails = '/eventDetails';
  static String peopleAttending = '/peopleAttending';
  static String profile = '/profile';
  static String resetPassword = '/resetPassword';
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
  GetPage(
    name: Routes.eventDetails,
    page: () => const EventDetail(),
  ),
  GetPage(
    name: Routes.peopleAttending,
    page: () => const PeopleAttending(),
  ),
  GetPage(
    name: Routes.profile,
    page: () => const Profile(),
  ),
  GetPage(
    name: Routes.resetPassword,
    page: () => const ResetPassword(),
  ),
];
