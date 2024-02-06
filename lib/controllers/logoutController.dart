import 'package:event/components/delegatedSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogoutController extends GetxController {
  Future signOut() async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance.signOut();

      navigator!.pop(Get.context!);

      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(delegatedSnackBar("Sign Out successful", true));
    } catch (e) {
      navigator!.pop(Get.context!);
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(delegatedSnackBar("Something went wrong", false));
    }
  }
}
