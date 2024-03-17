import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:event/components/delegatedSnackBar.dart';
import 'package:event/models/event_details.dart';
import 'package:event/models/events.dart';
import 'package:event/models/people_attending.dart';
import 'package:event/models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService extends GetxController {
  String? userId;
  UserData? userData;

  DatabaseService({this.userId});

  // collection reference
  var usersCollection = FirebaseFirestore.instance.collection("Users");
  var eventCollection = FirebaseFirestore.instance.collection("Events");
  var invitationCollection =
      FirebaseFirestore.instance.collection("Invitation");
  var rsvpCollection = FirebaseFirestore.instance.collection("Rsvp");
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

  //Create admin
  Future createAdminData(
      String username, String phone, String type, String name) async {
    await setImage(userId, 'Users');
    return await usersCollection.doc(userId).set(
      {
        'username': username,
        'phone': phone,
        'type': type,
        'name': name,
        'token': "",
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
    Timestamp date,
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
    bool smsSuccessful = await sendSMS(nonExistingPhones);
    // save invitation details to DB
    for (var phone in nonExistingPhones) {
      await invitationCollection.doc().set(
        {
          'eventID': "Events/$eventID",
          'phone': phone,
          'created': FieldValue.serverTimestamp(),
        },
      );
    }

    if (smsSuccessful && notificationSuccessful) {
      return true;
    } else {
      if (smsSuccessful) {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(delegatedSnackBar("SMS successfully sent!", true));
      }
      if (notificationSuccessful) {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(delegatedSnackBar("PUSH notification sent!", true));
      }
    }
    return false;
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

  Future<bool> sendSMS(nonExistingPhones) async {
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse('https://www.bulksmsnigeria.com/api/v2/sms'));

    request.fields.addAll({
      'from': 'Eventify',
      'to': '${nonExistingPhones.join(", ")}',
      'body':
          'You have received an event request, to accept kindly download our app "Eventify.pro" and sign up with this number',
      'api_token':
          'Pro7K2OnSaHGHc2tbwryMHJrUmfnivLyGKILbPjGcwRlWHVFXoIQ7pWQcKDq',
      'gateway': 'direct-refund'
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print("SMS has been sent!");

      return true;
    } else {
      print(response.reasonPhrase);
      return false;
    }
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
              .where('eventID', isEqualTo: "Events/${doc.reference.id}")
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

  // user to respond to event
  Future<bool> respondToEvent(respond, userId, eventId) async {
    String userRef = "Users/$userId";
    String eventRef = "Events/$eventId";

    await rsvpCollection.doc().set(
      {
        'eventId': eventRef,
        'userId': userRef,
        'respond': respond,
        'created': FieldValue.serverTimestamp(),
      },
    );
    return true;
  }

  // check if user has responded or not
  Stream<bool> hasResponded(String userId, String eventId) {
    String userRef = "Users/$userId";
    String eventRef = "Events/$eventId";

    final Stream<bool> stream = rsvpCollection
        .where('eventId', isEqualTo: eventRef)
        .where('userId', isEqualTo: userRef)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    });
    return stream;
  }

  // Get a user profile
  Stream<UserData?> getUserProfile(String uid) {
    return usersCollection.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserData.fromJson(snapshot);
      }
      return null;
    });
  }

  // Update user profile
  Future<bool> updateProfile(
    String uid,
    String name,
    String username,
    String phone,
  ) async {
    usersCollection.doc(uid).update({
      "username": username,
      "phone": phone,
      "name": name,
    });
    return true;
  }

  // update user profile image
  Future<bool> updateImage(File? image, String path) async {
    filesCollection.child(path).putFile(image!);
    return true;
  }

  // Get profile image
  Stream<String?> getProfileImage(String path) {
    try {
      Future.delayed(const Duration(milliseconds: 3600));
      return filesCollection.child(path).getDownloadURL().asStream();
    } catch (e) {
      return Stream.value(null);
    }
  }

  // Admin approve user event
  Future<bool> approveEvent(
    String eventId,
  ) async {
    await eventCollection.doc(eventId).update({
      "status": true,
    });
    return true;
  }

  // Check if admin has approved user event
  Stream<bool> hasApproved(eventId) {
    String eventRef = "Events/$eventId";

    final Stream<bool> stream = eventCollection
        .where('eventId', isEqualTo: eventRef)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    });
    return stream;
  }

  // Get the list of an event attendees
  Stream<List<PeopleAttendingModel>> getListOfAttendees(eventId) {
    String eventRef = "Events/$eventId";
    return rsvpCollection
        .where('eventId', isEqualTo: eventRef)
        .where('respond', isEqualTo: true)
        .orderBy('created', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PeopleAttendingModel.fromJson(doc))
            .toList());
  }

  Future<UserData?> getUserDetails(userId) async {
    // Query database to get user type
    final snapshot = await usersCollection.doc(userId).get();
    // Return user type as string
    if (snapshot.exists) {
      return UserData.fromJson(snapshot);
    }
    return null;
  }

  // Delete Event
  Future<bool> deleteEvent(String eventId) async {
    try {
      final DocumentReference documentRef = eventCollection.doc(eventId);
      final DocumentSnapshot snapshot = await documentRef.get();

      if (snapshot.exists) {
        await documentRef.delete();
        return true;
      } else {
        return false; // Document with specified ID does not exist
      }
    } catch (e) {
      print("Error deleting event: $e");
      return false;
    }
  }

  // Update user profile
  Future<bool> updateEvent(
    String title,
    String desc,
    Timestamp date,
    String uid,
    File? image,
    String? imageName,
    bool isRestricted,
  ) async {
    // Update document
    try {
      // Create a map to hold the fields to update
      Map<String, dynamic> dataToUpdate = {
        'title': title,
        'desc': desc,
        'date': date,
        'isRestricted': isRestricted,
      };

      // Check if image and imageName are not null
      String imageRef = '';
      if (image != null && imageName != null) {
        imageRef = 'Events/$uid$imageName';
        dataToUpdate['image'] = imageRef;

        // Upload the image
        bool isUploaded = await uploadImage(image, '$uid$imageName', 'Events');

        if (isUploaded) {
          await eventCollection.doc(uid).update(dataToUpdate);
          return true;
        } else {
          // If image upload fails, return false
          return false;
        }
      } else {
        await eventCollection.doc(uid).update(dataToUpdate);

        return true;
      }
    } catch (e) {
      // Handle any errors
      print('Error updating event: $e');
      return false;
    }
  }

  Future<UserData?> getUserName(String userId) async {
    // Query database to get user type
    final snapshot = await usersCollection
        .doc(userId.toString().replaceAll("Users/", ""))
        .get();
    // Return user type as string
    if (snapshot.exists) {
      return UserData.fromJson(snapshot);
    }
    return null;
  }
}//end of class
