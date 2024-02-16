import 'package:event/models/event_details.dart';
import 'package:event/routes/routes.dart';
import 'package:event/components/delegatedSnackBar.dart';
import 'package:event/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventDetailController extends GetxController {
  DatabaseService databaseService = Get.put(DatabaseService());

  // variables
  String? eventID;
  EventDetails? eventDetails;

  Future getEvent(String route) async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Create a new event
    eventDetails = await DatabaseService().getEventDetails(eventID!);

    if (eventDetails != null) {
      navigator!.pop(Get.context!);
      if (route == 'details') Get.toNamed(Routes.eventDetails);
        if (route == 'update') Get.toNamed(Routes.updateEvent);
    } else {
      navigator!.pop(Get.context!);
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(delegatedSnackBar("Something went wrong!", false));
    }
  }
}

