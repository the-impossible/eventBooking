import 'dart:io';

import 'package:event/components/delegatedForm.dart';
import 'package:event/components/delegatedSnackBar.dart';
import 'package:event/components/delegatedText.dart';
import 'package:event/controllers/logoutController.dart';
import 'package:event/controllers/profileController.dart';
import 'package:event/models/user_data.dart';
import 'package:event/routes/routes.dart';
import 'package:event/services/database.dart';
import 'package:event/utils/constant.dart';
import 'package:event/utils/form_validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  LogoutController logoutController = Get.put(LogoutController());
  DatabaseService databaseService = Get.put(DatabaseService());
  ProfileController profileController = Get.put(ProfileController());
  File? image;

  Future pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return;

      setState(() {
        image = File(pickedFile.path);
        profileController.image = image;
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
          delegatedSnackBar("Failed to Capture image: $e", false));
    }
  }

  @override
  void initState() {
    profileController.usernameController.text =
        databaseService.userData!.username;
    profileController.nameController.text = databaseService.userData!.name;
    profileController.phoneController.text = databaseService.userData!.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: DelegatedText(
            text: "Profile",
            fontSize: 20,
            fontName: "InterBold",
            color: Constants.tertiaryColor,
          ),
          backgroundColor: Constants.primaryColor,
        ),
        backgroundColor: Constants.basicColor,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: StreamBuilder<UserData?>(
                      stream: databaseService.getUserProfile(
                          FirebaseAuth.instance.currentUser!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Return a loading indicator while the future is still loading
                          return const Center(
                            child: CircularProgressIndicator(
                                color: Constants.primaryColor),
                          );
                        } else if (snapshot.hasError) {
                          // Return an error message if the future encountered an error
                          return Center(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 50.0, bottom: 30),
                                  child: SvgPicture.asset(
                                    'assets/error.svg',
                                    width: 50,
                                    height: 200,
                                  ),
                                ),
                                DelegatedText(
                                  text: "Something Went Wrong!",
                                  fontSize: 20,
                                ),
                              ],
                            ),
                          );
                        } else if (snapshot.hasData) {
                          final profileInfo = snapshot.data!;
                          return Column(
                            children: [
                              Stack(
                                children: [
                                  StreamBuilder<String?>(
                                    stream: databaseService.getProfileImage(
                                        "Users/${FirebaseAuth.instance.currentUser!.uid}"),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: CircleAvatar(
                                            maxRadius: 60,
                                            minRadius: 60,
                                            child: ClipOval(
                                              child: Image.asset(
                                                "assets/user.png",
                                                width: 160,
                                                height: 160,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        );
                                      } else if (snapshot.hasData) {
                                        return Center(
                                          child: CircleAvatar(
                                            maxRadius: 60,
                                            minRadius: 60,
                                            child: ClipOval(
                                              child: (image != null)
                                                  ? Image.file(
                                                      image!,
                                                      width: 160,
                                                      height: 160,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.network(
                                                      snapshot.data!,
                                                      width: 160,
                                                      height: 160,
                                                      fit: BoxFit.cover,
                                                      // colorBlendMode: BlendMode.darken,
                                                    ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 90,
                                      left: 80,
                                    ),
                                    child: Center(
                                      child: InkWell(
                                        onTap: () => pickImage(),
                                        child: const CircleAvatar(
                                          backgroundColor:
                                              Constants.secondaryColor,
                                          child: Icon(
                                            Icons.add_a_photo,
                                            color: Constants.tertiaryColor,
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              DelegatedText(
                                text: profileInfo.name,
                                fontSize: 20,
                                fontName: 'InterBold',
                              ),
                              const SizedBox(height: 5),
                              DelegatedText(
                                text: 'submit form below to update profile',
                                fontSize: 15,
                                fontName: 'InterMed',
                              ),
                              const SizedBox(height: 30),
                              DelegatedForm(
                                isVisible: false,
                                fieldName: 'Name',
                                icon: Icons.person,
                                hintText: 'Enter Full name',
                                validator: FormValidator.validateName,
                                isSecured: false,
                                formController:
                                    profileController.nameController,
                              ),
                              DelegatedForm(
                                isVisible: false,
                                fieldName: 'Username',
                                icon: Icons.abc_rounded,
                                hintText: 'Enter username',
                                validator: FormValidator.validateUsername,
                                isSecured: false,
                                formController:
                                    profileController.usernameController,
                              ),
                              DelegatedForm(
                                isVisible: false,
                                fieldName: 'Mobile Number',
                                icon: Icons.phone,
                                hintText: 'Enter mobile number',
                                validator: FormValidator.validatePhone,
                                isSecured: false,
                                formController:
                                    profileController.phoneController,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        profileController.updateAccount();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Constants.primaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25))),
                                    child: DelegatedText(
                                        text: "Save Changes", fontSize: 18),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DelegatedText(
                                      text: "reset Password?",
                                      fontSize: 15,
                                      color: Constants.tertiaryColor,
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Get.toNamed(Routes.resetPassword),
                                      child: DelegatedText(
                                        text: "Reset?",
                                        fontSize: 15,
                                        color: Constants.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              (databaseService.userData!.type == "adm")
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          DelegatedText(
                                            text: "Admin Account?",
                                            fontSize: 15,
                                            color: Constants.tertiaryColor,
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Get.toNamed(Routes.createAdmin),
                                            child: DelegatedText(
                                              text: "Create Now",
                                              fontSize: 15,
                                              color: Constants.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              TextButton(
                                onPressed: () => {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Confirm Logout'),
                                        content: const Text(
                                            'Are you sure you want to logout? '),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              logoutController.signOut();
                                            },
                                            child: const Text('Log out'),
                                          ),
                                        ],
                                      );
                                    },
                                  )
                                },
                                child: DelegatedText(
                                  text: "Logout ",
                                  fontSize: 20,
                                  fontName: "InterBold",
                                  color: Constants.primaryColor,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
