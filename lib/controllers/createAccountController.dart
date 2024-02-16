import 'package:cloud_firestore/cloud_firestore.dart';
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
      QuerySnapshot snapPhone = await FirebaseFirestore.instance
          .collection('Users')
          .where("phone", isEqualTo: phoneController.text)
          .get();

      QuerySnapshot snapUsername = await FirebaseFirestore.instance
          .collection('Users')
          .where("phone", isEqualTo: phoneController.text)
          .get();

      if (snapPhone.docs.length != 1 && snapUsername.docs.length != 1) {
        var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        // Get device token
        String? deviceToken = await FirebaseMessaging.instance.getToken();
        // Create a new user
        await DatabaseService(userId: user.user!.uid).createUserData(
            usernameController.text,
            phoneController.text,
            'user',
            deviceToken!);

        ScaffoldMessenger.of(Get.context!).showSnackBar(
            delegatedSnackBar("Accounts created successfully!", true));

        emailController.clear();
        usernameController.clear();
        passwordController.clear();
        phoneController.clear();


      } else {
        if (snapPhone.docs.isNotEmpty) {
          ScaffoldMessenger.of(Get.context!)
              .showSnackBar(delegatedSnackBar("Phone number exists!", false));
        }
        if (snapUsername.docs.isNotEmpty) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              delegatedSnackBar("Username already exists!", false));
        }
      }
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
