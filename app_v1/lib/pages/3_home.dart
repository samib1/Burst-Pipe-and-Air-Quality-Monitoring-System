// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ffi';

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
  //Padding constants
  final double horizontalPadding = 30; //40
  final double verticalPadding = 15; //25

//---------------getting the db info to be used in ontop----------------------
  // DatabaseReference database = FirebaseDatabase.instance.ref().child("User-Data"); //gets all user data

  // late DatabaseReference
  //     databaseRef; //initialized in state?? cant i just use the same as above

  // DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  late DatabaseReference dbAir;
  late DatabaseReference dbwater;

  String realTimeVal = "Testing";
  late bool automateFilter;
  // static late bool filterIsOn = false;
  static bool filterIsOn = false;
  late int aqiVal;
  // late double coVal;
  late double tvocVal;
  late double pm10Val;
  late double pm5Val;
  late bool poorAirNotification;

  late bool automateVale;
  // static late bool valveIsOpen;
  static late bool valveIsOpen = false;
  late double coldTempVal;
  late double hotTempVal;
  late bool pipeBurstNotification;

  //List of our systems: want systemName, icon, powerstatus
  List systemsMonitored = [
    ["Water supply", "lib/icons/water_supply.png", valveIsOpen],
    ["Air Filter", "lib/icons/air_filter.png", filterIsOn],
    // ["Air quality", "lib/icons/air_quality.png", true],
    // D:\dev\sandbox\app_v1\lib\icons\water_supply.png
  ];

  @override
  void initState() {
    super.initState();
    // databaseRef = FirebaseDatabase.instance.ref();

    dbAir = FirebaseDatabase.instance
        .ref()
        .child("User-Data")
        .child(user.uid)
        .child("Air-Monitor-System");

    dbwater = FirebaseDatabase.instance
        .ref()
        .child("User-Data")
        .child(user.uid)
        .child("System-Water-Monitor");

    //Listeners for my values so its always listening to the db. When i click them i will be update
    dbAir.child("AQI").onValue.listen((event) {
      // print("The AQI IS " + event.snapshot.value.toString());
      setState(() {
        aqiVal = int.parse(event.snapshot.value.toString());
      });
    });

    // dbwater.child("Filter-Is-On").onValue.listen((event) {
    dbwater.child("Filter-On-Command").onValue.listen((event) {
      // print("before init " + filterIsOn.toString());
      // print("The valve state is " + event.snapshot.value.toString());
      setState(() {
        filterIsOn = convertStringToBool(event.snapshot.value.toString());
      });
      // print("after init " + filterIsOn.toString());
    });

    dbAir.child("Apm-10").onValue.listen((event) {
      setState(() {
        pm10Val = double.parse(event.snapshot.value.toString());
      });
    });

    dbAir.child("Apm-2-5").onValue.listen((event) {
      setState(() {
        pm5Val = double.parse(event.snapshot.value.toString());
      });
    });

    // dbAir.child("CO2").onValue.listen((event) {
    //   setState(() {
    //     coVal = double.parse(event.snapshot.value.toString());
    //   });
    // });

    dbAir.child("tVOC").onValue.listen((event) {
      setState(() {
        tvocVal = double.parse(event.snapshot.value.toString());
      });
    });

    // dbwater.child("Is-Valve-Open").onValue.listen((event) {
    dbwater.child("Command-Open-Valve").onValue.listen((event) {
      // print("before init " + valveIsOpen.toString());
      // // print("The valve state is " + event.snapshot.value.toString());
      // setState(() {
      //   // valveIsOpen = convertStringToBool(event.snapshot.value.toString());
      //   print("--------Valve state changed in db");
      //   if (event.snapshot.value.toString().toLowerCase() == "true") {
      //     valveIsOpen = true;
      //   } else if (event.snapshot.value.toString().toLowerCase() == "false") {
      //     valveIsOpen = false;
      //   }
      // });
      // print("after init " + valveIsOpen.toString());
      print("\n----IN VALVEL IS OPEN METHOD---------");
      print("before change in db=>$valveIsOpen");
      valveIsOpen = convertStringToBool(event.snapshot.value.toString());
      print("after change in db=>$valveIsOpen");
      print("\n");
    });

    dbwater.child("Data-Cold-Temp").onValue.listen((event) {
      setState(() {
        coldTempVal = double.parse(event.snapshot.value.toString());
      });
    });

    dbwater.child("Data-Hot-Temp").onValue.listen((event) {
      setState(() {
        hotTempVal = double.parse(event.snapshot.value.toString());
      });
    });
  }

  bool convertStringToBool(String val) {
    bool result = false;
    if (val.toLowerCase() == "true") {
      result = true;
    } else if (val.toLowerCase() == "false") {
      result = false;
    }
    return result;
  }

  void printDBInfo() {
    // dbAir.update({"AQI": 1});
    // dbwater.update({"Is-Valve-Open": valveIsOpen});
    print("\n^^^^^^^^^^^in print test^^^^^^^^^^^^");
    print("The valveis => $valveIsOpen");
    print("The Cold temp => $coldTempVal");
    print("The hot temp => $hotTempVal");

    print("The filteris => $filterIsOn");
    print("The aqi is => $aqiVal");
    print("The PM10 is => $pm10Val");
    print("The PM2 is => $pm5Val");
    // print("The C0 is $coVal");
    print("The TVOC is $tvocVal");
    print("^^^^^^done printing^^^^^^\n\n");
  }
  //---------------done---------------------------------------------------------

  //whenever power button is changed called in card view
  void powerSwitchChanged(bool value, int index) {
    print("FROM THE ON SWITCH $value");
    setState(() {
      // systemsMonitored[index][2] = value;
      if (systemsMonitored[index][0] == "Water supply") {
        // dbwater.update({"Is-Valve-Open": value});
        dbwater.update({"Command-Open-Valve": value});
        systemsMonitored[index][2] = value;
        valveIsOpen = value;
      } else if (systemsMonitored[index][0] == "Air Filter") {
        dbAir.update({"Filter-On-Command": value});
        systemsMonitored[index][2] = value;
        filterIsOn = value;
      }

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

/*BEFORE ONTAP------------------------------------------------------------------
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
                        // powerOn: valveIsOpen,
                        onChanged: (value) => powerSwitchChanged(value, index),
                        
                      );
                    })),
-------------------------------------------------------------------------------*/
            //ADDING REVISED CARD VIEW TO ACCOUNT FOR ONTAP

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
                        // powerOn: [valveIsOpen, filterIsOn],
                        onChanged: (value) => powerSwitchChanged(value, index),
                      );
                    })),

//--------------- NEW CARD VIEW WITH DYNAMIC VALUES
            SizedBox(
              height: 5,
            ),

/*            //Card view
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                cardMenu(title: "Test", icon: "lib/icons/water_supply.png"),
              ],
            ),
*/
/**TESTING READING AND WRITING---------------------------------------------- */
// /*            //Button (Login)
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
// */
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

  Widget cardMenu({
    required String title,
    required String icon,
    VoidCallback? onTap,
    Color color = Colors.white,
    Color fontColor = Colors.grey,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        child: Column(children: [
          Image.asset(
            icon,
            height: 50,
          ),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ]),
      ),
    );
  }
}

//-----------------------------------------------------------------------------

