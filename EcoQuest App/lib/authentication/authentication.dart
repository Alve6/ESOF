import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/pages/home_page.dart';

import '../helper/size_config.dart';
import '../pages/login_page.dart';
import '../pages/signup_page.dart';


class Authentication extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool loginPage = true;

  void togglePages() {
    setState(() {
      loginPage = !loginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); // initialize the responsive size class
    if(loginPage) {
      return LoginPage(swapPages: togglePages);
    }
    else {
      return SignUpPage(swapPages: togglePages);
    }
  }
}

class AuthenticationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return HomePage();
            }
            else {
              return Authentication();
            }
          }
      )
    );
  }
}