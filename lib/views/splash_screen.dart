import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:event/views/wrapper.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedSplashScreen(
        splash: Image.asset(
          "assets/event.png",
          width: 300,
          height: 200,
        ),
        splashIconSize: 300,
        centered: true,
        duration: 1000,
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        animationDuration: const Duration(seconds: 1),
        nextScreen: const Wrapper(),
      ),
    );
  }
}
