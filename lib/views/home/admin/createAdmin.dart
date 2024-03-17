import 'dart:io';

import 'package:event/components/delegatedForm.dart';
import 'package:event/components/delegatedText.dart';
import 'package:event/controllers/createAdminAccountController.dart';
import 'package:event/services/database.dart';
import 'package:event/utils/constant.dart';
import 'package:event/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAdmin extends StatefulWidget {
  const CreateAdmin({super.key});

  @override
  State<CreateAdmin> createState() => _CreateAdminState();
}

class _CreateAdminState extends State<CreateAdmin> {
  File? image;
  final _formKey = GlobalKey<FormState>();
  DatabaseService databaseService = Get.put(DatabaseService());
  CreateAdminAccountController createAdminAccountController =
      Get.put(CreateAdminAccountController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Constants.basicColor,
          appBar: AppBar(
            centerTitle: true,
            title: DelegatedText(
              text: "Create Administrator",
              fontSize: 18,
              color: Constants.tertiaryColor,
              fontName: "InterBold",
            ),
            elevation: 0,
            backgroundColor: Constants.basicColor,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
              color: Constants.tertiaryColor,
            ),
          ),
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
                        const SizedBox(height: 10),
                        DelegatedText(
                          text: 'submit form below to create an admin account',
                          fontSize: 15,
                          fontName: 'InterMed',
                        ),
                        const SizedBox(height: 30),
                        DelegatedForm(
                          isVisible: false,
                          fieldName: 'Username',
                          icon: Icons.person,
                          hintText: 'Enter username',
                          validator: FormValidator.validateUsername,
                          formController:
                              createAdminAccountController.usernameController,
                          isSecured: false,
                        ),
                        DelegatedForm(
                          isVisible: false,
                          fieldName: 'Email',
                          icon: Icons.mail,
                          hintText: 'Enter email address',
                          validator: FormValidator.validateEmail,
                          formController:
                              createAdminAccountController.emailController,
                          isSecured: false,
                        ),
                        DelegatedForm(
                          isVisible: true,
                          fieldName: 'Password',
                          icon: Icons.password,
                          hintText: 'Enter password',
                          validator: FormValidator.validatePassword,
                          formController:
                              createAdminAccountController.passwordController,
                          isSecured: true,
                        ),
                        DelegatedForm(
                          isVisible: false,
                          fieldName: 'Mobile Number',
                          icon: Icons.phone,
                          hintText: 'Enter mobile number',
                          validator: FormValidator.validatePhone,
                          formController:
                              createAdminAccountController.phoneController,
                          isSecured: false,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  createAdminAccountController.createAccount();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Constants.primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25))),
                              child: DelegatedText(
                                  text: "Create Account", fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
