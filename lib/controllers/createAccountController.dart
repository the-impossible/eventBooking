import 'package:event/components/delegatedSnackBar.dart';
import 'package:event/services/database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAccountController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  DatabaseService databaseService = Get.put(DatabaseService());

  Future createAccount() async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      // Get device token
      String? deviceToken = await FirebaseMessaging.instance.getToken();

      // Create a new user
      await DatabaseService(userId: user.user!.uid).createUserData(
          usernameController.text, phoneController.text, 'user', deviceToken!);

      ScaffoldMessenger.of(Get.context!).showSnackBar(
          delegatedSnackBar("Accounts created successfully!", true));
    } on FirebaseAuthException catch (e) {
      navigator!.pop(Get.context!);
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(delegatedSnackBar(e.message.toString(), false));
    } catch (e) {
      navigator!.pop(Get.context!);
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(delegatedSnackBar(e.toString(), false));
    } finally {
      navigator!.pop(Get.context!);
    }
  }
}
