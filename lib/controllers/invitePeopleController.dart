import 'package:contacts_service/contacts_service.dart';
import 'package:event/models/event_details.dart';
import 'package:event/routes/routes.dart';
import 'package:event/components/delegatedSnackBar.dart';
import 'package:event/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvitePeopleController extends GetxController {
  DatabaseService databaseService = Get.put(DatabaseService());
  List<Contact> selectedContacts = [];

  // variables
  String? eventID;

  void cleanPhoneNumbers(List<Contact> selectedContacts) {
    for (var contact in selectedContacts) {
      // Remove whitespace and replace +234 with zer0
      contact.phones![0].value =
          contact.phones![0].value!.replaceAll(' ', '').replaceAll('+234', '0');
    }
  }

  Future inviteContact() async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Clean the phone numbers
    cleanPhoneNumbers(selectedContacts);

    // Make DatabaseService API call
    await DatabaseService().createInvitation(selectedContacts, eventID!);

    // check if invitation has been sent

    // Invitation Sent
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(delegatedSnackBar("Invitation successfully sent!", true));

    // Remove show dialogue
    navigator!.pop(Get.context!);

    // if (eventDetails != null) {
    //   navigator!.pop(Get.context!);
    //   Get.toNamed(Routes.eventDetails);
    // } else {
    //   navigator!.pop(Get.context!);
    //   ScaffoldMessenger.of(Get.context!)
    //       .showSnackBar(delegatedSnackBar("Something went wrong!", false));
    // }
  }
}
