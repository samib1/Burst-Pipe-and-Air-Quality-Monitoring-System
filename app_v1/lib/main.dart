import 'package:app_v1/auth/0_main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/1_login.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  //async want to continously access firebase

  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(); //intialize firebase

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //remove the debug banner
      debugShowCheckedModeBanner: false,

      //On running bring the main page: where we will call loginpage i.e., 0_main_page.dart
      home: MainPage(),
    );
  }
}
