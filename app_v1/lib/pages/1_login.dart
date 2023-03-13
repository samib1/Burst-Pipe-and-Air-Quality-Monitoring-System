// ignore: file_names
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:app_v1/pages/2_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  // final VoidCallback showSignUpPage; //method that will show our register page
  // const LoginPage({super.key, required this.showSignUpPage});

  @override //Since an inheriting stateful so need overrice
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Text filed Controllers: i.e., the email and password controllers
  //So we can keep track of what the user types
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //Login method called when user presses login bttn
  // void login() {
  // }
  Future login() async {
    //using async coz will login in with user email and passpwor
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());
  }

  @override
  void dispose() {
    //to help with memory management to clean up the controllers
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Subject to change the background color
      backgroundColor: Colors.grey[50],
      // backgroundColor: Colors.pink[50],
      // backgroundColor: Colors.black,
      // backgroundColor: Colors.blue.shade50,

      //Body will be a big column and will have our content there
      //Wraped in safe area: so that the text is weel spread out
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              //Icon subject to change **REPLACE**
              // Icon(Icons.wifi, size:50),
              Icon(Icons.add_home_work, size: 70),

              //Text "G12: IHMS"
              Text(
                'G12 IHMS',
                style: GoogleFonts.bebasNeue(
                  fontSize: 70,
                ),
              ),

              //Space between our texts
              // SizedBox(height: 10),

              //Text "IoT Home Monitoring System"
              Text(
                'IoT Home Monitoring System',
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              //Space between our texts
              SizedBox(height: 40),

              //Email textfield
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 25), //so box not on the edge
              //     child: TextField(
              //       decoration: InputDecoration(
              //         // icon: Icon(
              //         //   Icons.email,
              //         //   color: Colors.deepPurple,
              //         //   // color: Colors.black,
              //         // ),
              //         enabledBorder: OutlineInputBorder(
              //           borderSide: BorderSide(color: Colors.white),
              //           borderRadius: BorderRadius.circular(15),
              //         ),
              //         focusedBorder: OutlineInputBorder(
              //           borderSide: BorderSide(color: Colors.deepPurple),
              //           borderRadius: BorderRadius.circular(15)
              //         ),
              //         // border: InputBorder.none,
              //         hintText: 'Email',
              //         fillColor: Colors.grey[200],
              //         filled: true,
              //       ),
              //     ),
              // ),

              // Textfield (email)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25), //so box not on the edge
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200], //box color
                    border: Border.all(color: Colors.white), //box border
                    borderRadius:
                        BorderRadius.circular(15), //corner on the text field
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextField(
                      controller: _emailController, //For the email text field
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.email,
                          color: Colors.deepPurple,
                          // color: Colors.black,
                        ),
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                    ),
                  ),
                ),
              ),

              //Space between our textfield
              SizedBox(height: 10),

              //Textfield (password)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25), //so box not on the edge
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200], //box color
                    border: Border.all(color: Colors.white), //box border
                    borderRadius:
                        BorderRadius.circular(15), //corner on the text field
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextField(
                      controller:
                          _passwordController, //For the password text field
                      obscureText: true, //So password not displayed
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.lock,
                          // color: Colors.black,
                          color: Colors.deepPurple,
                        ),
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
                    ),
                  ),
                ),
              ),

              //Space between our button
              SizedBox(height: 10),

              //Button (Login)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25), //white space on the side
                child: GestureDetector(
                  onTap: login, //Our login method
                  // onTap: widget.showSignUpPage,
                  child: Container(
                    padding: EdgeInsets.all(15), //make my sign box bigger
                    decoration: BoxDecoration(
                      color: Colors.deepPurple, //color of the box
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                        child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )),
                  ),
                ),
              ),

              //Space between our button
              SizedBox(height: 40),

              //Text "Don't have an account? signup"
              //This will lead to opening the register page
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, //putting in the middle
                children: [
                  Text('Don\'t have an account? ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  GestureDetector(
                    //want to open sigup on tapping this
                    // onTap: widget.showSignUpPage,
                    // onTap: () => print('On tap runing'),
                    // onTap: login,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: Text(
                      'Signup',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    ); //Scaffold is the login screen we want
  }
}
