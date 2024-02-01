import 'package:event/components/delegatedForm.dart';
import 'package:event/components/delegatedText.dart';
import 'package:event/utils/constant.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function onClicked;

  const SignUp({
    super.key,
    required this.onClicked,
  });

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.basicColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Constants.basicColor,
          leading: IconButton(
            color: Constants.tertiaryColor,
            onPressed: () {
              widget.onClicked();
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                children: [
                  DelegatedText(
                    text: "Let's Get Started!",
                    fontSize: 20,
                    fontName: 'InterBold',
                  ),
                  const SizedBox(height: 5),
                  DelegatedText(
                    text: 'create an account to access all features!',
                    fontSize: 15,
                    fontName: 'InterMed',
                  ),
                  const SizedBox(height: 30),
                  DelegatedForm(
                    isVisible: false,
                    fieldName: 'Username',
                    icon: Icons.person,
                    hintText: 'Enter username',
                    // formController: loginController.regNoController,
                    isSecured: false,
                  ),
                  DelegatedForm(
                    isVisible: false,
                    fieldName: 'Email',
                    icon: Icons.mail,
                    hintText: 'Enter email address',
                    // formController: loginController.regNoController,
                    isSecured: false,
                  ),
                  DelegatedForm(
                    isVisible: true,
                    fieldName: 'Password',
                    icon: Icons.password,
                    hintText: 'Enter password',
                    // formController: loginController.regNoController,
                    isSecured: true,
                  ),
                  DelegatedForm(
                    isVisible: false,
                    fieldName: 'Mobile Number',
                    icon: Icons.phone,
                    hintText: 'Enter mobile number',
                    // formController: loginController.regNoController,
                    isSecured: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.secondaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25))),
                        child: DelegatedText(text: "Sign up", fontSize: 18),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DelegatedText(
                          text: "Already have an account?",
                          fontSize: 15,
                          color: Constants.tertiaryColor,
                        ),
                        TextButton(
                          onPressed: () {
                            widget.onClicked();
                          },
                          child: DelegatedText(
                            text: "Sign in?",
                            fontSize: 15,
                            color: Constants.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
