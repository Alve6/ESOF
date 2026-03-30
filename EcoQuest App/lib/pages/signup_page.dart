import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/buttons.dart';
import '../helper/size_config.dart';
import '../widgets/text_fields.dart';
import '../services/firestoreAPI.dart';


class SignUpPage extends StatefulWidget {
  final void Function()? swapPages;

  SignUpPage({required this.swapPages});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmationController = TextEditingController();

  String errorMessage = "";

  // register function
  void register() async {
    setState(() {
      errorMessage = "";
    });

    if(passwordController.text != confirmationController.text) {
      setState(() {
        usernameController.clear();
        emailController.clear();
        passwordController.clear();
        confirmationController.clear();
        errorMessage = "Error: passwords do not match";
      });
      return;
    }

    try {
      UserCredential? userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text);
      createUser(userCredential, usernameController.text);
      } on FirebaseAuthException catch (e) {
      setState(() {
        usernameController.clear();
        emailController.clear();
        passwordController.clear();
        confirmationController.clear();

        switch (e.code) {
          case "invalid-email":
            errorMessage = "Error: invalid email format";
          case "email-already-in-use":
            errorMessage = "Error: email already has an account associated";
          case "user-not-found":
            errorMessage = "Error: user with this email does not exist";
          case "weak-password":
            errorMessage = "Error: password is too weak";
          case "INVALID_LOGIN_CREDENTIALS":
          case "invalid-credential":
          case "wrong-password":
            errorMessage = "Error: password is wrong";
          case "too-many-requests":
            errorMessage = "Error: too many requests in a short time. Try again later";
          case "network-request-failed":
            errorMessage = "Error: network request failed";
          case "channel-error":
            errorMessage = "Error: password and/or email cannot be empty";
          default:
            errorMessage = "An unknown error occurred. Try again";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        centerTitle: true,
        title: Text('EcoQuest',
          style: TextStyle(
              fontSize: SizeConfig.heightPercentage(3.5),
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: SizeConfig.widthPercentage(5), right: SizeConfig.widthPercentage(5), top: SizeConfig.heightPercentage(1)),
        child: Column(
          children: [
            Text('Create an account',
              style: TextStyle(
                  fontSize: SizeConfig.heightPercentage(2.5),
                  fontWeight: FontWeight.bold
              ),
            ),
            Text('Enter your email to sign up for EcoQuest',
              style: TextStyle(
                fontSize: SizeConfig.heightPercentage(1.6),
              ),
            ),
            if(errorMessage != "")
              Padding(
                padding: EdgeInsets.only(bottom: SizeConfig.heightPercentage(1)),
                child: Text(errorMessage,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            if(errorMessage == "") SizedBox(height: SizeConfig.heightPercentage(2)),
            TextFieldLabelTop('Username', 'username', usernameController),
            SizedBox(height: SizeConfig.heightPercentage(1.5)),
            TextFieldLabelTop('Email', 'example@email.com', emailController),
            SizedBox(height: SizeConfig.heightPercentage(1.5)),
            TextFieldLabelTop('Password', 'password', passwordController, true),
            SizedBox(height: SizeConfig.heightPercentage(1.5)),
            TextFieldLabelTop('Confirm Password', 'password', confirmationController, true),
            SizedBox(height: SizeConfig.heightPercentage(3)),
            CenteredElevatedButton(register, 'Sign Up'),
            SizedBox(height: SizeConfig.heightPercentage(3)),
            Row(
              children: [
                Text('Already have an account? '),
                InkWell(
                  child: Text('Log in', style: TextStyle(color: Colors.blue),),
                  onTap: () {
                    widget.swapPages!();
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}