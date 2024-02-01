import 'package:event/components/delegatedText.dart';
import 'package:event/models/user_data.dart';
import 'package:event/services/database.dart';
import 'package:event/utils/loading.dart';
import 'package:event/views/auth/authenticate.dart';
import 'package:event/views/auth/sign_in.dart';
import 'package:event/views/auth/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  DatabaseService databaseService = Get.put(DatabaseService());

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.signOut();

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        } else if (snapshot.hasError) {
          return Center(
            child: DelegatedText(text: 'Something went wrong!', fontSize: 20),
          );
        } else if (snapshot.hasData) {
          //check for userType (userType == user)? userPage : adminPage
          final userID = FirebaseAuth.instance.currentUser!.uid;
          databaseService.uid = userID;

          return FutureBuilder(
            future: databaseService.getUser(),
            builder: (context, AsyncSnapshot<UserData?> userData) {
              if (userData.connectionState == ConnectionState.waiting) {
                return const Loading();
              } else if (userData.hasError) {
                return Center(
                  child: DelegatedText(
                    text: 'Something went wrong!',
                    fontSize: 20,
                  ),
                );
              } else {
                if (userData.data!.type == 'user') {
                  // route to user page
                  return Container();
                }
                // route to admin page
                return Container();
              }
            },
          );
        } else {
          // route to authenticate function
          return const Authenticate();
        }
      },
    );
  }
}
