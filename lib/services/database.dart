import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:event/components/delegatedSnackBar.dart';
import 'package:event/models/event_details.dart';
import 'package:event/models/events.dart';
import 'package:event/models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:event/services/notification_api.dart';
import 'package:event/views/home/users/event_detail.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DatabaseService extends GetxController {
  String? userId;
  UserData? userData;

  DatabaseService({this.userId});

  // collection reference
  var usersCollection = FirebaseFirestore.instance.collection("Users");
  var eventCollection = FirebaseFirestore.instance.collection("Events");
  var invitationCollection =
      FirebaseFirestore.instance.collection("Invitation");
  var filesCollection = FirebaseStorage.instance.ref();

  // Determine userType
  Future<UserData?> getUser() async {
    // Query database to get user type
    final snapshot = await usersCollection.doc(userId).get();
    // Return user type as string
    if (snapshot.exists) {
      userData = UserData.fromJson(snapshot);
      return userData;
    }
    return null;
  }

  //Create user
  Future createUserData(
      String username, String phone, String type, String token) async {
    await setImage(userId, 'Users');
    return await usersCollection.doc(userId).set(
      {
        'username': username,
        'phone': phone,
        'type': type,
        'name': " ",
        'token': token,
        'created': FieldValue.serverTimestamp(),
      },
    );
  }

  Future<bool> setImage(String? uid, String path) async {
    final ByteData byteData = await rootBundle.load("assets/user.png");
    final Uint8List imageData = byteData.buffer.asUint8List();
    filesCollection.child("$path/$uid").putData(imageData);
    return true;
  }

  Future<bool> uploadImage(File? image, String imageName, String path) async {
    try {
      await filesCollection.child("$path/$imageName").putFile(image!);
      return true; // Return true if the upload succeeds
    } catch (error) {
      return false; // Return false if the upload fails
    }
  }

  // Create event
  Future<bool> createEvent(
    String title,
    String desc,
    FieldValue date,
    String uid,
    String userID,
    File? image,
    String imageName,
    bool status,
    bool isRestricted,
  ) async {
    bool isUploaded = await uploadImage(image, '$uid$imageName', 'Events');
    String imageRef = 'Events/$uid$imageName';
    String userRef = "Users/$userID";

    if (isUploaded) {
      await eventCollection.doc().set(
        {
          'title': title,
          'desc': desc,
          'date': date,
          'status': status,
          'isRestricted': isRestricted,
          'image': imageRef,
          'created': FieldValue.serverTimestamp(),
          'createdBy': userRef,
        },
      );
      return true;
    } else {
      return false;
    }
  }

  // Get users events
  Stream<List<Events>> getUserSpecificEvents(String userID) {
    return eventCollection
        .where('createdBy', isEqualTo: userID)
        .orderBy('created', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Events.fromJson(doc)).toList());
  }

  // Get all admin events
  Stream<List<Events>> getAllEvents() {
    return eventCollection
        .orderBy('status', descending: false)
        .orderBy('created', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Events.fromJson(doc)).toList());
  }

  Future<String?> getImage(String path) async {
    try {
      final url = await filesCollection.child(path).getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }

  // Get event details
  Future<EventDetails?> getEventDetails(String eventId) async {
    final snapshot = await eventCollection.doc(eventId).get();
    if (snapshot.exists) {
      return EventDetails.fromMap(snapshot.data()!, eventId);
    }
    return null;
  }

  //Create Invitation
  Future createInvitation(
      List<Contact> selectedContacts, String eventID) async {
    List<String> existingPhones = [];
    List<String> existingDeviceToken = [];
    List<String> nonExistingPhones = [];

    // get users either existing or non-existing
    for (var contact in selectedContacts) {
      var currentContact = contact.phones![0].value;
      var querySnapshot =
          await usersCollection.where('phone', isEqualTo: currentContact).get();
      if (querySnapshot.docs.isNotEmpty) {
        existingPhones.add(currentContact!);
        existingDeviceToken.add('"${querySnapshot.docs[0]['token']}"');
      } else {
        nonExistingPhones.add(currentContact!);
      }
    }

    // Send push notification for already existing users
    bool notificationSuccessful =
        await sendPushNotification(existingDeviceToken, eventID);

    // send SMS for non-existing users
    sendSMS();
    // save invitation details to DB
    for (var phone in nonExistingPhones) {
      await invitationCollection.doc().set(
        {
          'eventID': eventCollection.doc(eventID),
          'phone': phone,
          'created': FieldValue.serverTimestamp(),
        },
      );
    }

    return null;
  }

  Future<bool> sendPushNotification(existingDeviceToken, eventID) async {
    print("Device Token: $existingDeviceToken");
    // get event details
    var eventDoc = await eventCollection.doc(eventID).get();

    String truncateString(String input, int maxLength) {
      if (input.length <= maxLength) {
        return input;
      } else {
        return "${input.substring(0, maxLength)}...";
      }
    }

    try {
      var headers = {
        'Authorization':
            'key=AAAAAyre-kA:APA91bGKOy1anHMJHD35cWrfkD1AWmBSWuuaDGqvV1ns3WUcXzif2Syte00TqVR0Wiea-SNX9pCldV12jYNuTDXQgZWzCDdzmdvka9wLCkiBpdNep5CrSOdd_aPEc3vpxKrxv7rmBFEF',
        'Content-Type': 'application/json',
      };

      var request = http.Request(
          'POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));

      request.body =
          '''{\r\n    "registration_ids":$existingDeviceToken,\r\n    "notification": {\r\n        "title": "${eventDoc['title']}",\r\n        "body": "${truncateString(eventDoc['desc'], 40)}",\r\n        "click_action": "FLUTTER_NOTIFICATION_CLICK"\r\n    },\r\n    "data": {\r\n        "story_id": "$eventID"\r\n    }\r\n}''';

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        return true;
      } else {
        print("response.reasonPhrase");
        print(response.reasonPhrase);
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  void sendSMS() async {
    // Define the request headers and payload
    // Map<String, String> headers = {
    //   'Authorization': 'App e7b8341cadd8181e1b025bab07069d31-d6febbf8-35d5-4276-90e8-ae5ae39b64ae',
    //   'Content-Type': 'application/json',
    //   'Accept': 'application/json',
    // };

    // Map<String, dynamic> payload = {
    //   'messages': [
    //     {
    //       'destinations': [{'to': '2348146543239'}],
    //       'from': 'ServiceSMS',
    //       'text': 'Hello,\n\nThis is a test message from Infobip. Have a nice day!'
    //     }
    //   ]
    // };

    // // Convert the payload to JSON
    // String payloadJson = jsonEncode(payload);

    // // Send the HTTP POST request
    // var response = await http.post(
    //   Uri.parse('https://rg4x1p.api.infobip.com/sms/2/text/advanced'),
    //   headers: headers,
    //   body: payloadJson,
    // );

    // // Print the response status code and body
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    print("SMS has been sent!");
  }

  // Get all users events either via invitation or unrestricted events
  Stream<List<Events>> getAllEventsEitherByInvitation(String userId) {
    return eventCollection
        .where('status', isEqualTo: true)
        .orderBy("created", descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Events> events = [];
      for (var doc in snapshot.docs) {
        final user = await usersCollection.doc(userId).get();

        if (doc['isRestricted']) {
          var invitationSnapshot = await invitationCollection
              .where('eventID', isEqualTo: doc.reference.id)
              .where('phone', isEqualTo: user['phone'])
              .get();

          if (invitationSnapshot.docs.isNotEmpty) {
            events.add(Events.fromJson(doc));
          }
        } else {
          events.add(Events.fromJson(doc));
        }
      }
      return events;
    });
  }

  // All events pending review
  Stream<List<Events>> getAllEventsPendingReviews() {
    return eventCollection
        .where('status', isEqualTo: false)
        .orderBy('created', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Events.fromJson(doc)).toList());
  }
}//end of class
