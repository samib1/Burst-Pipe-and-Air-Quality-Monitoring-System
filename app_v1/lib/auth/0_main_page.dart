import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/3_home.dart';
import '0_auth_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //check none null user
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('home page should be opening');
          return HomePage();
        } else {
          print('*****************No user data**************');
          return AuthPage(); //if no info then show the login or signup pages i.e., 0_auth_page.dart
        }
      },
    ));
  }
}
