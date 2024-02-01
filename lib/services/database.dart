import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/models/user_data.dart';
import 'package:get/get.dart';

class DatabaseService extends GetxController {
  String? uid;
  UserData? userData;

  DatabaseService({this.uid});

  // collection reference
  var usersCollection = FirebaseFirestore.instance.collection("Users");

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
}
