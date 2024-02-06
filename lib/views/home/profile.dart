import 'dart:io';

import 'package:event/components/delegatedForm.dart';
import 'package:event/components/delegatedSnackBar.dart';
import 'package:event/components/delegatedText.dart';
import 'package:event/controllers/logoutController.dart';
import 'package:event/routes/routes.dart';
import 'package:event/utils/constant.dart';
import 'package:event/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  File? image;

  Future pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return;

      setState(() {
        image = File(pickedFile.path);
        // profileController.image = image;
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
          delegatedSnackBar("Failed to Capture image: $e", false));
    }
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
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Center(
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
                                    : Image.asset(
                                        "assets/user.png",
                                        width: 160,
                                        height: 160,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
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
                                  backgroundColor: Constants.secondaryColor,
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
                        text: "Richard Emmanuel",
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
                      ),
                      DelegatedForm(
                        isVisible: false,
                        fieldName: 'Username',
                        icon: Icons.abc_rounded,
                        hintText: 'Enter username',
                        validator: FormValidator.validateUsername,
                        isSecured: false,
                      ),
                      DelegatedForm(
                        isVisible: false,
                        fieldName: 'Email',
                        icon: Icons.mail,
                        hintText: 'Enter email address',
                        validator: FormValidator.validateEmail,
                        isSecured: false,
                      ),
                      DelegatedForm(
                        isVisible: false,
                        fieldName: 'Mobile Number',
                        icon: Icons.phone,
                        hintText: 'Enter mobile number',
                        validator: FormValidator.validatePhone,
                        isSecured: false,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {}
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Constants.primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25))),
                            child: DelegatedText(
                                text: "Save Changes", fontSize: 18),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
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
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
