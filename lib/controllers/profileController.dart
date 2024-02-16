import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/components/delegatedSnackBar.dart';
import 'package:event/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  DatabaseService databaseService = Get.put(DatabaseService());
  File? image;

  String? userType;

  Future<void> updateAccount() async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      QuerySnapshot snaps = await FirebaseFirestore.instance
          .collection('users')
          .where("phone", isEqualTo: phoneController.text)
          .where("username", isEqualTo: usernameController.text)
          .get();

      if (snaps.docs.length != 1 ||
          snaps.docs[0].id == FirebaseAuth.instance.currentUser!.uid) {
        await databaseService.updateProfile(
          FirebaseAuth.instance.currentUser!.uid,
          nameController.text.trim(),
          usernameController.text.trim(),
          phoneController.text.trim(),
        );
        if (image != null) {
          await databaseService.updateImage(
            image,
            "Users/${FirebaseAuth.instance.currentUser!.uid}",
          );
        }

        ScaffoldMessenger.of(Get.context!).showSnackBar(
            delegatedSnackBar("Account Updated Successfully", true));
      } else {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(delegatedSnackBar("Phone number exists!", false));
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(delegatedSnackBar(e.message.toString(), false));
    } finally {
      navigator!.pop(Get.context!);
    }
  }
}
