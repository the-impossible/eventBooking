import 'package:event/components/delegatedSnackBar.dart';
import 'package:event/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RespondToEventController extends GetxController {
  DatabaseService databaseService = Get.put(DatabaseService());

  // variables
  Future respondToEvent(bool respond, userId, eventId) async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    //Respond to Event
    bool isSuccessful =
        await DatabaseService().respondToEvent(respond, userId, eventId);

    if (isSuccessful) {
      navigator!.pop(Get.context!);
      navigator!.pop(Get.context!);
      ScaffoldMessenger.of(Get.context!).showSnackBar(
          delegatedSnackBar("Event responded to successfully!", true));
    } else {
      navigator!.pop(Get.context!);
      navigator!.pop(Get.context!);
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(delegatedSnackBar("Failed to respond to Event", false));
    }
  }
}
