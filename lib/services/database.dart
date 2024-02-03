import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/models/user_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DatabaseService extends GetxController {
  String? uid;
  UserData? userData;

  DatabaseService({this.uid});

  // collection reference
  var usersCollection = FirebaseFirestore.instance.collection("Users");
  var filesCollection = FirebaseStorage.instance.ref();

  // Determine userType
  Future<UserData?> getUser() async {
    // Query database to get user type
    final snapshot = await usersCollection.doc(uid).get();
    // Return user type as string
    if (snapshot.exists) {
      userData = UserData.fromJson(snapshot);
      return userData;
    }
    return null;
  }

  //Create user
  Future createStudentData(String username, String phone, String type) async {
    await setImage(uid, 'Users');
    return await usersCollection.doc(uid).set(
      {
        'username': username,
        'phone': phone,
        'type': type,
        'name': " ",
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


}
