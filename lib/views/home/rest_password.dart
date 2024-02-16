import 'package:event/components/delegatedForm.dart';
import 'package:event/components/delegatedSnackBar.dart';
import 'package:event/components/delegatedText.dart';
import 'package:event/controllers/resetPasswordController.dart';
import 'package:event/utils/constant.dart';
import 'package:event/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  ResetPasswordController resetPasswordController =
      Get.put(ResetPasswordController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: DelegatedText(
            text: "Reset Password",
            fontSize: 20,
            fontName: "InterBold",
            color: Constants.tertiaryColor,
          ),
          backgroundColor: Constants.primaryColor,
          leading: IconButton(
            color: Constants.tertiaryColor,
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
            ),
          ),
        ),
        backgroundColor: Constants.basicColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/no_text.png",
                      width: 120,
                    ),
                    DelegatedText(
                      text: 'submit form below to reset password',
                      fontSize: 15,
                      fontName: 'InterMed',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        height: size.height * .65,
                        width: size.width,
                        margin: const EdgeInsets.only(bottom: 15, top: 8),
                        decoration: BoxDecoration(
                          color: Constants.basicColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(221, 207, 203, 203),
                              blurRadius: 2,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 20,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  DelegatedForm(
                                      isVisible: false,
                                      fieldName: 'Current Password',
                                      icon: Icons.phone,
                                      hintText: 'Enter current password',
                                      validator: FormValidator.validateField,
                                      isSecured: false,
                                      formController:
                                          resetPasswordController.oldPass),
                                  DelegatedForm(
                                      isVisible: false,
                                      fieldName: 'New Password',
                                      icon: Icons.phone,
                                      hintText: 'Enter New Password',
                                      validator: FormValidator.validatePassword,
                                      isSecured: false,
                                      formController:
                                          resetPasswordController.newPass),
                                  DelegatedForm(
                                      isVisible: false,
                                      fieldName: 'Confirm New Password',
                                      icon: Icons.phone,
                                      hintText: 'Confirm New Password',
                                      validator: FormValidator.validatePassword,
                                      isSecured: false,
                                      formController:
                                          resetPasswordController.newPass2),
                                  const SizedBox(height: 15),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          if (resetPasswordController
                                                  .newPass.text ==
                                              resetPasswordController
                                                  .newPass2.text) {
                                            resetPasswordController
                                                .updatePassword();
                                          } else {
                                            ScaffoldMessenger.of(Get.context!)
                                                .showSnackBar(
                                              delegatedSnackBar(
                                                  "FAILED: New and Confirm password don't match",
                                                  false),
                                            );
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Constants.primaryColor,
                                      ),
                                      child: DelegatedText(
                                        fontSize: 15,
                                        text: 'Reset Password',
                                        color: Constants.basicColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
