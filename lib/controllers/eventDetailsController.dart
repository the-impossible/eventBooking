import 'dart:io';
import 'package:event/models/event_details.dart';
import 'package:event/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:event/components/delegatedSnackBar.dart';
import 'package:event/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventDetailController extends GetxController {
  DatabaseService databaseService = Get.put(DatabaseService());

  // variables
  String? eventID;
  EventDetails? eventDetails;

  Future getEvent() async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Create a new event
    eventDetails = await DatabaseService().getEventDetails(eventID!);

    if (eventDetails != null) {
      navigator!.pop(Get.context!);
      Get.toNamed(Routes.eventDetails);
    } else {
      navigator!.pop(Get.context!);
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(delegatedSnackBar("Something went wrong!", false));
    }
  }
}
