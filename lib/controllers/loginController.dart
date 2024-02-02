import 'package:event/components/delegatedSnackBar.dart';
import 'package:event/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  DatabaseService databaseService = Get.put(DatabaseService());

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future signIn() async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      emailController.clear();
      passwordController.clear();

      navigator!.pop(Get.context!);

      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(delegatedSnackBar("Sign in successful", true));
    } on FirebaseAuthException {
      navigator!.pop(Get.context!);
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(delegatedSnackBar("Invalid login credentials", false));
    }
  }
}
