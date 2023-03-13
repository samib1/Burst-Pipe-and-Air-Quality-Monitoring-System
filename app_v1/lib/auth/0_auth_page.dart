import 'package:app_v1/pages/1_login.dart';
import 'package:flutter/material.dart';

import '../pages/2_register.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<StatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  //Default = show the login page
  bool showLoginPage = true;

  //switch screen mthds: used in my build to show either signup or login page NEEDED THIS FOR ON TAP BUT USING NAV
  // void switchScreens() {
  //   setState(() {
  //     showLoginPage != showLoginPage;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      // return LoginPage(showSignUpPage: switchScreens);
      return LoginPage();
    } else {
      //If on sign up show login page
      // return SignUpPage(showLoginPage: switchScreens);
      return SignUpPage();
    }
  }
}
