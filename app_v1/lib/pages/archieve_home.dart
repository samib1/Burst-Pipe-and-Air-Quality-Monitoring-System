// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:app_v1/components/sys_monitor_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  // final userId = user.uid;
  //Padding constants
  final double horizontalPadding = 30; //40
  final double verticalPadding = 15; //25

  //List of our systems: want systemName, icon, powerstatus
  List systemsMonitored = [
    ["Water supply", "lib/icons/water_supply.png", true],
    ["Air Filter", "lib/icons/air_filter.png", true],
    ["Air quality", "lib/icons/air_quality.png", true],
    // D:\dev\sandbox\app_v1\lib\icons\water_supply.png
  ];

  //whenever power button is changed called in card view
  void powerSwitchChanged(bool value, int index) {
    print("FROM THE ON SWITCH $value");
    setState(() {
      systemsMonitored[index][2] = value;
      // ??WILL NEED TO SEND THIS TO THE FIREBASE TO TURN ON OR OFF THE SYS
      print("----------Power status------------");
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[200],//50
      // backgroundColor: Colors.white,
      backgroundColor: Colors.grey[50], //50

      // body
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, //So text not centered
          children: [
            // app bar: two icons
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: verticalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //menu icon: ?? ADD FUNCTION TO OPEN DRAWER MENU BAR
                  Icon(
                    Icons.menu,
                    // color: Colors.deepPurple,
                    size: 40,
                  ),

                  //Notification icon: ??ADD FUNCTION TO OPEN NOTIFICATIONS OR SIMPLY ADD VALUE WHEN HAVE ISSUE
                  Icon(
                    Icons.notifications,
                    // color: Colors.deepPurple,
                    size: 30, //30
                  )

                  //notification icon
                ],
              ),
            ),

            // Space between app bar and text
            SizedBox(
              height: 10,
            ),

            // Welcom text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome home,",
                      style: GoogleFonts.openSans(
                        fontSize: 20,
                        // color: Colors.grey[700],
                        // color: Colors.deepPurple,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[850],
                      )),
                  Text(
                    "" + user.email! + "",
                    style: GoogleFonts.bebasNeue(
                      // fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.grey[850],
                      // color: Colors.deepPurple,
                    ),
                  ),
                  // SizedBox(height: 10,),
                ],
              ),
            ),

            // Space between txt and systems
            SizedBox(
              height: 10,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Divider(
                // color: Colors.deepPurple,
                color: Colors.grey[400],
                thickness: 2,
              ),
            ),

            SizedBox(
              height: 10,
            ),

            //Systems being monitored text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text("Systems being Monitored",
                  style: GoogleFonts.openSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[850],
                  )),
            ),

            // SizedBox(
            //   height: 5,
            // ),
            // Card view for systems [water, filter, quality] w/ switch

            // Calls devices page
            Expanded(
                child: GridView.builder(
                    itemCount: systemsMonitored.length, //how many we want
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    // padding: EdgeInsets.all(15
                    //     ), //this + one in sys_monitor_box padding must sum to my horizontal padding e.g., 15 + 25 = 40
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.9,
                    ), //means 2 boxes
                    itemBuilder: (context, index) {
                      //used to create our card thingy
                      return SystemMonitorBox(
                        systemName: systemsMonitored[index]
                            [0], //name is on index 0
                        iconPath: systemsMonitored[index][1],
                        powerOn: systemsMonitored[index][2],
                        onChanged: (value) => powerSwitchChanged(value, index),
                      );
                    })),

/**TESTING READING AND WRITING---------------------------------------------- */
/*            //Button (Login)
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 25), //white space on the side
              child: GestureDetector(
                onTap: printDBInfo, //Our login method
                // onTap: widget.showSignUpPage,
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                      child: Text(
                    'Testing Read Write from DB',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )),
                ),
              ),
            ),
*/
//------------------------------------------------------------------------------

            //??SignOut Bttn to be cleaned and moved to DRAWER ICON
            MaterialButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              color: Colors.deepPurple[200],
              child: Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}

//-----------------------------------------------------------------------------



//----------------------ARCHIEVE------------------------------------------------

/*READING AND WRITING WORKS
  // DatabaseReference database = FirebaseDatabase.instance.ref().child("User-Data"); //gets all user data
  String realTimeVal = "Testing";
  // DatabaseReference database = FirebaseDatabase.instance.ref().child("User-Data/$user.uid"); //gets all user data

  void printDBInfo() {
    // Future printDBInfo() async {
    print("---------------Button pressed------------");
    print(realTimeVal);

    DatabaseReference database = FirebaseDatabase.instance
        .ref("User-Data/" + user.uid + "/count"); //gets all user data
    //GETS VALUES
    database.onValue.listen((event) {
      setState(() {
        realTimeVal = event.snapshot.value.toString();
      });
    });
    print(realTimeVal);
    print("**********Done Testing********************");

    //writes
    database.update({"count": 21});
  }
  */





/*TESTING READING STUFF------------------------------------------------------*/
  //SRC: https://firebase.google.com/docs/database/flutter/read-and-write
  /// final database = Firebase
  // final database = FirebaseDatabase.instance.ref();

  // DatabaseReference database =
  //     FirebaseDatabase.instance.ref().child("User-Data"); //gets all user data

  /*TASKS: 
    1. GET THESE VALUES FROM DB AND WRITE TO THEM in test
    2. write the methods in my app ui
  String realTimeVal = "Testing";
  bool filterOnCmd = false;
  bool openValveCmd = false;

  void READSVALUEFROMDB() {
    // Future printDBInfo() async {
    print("---------------Button pressed------------");
    print(realTimeVal);

    //GETS VALUES
    database.onValue.listen((event) {
      setState(() {
        realTimeVal = event.snapshot.value.toString();
      });
    });
    print(realTimeVal);
    print("**********Done Testing********************");
  }
  */

  /*
  // DatabaseReference database = FirebaseDatabase.instance.ref().child("User-Data"); //gets all user data
  String realTimeVal = "Testing";
  // DatabaseReference database = FirebaseDatabase.instance.ref().child("User-Data/$user.uid"); //gets all user data

  void printDBInfo() {
    // Future printDBInfo() async {
    print("---------------Button pressed------------");
    print(realTimeVal);

    DatabaseReference database = FirebaseDatabase.instance
        .ref("User-Data/" + user.uid + "/count"); //gets all user data
    //GETS VALUES
    database.onValue.listen((event) {
      setState(() {
        realTimeVal = event.snapshot.value.toString();
      });
    });
    print(realTimeVal);
    print("**********Done Testing********************");

    //writes
    database.update({"count": 21});
  }
  */
//------------------------------------------------------------------------------


/*TESTING READING STUFF: Works but issue was with resolved with 
srchttps://stackoverflow.com/questions/59913165/i-flutter-22027-missingpluginexceptionno-implementation-found-for-method-doc------------------------------------------------------*/
  //SRC: https://firebase.google.com/docs/database/flutter/read-and-write
  /// final database = Firebase
  // final database = FirebaseDatabase.instance.ref();

  // String realTimeVal = "Testing";
  // void printDBInfo() {
  //   // Future printDBInfo() async {
  //   print("---------------Button pressed------------");
  //   print(realTimeVal);

  //   DatabaseReference count = FirebaseDatabase.instance.ref().child("Count");
  //   count.onValue.listen((event) {
  //     // final data = event.snapshot.value;
  //     setState(() {
  //       realTimeVal = event.snapshot.value.toString();
  //     });
  //   });
  //   print(realTimeVal);
  //   print("**********Done Testing********************");
  // }
//------------------------------------------------------------------------------



//----------------------ARCHIEVE------------------------------------------------

/*READING AND WRITING WORKS
  // DatabaseReference database = FirebaseDatabase.instance.ref().child("User-Data"); //gets all user data
  String realTimeVal = "Testing";
  // DatabaseReference database = FirebaseDatabase.instance.ref().child("User-Data/$user.uid"); //gets all user data

  void printDBInfo() {
    // Future printDBInfo() async {
    print("---------------Button pressed------------");
    print(realTimeVal);

    DatabaseReference database = FirebaseDatabase.instance
        .ref("User-Data/" + user.uid + "/count"); //gets all user data
    //GETS VALUES
    database.onValue.listen((event) {
      setState(() {
        realTimeVal = event.snapshot.value.toString();
      });
    });
    print(realTimeVal);
    print("**********Done Testing********************");

    //writes
    database.update({"count": 21});
  }
  */

/*TESTING READING STUFF------------------------------------------------------*/
//SRC: https://firebase.google.com/docs/database/flutter/read-and-write
/// final database = Firebase
// final database = FirebaseDatabase.instance.ref();

// DatabaseReference database =
//     FirebaseDatabase.instance.ref().child("User-Data"); //gets all user data

/*TASKS: 
    1. GET THESE VALUES FROM DB AND WRITE TO THEM in test
    2. write the methods in my app ui
  String realTimeVal = "Testing";
  bool filterOnCmd = false;
  bool openValveCmd = false;

  void READSVALUEFROMDB() {
    // Future printDBInfo() async {
    print("---------------Button pressed------------");
    print(realTimeVal);

    //GETS VALUES
    database.onValue.listen((event) {
      setState(() {
        realTimeVal = event.snapshot.value.toString();
      });
    });
    print(realTimeVal);
    print("**********Done Testing********************");
  }
  */

/*
  // DatabaseReference database = FirebaseDatabase.instance.ref().child("User-Data"); //gets all user data
  String realTimeVal = "Testing";
  // DatabaseReference database = FirebaseDatabase.instance.ref().child("User-Data/$user.uid"); //gets all user data

  void printDBInfo() {
    // Future printDBInfo() async {
    print("---------------Button pressed------------");
    print(realTimeVal);

    DatabaseReference database = FirebaseDatabase.instance
        .ref("User-Data/" + user.uid + "/count"); //gets all user data
    //GETS VALUES
    database.onValue.listen((event) {
      setState(() {
        realTimeVal = event.snapshot.value.toString();
      });
    });
    print(realTimeVal);
    print("**********Done Testing********************");

    //writes
    database.update({"count": 21});
  }
  */
//------------------------------------------------------------------------------

/*TESTING READING STUFF: Works but issue was with resolved with 
srchttps://stackoverflow.com/questions/59913165/i-flutter-22027-missingpluginexceptionno-implementation-found-for-method-doc------------------------------------------------------*/
//SRC: https://firebase.google.com/docs/database/flutter/read-and-write
/// final database = Firebase
// final database = FirebaseDatabase.instance.ref();

// String realTimeVal = "Testing";
// void printDBInfo() {
//   // Future printDBInfo() async {
//   print("---------------Button pressed------------");
//   print(realTimeVal);

//   DatabaseReference count = FirebaseDatabase.instance.ref().child("Count");
//   count.onValue.listen((event) {
//     // final data = event.snapshot.value;
//     setState(() {
//       realTimeVal = event.snapshot.value.toString();
//     });
//   });
//   print(realTimeVal);
//   print("**********Done Testing********************");
// }
//------------------------------------------------------------------------------
