import 'package:event/components/delegatedSnackBar.dart';
import 'package:event/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  DatabaseService databaseService = Get.put(DatabaseService());
  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController newPass2 = TextEditingController();

  Future<void> updatePassword() async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Create a credential with the user's email and previous password
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: oldPass.text,
      );

      // Reauthenticate the user with the provided credentials
      await user.reauthenticateWithCredential(credential);

      // Password validation successful, update the password
      await user.updatePassword(newPass.text);

      ScaffoldMessenger.of(Get.context!).showSnackBar(
          delegatedSnackBar("Password Updated, Login again", true));
      Get.back();
      FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
          delegatedSnackBar("FAILED: Invalid current password", false));
    } finally {
      navigator!.pop(Get.context!);
    }
  }
}
