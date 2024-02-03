import 'package:event/components/delegatedSnackBar.dart';
import 'package:event/services/database.dart';
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

      // Create a new user
      await DatabaseService(uid: user.user!.uid).createStudentData(
          usernameController.text, phoneController.text, 'user');

      ScaffoldMessenger.of(Get.context!).showSnackBar(
          delegatedSnackBar("Accounts created successfully!", true));

    } on FirebaseAuthException catch (e) {
      navigator!.pop(Get.context!);
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(delegatedSnackBar(e.message.toString(), false));
    } finally {
      navigator!.pop(Get.context!);
    }
  }

}
