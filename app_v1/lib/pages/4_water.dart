import 'package:app_v1/pages/1_login.dart';
import 'package:app_v1/pages/3_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter/cupertino.dart';

class WaterPage extends StatefulWidget {
  const WaterPage({super.key});

  // final VoidCallback
  //     showLoginPage; //method allow us to show login page when we click on text have account
  // const SignUpPage({super.key, required this.showLoginPage});

  @override
  State<StatefulWidget> createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterPage> {
  // final double horizontalPadding = 20; //40
  // final double verticalPadding = 20; //25
  final double horizontalPadding = 30; //40
  // final double verticalPadding = 15; //25
  final double verticalPadding = 10; //25
  late bool clickedHot = true;
  late bool clickedCold = false;

  late DatabaseReference dbwater;
  // late bool valveIsOpen;
  late double coldTempVal = 0;
  late double hotTempVal = 0;
  late bool pipeBurstNotification;
  final user = FirebaseAuth.instance.currentUser!;

  late bool coldPipeBurstWarning = false;
  late String coldWarningText =
      "Cold Pipe is running"; // = "Cold pipe burst warning" + coldPipeBurstWarning.toString();

  late bool hotPipeBurstWarning = false;
  late String hotWarningText =
      "Hot Pipe is running"; // = "Cold pipe burst warning" + coldPipeBurstWarning.toString();

  late bool automateWaterSupply = false;
  late bool turnValve = false;
  late String valveIsOpenText =
      "Valve Status"; // = "Cold pipe burst warning" + coldPipeBurstWarning.toString();

  final MINTEMP = -100;
  final MAXTEMP = 100;

  void initState() {
    super.initState();
    // databaseRef = FirebaseDatabase.instance.ref();

    dbwater = FirebaseDatabase.instance
        .ref()
        .child("User-Data")
        .child(user.uid)
        .child("System-Water-Monitor");

    // dbwater.child("Is-Valve-Open").onValue.listen((event) {
    //   valveIsOpen = convertStringToBool(event.snapshot.value.toString());
    // });

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

    dbwater.child("Warning-Cold-Pipe-Burst").onValue.listen((event) {
      if (event.snapshot.value.toString() == "false") {
        coldWarningText = "Cold Pipe Running";
      } else if (event.snapshot.value.toString() == "true") {
        coldWarningText = "Warning: Cold Pipe Burst Detected";
      }
      coldPipeBurstWarning =
          convertStringToBool(event.snapshot.value.toString());
    });

    dbwater.child("Warning-Hot-Pipe-Bursts").onValue.listen((event) {
      if (event.snapshot.value.toString() == "false") {
        hotWarningText = "Hot Pipe Running";
      } else if (event.snapshot.value.toString() == "true") {
        hotWarningText = "Warning: Hot Pipe Burst Detected";
      }
      hotPipeBurstWarning =
          convertStringToBool(event.snapshot.value.toString());
    });

    dbwater.child("Command-Automate-System").onValue.listen((event) {
      automateWaterSupply =
          convertStringToBool(event.snapshot.value.toString());
    });

    dbwater.child("Command-Open-Valve").onValue.listen((event) {
      turnValve = convertStringToBool(event.snapshot.value.toString());
    });

    dbwater.child("Is-Valve-Open").onValue.listen((event) {
      if (event.snapshot.value.toString() == "false") {
        valveIsOpenText = "Valve Status: Closed";
      } else if (event.snapshot.value.toString() == "true") {
        valveIsOpenText = "Valve Status: Open";
      }
    });

    //--------------------------------------
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, //So text not centered
          children: [
// app bar: BACK ICON AND Water supply line text
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: verticalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //menu icon: ?? ADD FUNCTION TO OPEN DRAWER MENU BAR
                  GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons
                            .keyboard_double_arrow_left, // color: Colors.deepPurple,
                        // Icons.arrow_back_ios, // color: Colors.deepPurple
                        size: 40,
                        // color: Colors.deepPurple,
                        color: Colors.grey[850],
                      )),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Water Supply",
                        // style: GoogleFonts.bebasNeue(
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          // // color: Colors.grey[850],
                          // color: Colors.deepPurple,
                          // fontWeight: FontWeight.w500,
                          color: Colors.grey[850],
                        ),
                      ),
                    ],
                  ),

                  //Notification icon: ??ADD FUNCTION TO OPEN NOTIFICATIONS OR SIMPLY ADD VALUE WHEN HAVE ISSUE
                  // Icon(
                  //   Icons.notifications,
                  //   // color: Colors.deepPurple,
                  //   size: 30, //30
                  // )

                  //notification icon
                ],
              ),
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
              height: 5,
            ),

            Center(
              child: Text(
                "Sensor Reading",
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  // color: Colors.deepPurple,
                  color: Colors.grey[850],
                  // color: hotPipeBurstWarning
                  //     ? Colors.red[800]
                  //     : Colors.deepPurple, //if power on or off
                ),
              ),
            ),

            SizedBox(
              height: 15,
            ),
            /*
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Sensor Reading",
                // textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.deepPurple,
                  // color: hotPipeBurstWarning
                  //     ? Colors.red[800]
                  //     : Colors.deepPurple, //if power on or off
                ),
              ),
            ),
            */

            //Percent indicator
            Expanded(
                child: ListView(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              physics: BouncingScrollPhysics(),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    rounderButton(
                      title: "Hot water Line",
                      isActive: clickedHot,
                      onTap: () {
                        // clickedCold = false;
                        // clickedHot = true;
                        print("Running on hotwater button\n\n");
                        setState(() {
                          clickedHot = true;
                          clickedCold = false;
                        });
                      },
                    ),
                    rounderButton(
                      title: "Cold water line",
                      isActive: clickedCold,
                      onTap: () {
                        // clickedHot = false;
                        setState(() {
                          clickedHot = false;
                          clickedCold = true;
                        });
                        // clickedCold = true;
                        print("Running on other button\n\n");
                      },
                    ),
                  ],
                ),
                SizedBox(height: 15),
                if (clickedHot) ...[
                  Text(
                    hotWarningText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      // color: Colors.deepPurple,
                      color: hotPipeBurstWarning
                          ? Colors.red[800]
                          : Colors.deepPurple, //if power on or off
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircularPercentIndicator(
                    radius: 100,
                    lineWidth: 20,
                    percent: hotTempVal / MAXTEMP, //can use my temp values
                    // percent:0.75,
                    // percent: double.parse(data.percentage) / 100,//can use my temp values
                    // progressColor: Colors.deepPurple,
                    progressColor: Colors.red[800],
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    center: Text(
                      "$hotTempVal\u00B0C",
                      // "26\u00B0C",
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        // color: Colors.grey[850],
                        // color: Colors.deepPurple,
                        color: Colors.red[800],
                      ),
                    ),
                  ),
                ] else ...[
                  Text(
                    coldWarningText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      // color: Colors.deepPurple,
                      color: coldPipeBurstWarning
                          ? Colors.red[800]
                          : Colors.deepPurple, //if power on or off
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircularPercentIndicator(
                    radius: 100,
                    lineWidth: 20,
                    // percent:0.75,
                    percent: coldTempVal / MINTEMP, //can use my temp values
                    // progressColor: Colors.deepPurple,
                    progressColor: Colors.green[800],
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    center: Text(
                      "$coldTempVal\u00B0C",
                      // "26\u00B0C",

                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        // color: Colors.grey[850],
                        // color: Colors.deepPurple,
                        color: Colors.green[800],
                      ),
                    ),
                  ),
                ],
              ],
            )),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Divider(
                // color: Colors.deepPurple,
                color: Colors.grey[400],
                thickness: 2,
              ),
            ),

            // SizedBox(height: 20),
            SizedBox(
              height: 10,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding), //10

              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200], //box color
                  border: Border.all(color: Colors.white), //box border
                  borderRadius:
                      BorderRadius.circular(15), //corner on the text field
                ),
                child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          "Sytem Configuration",
                          // textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            // color: Colors.deepPurple,
                            color: Colors.grey[850],
                            // color: hotPipeBurstWarning
                            //     ? Colors.red[800]
                            //     : Colors.deepPurple, //if power on or off
                          ),
                        ),
                      ),
                      //SIZED BOX HERE to separate
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: Text(
                              "Automate System",
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                // color: Colors.grey[850],
                                color: automateWaterSupply
                                    ? Colors.deepPurple
                                    : Colors.grey[850], //if power on or off
                              ),
                            ),
                          ),

                          //Automate the system
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, left: 15.0),
                            child: CupertinoSwitch(
                              activeColor: Colors.deepPurple,
                              value: automateWaterSupply,
                              onChanged: automateWaterSupplyFunction,
                            ),
                          ),
                        ],
                      ),
                      //SIZED BOX HERE to separate
                      // Text("Valve status: use burst warning as guide"),
                      // SizedBox(height: 20,),
                      //SIZED BOX HERE to separate
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Text("Turn on/off water valve"),
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                              "Turn on/off water valve",
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                // color: Colors.grey[850],
                                color: turnValve
                                    ? Colors.deepPurple
                                    : Colors.grey[850], //if power on or off
                              ),
                            ),
                          ),
                          //Automate the system
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: CupertinoSwitch(
                              activeColor: Colors.deepPurple,
                              value: turnValve,
                              onChanged: turnValveFunction,
                            ),
                          ),
                        ],
                      ),

                      // Text(valveIsOpenText),
                      Text(
                        valveIsOpenText,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          // fontWeight: FontWeight.bold,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          fontSize: 15,
                          color: Colors.grey[850], //if power on or off
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),

//------------
                    ]),

//------------------------------------------------
              ),
            ),

            SizedBox(height: 25),

//------------------------------------------------------------------------------
          ],
        )));
  }

  Widget rounderButton(
      {required String title, required bool isActive, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // padding: EdgeInsets.symmetric(
        //     horizontal: horizontalPadding, vertical: verticalPadding),
        padding:
            EdgeInsets.symmetric(horizontal: 20, vertical: verticalPadding),
        decoration: BoxDecoration(
          color: isActive ? Colors.deepPurple : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.deepPurple),
        ),
        child: Text(
          title,
          style: GoogleFonts.openSans(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isActive
                ? Colors.white
                : Colors.deepPurple, //if power on or off
          ),
        ),
      ),
    );
  }

  void automateWaterSupplyFunction(bool value) {
    // print("-------Switch is pressed------");
    // print(value);
    // print("----Value is above---\n");
    setState(() {
      dbwater.update({"Command-Automate-System": value});
      automateWaterSupply = value;
    });
  }

  void turnValveFunction(bool value) {
    print("Valve is being pressed");
    setState(() {
      dbwater.update({"Command-Open-Valve": value});
      turnValve = value;
    });
  }
}

/*
Widget rounderButton({required String title, required bool isActive}) {
    return Container(
      // padding: EdgeInsets.symmetric(
      //     horizontal: horizontalPadding, vertical: verticalPadding),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: verticalPadding),
      decoration: BoxDecoration(
        color: isActive ? Colors.deepPurple : Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.deepPurple),
      ),
      child: Text(
        title,
        style: GoogleFonts.openSans(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color:
              isActive ? Colors.white : Colors.deepPurple, //if power on or off
        ),
      ),
    );
  }
*/

//  //Button (Login)
//           Padding(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: 25), //white space on the side
//             child: GestureDetector(
//               onTap: (() {
//                 print("testing");
//               }), //Our login method
//               // onTap: widget.showSignUpPage,
//               child: Container(
//                 padding: EdgeInsets.all(15), //make my sign box bigger

//                 decoration: BoxDecoration(
//                   color: Colors.deepPurple, //color of the box
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Center(
//                     child: Text(
//                   'Login',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 )),
//               ),
//             ),
//           ),
