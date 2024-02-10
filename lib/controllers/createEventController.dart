import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:event/components/delegatedSnackBar.dart';
import 'package:event/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateEventController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  DatabaseService databaseService = Get.put(DatabaseService());

  // variables
  File? image;
  String? imageName;
  bool? isRestricted = false;
  String? eventDate;

  Future createEvent() async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    String uid = const Uuid().v4(); // Generate a UUID

    // Function to parse date string and convert to server timestamp
    FieldValue convertToServerTimestamp(String dateString) {
      // Define date format
      final dateFormat = DateFormat('E, M/d/y, h:mm a');

      // Parse the date string into a DateTime object
      DateTime dateTime = dateFormat.parse(dateString);

      // Convert DateTime object to Firestore server timestamp
      return FieldValue.serverTimestamp();
    }

    FieldValue serverTimestamp = convertToServerTimestamp(eventDate!);

    // Create a new event
    bool isSuccessful = await DatabaseService().createEvent(
      titleController.text,
      descController.text,
      serverTimestamp,
      uid,
      FirebaseAuth.instance.currentUser!.uid,
      image,
      imageName!,
      false,
      isRestricted!,
    );

    if (isSuccessful) {
      navigator!.pop(Get.context!);
      titleController.clear();
      descController.clear();
      Get.back();
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(delegatedSnackBar("Event created successfully!", true));
    } else {
      navigator!.pop(Get.context!);
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(delegatedSnackBar("Event Creation Failed", false));
    }
  }
}
