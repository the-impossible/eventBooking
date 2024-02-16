import 'package:event/components/delegatedSnackBar.dart';
import 'package:event/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApproveEventController extends GetxController {
  DatabaseService databaseService = Get.put(DatabaseService());

  // variables
  Future approveUserEvent(eventId) async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    //Respond to Event
    bool isSuccessful = await databaseService.approveEvent(eventId);

    if (isSuccessful) {
      navigator!.pop(Get.context!);
      navigator!.pop(Get.context!);
      ScaffoldMessenger.of(Get.context!).showSnackBar(
          delegatedSnackBar("Event has been approved successfully!", true));
    } else {
      navigator!.pop(Get.context!);
      navigator!.pop(Get.context!);
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(delegatedSnackBar("Failed to approve to Event", false));
    }
  }
}
