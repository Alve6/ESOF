import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/buttons.dart';
import '../widgets/text_fields.dart';
import '../helper/size_config.dart';


class LoginPage extends StatefulWidget {
  final void Function()? swapPages;

  LoginPage({required this.swapPages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  String errorMessage = "";

  // login function
  void login() async {
    setState(() {
      errorMessage = "";
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        emailController.clear();
        passwordController.clear();

        switch (e.code) {
          case "invalid-email":
            errorMessage = "Error: invalid email format";
          case "user-disabled":
            errorMessage = "Error: this user has been disabled";
          case "user-not-found":
            errorMessage = "Error: user with this email does not exist";
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
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // main image
            ClipRRect(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: SizeConfig.heightPercentage(45),
                ),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/login_image.jpg'),
                    )
                ),
              ),
            ),
            SizedBox(height: SizeConfig.heightPercentage(1)),
            Padding(
              padding: EdgeInsets.all(SizeConfig.minPercentage(4)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('EcoQuest',
                    style: TextStyle(
                        fontSize:SizeConfig.heightPercentage(4.2),
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(SizeConfig.minPercentage(5)),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey.shade300,
                            width: 2
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Column(
                      children: [
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
                        TextFieldLabelInside('Email', 'example@email.com', emailController),
                        SizedBox(height: SizeConfig.heightPercentage(1)),
                        TextFieldLabelInside('Password', 'password', passwordController, true),
                        SizedBox(height: SizeConfig.heightPercentage(2)),
                        CenteredElevatedButton(login, 'Login'),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.heightPercentage(2)),
                  Row(
                    children: [
                      Text('Don\'t have an account? '),
                      InkWell(
                        child: Text('Sign up', style: TextStyle(color: Colors.blue),),
                        onTap: () {
                          widget.swapPages!();
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}