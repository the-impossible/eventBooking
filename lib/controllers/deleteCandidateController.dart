import 'package:event/components/delegatedSnackBar.dart';
import 'package:event/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteEventController extends GetxController {
  DatabaseService databaseService = Get.put(DatabaseService());
  String? eventID;

  Future<void> deleteEvent() async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      // get delete Event
      bool status = await databaseService.deleteEvent(eventID!);

      if (status) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
            delegatedSnackBar("Event deleted Successfully", true));
        Get.back();
      } else {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(delegatedSnackBar("Failed to delete event!", false));
      }
    } catch (e) {
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(delegatedSnackBar("FAILED: $e", false));
    } finally {
      navigator!.pop(Get.context!);
    }
  }
}
