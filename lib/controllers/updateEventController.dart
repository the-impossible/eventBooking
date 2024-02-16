import 'dart:ffi';
import 'dart:io';
import 'package:event/controllers/eventDetailsController.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:event/components/delegatedSnackBar.dart';
import 'package:event/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateEventController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  DatabaseService databaseService = Get.put(DatabaseService());
  EventDetailController eventDetailController =
      Get.put(EventDetailController());

  // variables
  File? image;
  String? imageName;
  String? eventId;
  bool? isRestricted = false;
  String? eventDate;

  Future updateEvent() async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    bool isDateInThePast(String eventDate) {
      DateTime date;
      try {
        date = DateFormat('MMM-dd-yy hh:mm a').parse(eventDate);
      } catch (e) {
        date = DateFormat('E, M/d/y, h:mm a').parse(eventDate);
      }
      // Get the current date and time
      DateTime currentDate = DateTime.now();
      // Compare the given date with the current date
      if (date.isBefore(currentDate)) {
        // The given date is in the past
        return true;
      } else {
        // The given date is either today or in the future
        return false;
      }
    }

    Timestamp convertToServerTimestamp(String dateString) {
      // Define date format
      DateTime dateTime;
      try {
        final dateFormat = DateFormat('E, M/d/y, h:mm a');

        dateTime = dateFormat.parse(dateString);
      } catch (e) {
        final dateFormat = DateFormat('MMM-dd-yy hh:mm a');
        dateTime = dateFormat.parse(dateString);
      }
      // Convert DateTime object to Firestore server timestamp
      return Timestamp.fromDate(dateTime);
    }

    Timestamp serverTimestamp = convertToServerTimestamp(eventDate!);

    // Create a new event
    if (isDateInThePast(eventDate!)) {
      navigator!.pop(Get.context!);
      ScaffoldMessenger.of(Get.context!).showSnackBar(delegatedSnackBar(
          "Event date cannot be less than current date", false));
    } else {
      // bool isSuccessful = true;
      bool isSuccessful = await DatabaseService().updateEvent(
        titleController.text,
        descController.text,
        serverTimestamp,
        eventId!,
        image,
        imageName,
        isRestricted!,
      );

      if (isSuccessful) {
        navigator!.pop(Get.context!);
        titleController.clear();
        descController.clear();
        eventDetailController.eventDetails =
            await DatabaseService().getEventDetails(eventId!);
        Get.back();
        Get.back();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
            delegatedSnackBar("Event updated successfully!", true));
      } else {
        navigator!.pop(Get.context!);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(delegatedSnackBar("Event update Failed", false));
      }
    }
  }
}
