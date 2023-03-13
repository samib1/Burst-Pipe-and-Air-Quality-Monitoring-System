//------------------------------------------------------------------------------
import 'package:app_v1/pages/1_login.dart';
import 'package:app_v1/pages/3_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter/cupertino.dart';
//------------------------------------------------------------------------------

//Airpage ----------------------------------------------------------------------
class AirPage extends StatefulWidget {
  const AirPage({super.key});
  @override
  State<StatefulWidget> createState() => _AirPageState();
}
//------------------------------------------------------------------------------

//Air page states --------------------------------------------------------------
class _AirPageState extends State<AirPage> {
  final double horizontalPadding = 30; //40
  final double verticalPadding = 10; //25

  //For bttn clicking -----------------
  late bool clickedAQI = true;
  late bool clickedAmp10 = false;
  late bool clickedAmp25 = false;
  late bool clickedTVOC = false;
  late bool clickedCO2 = false;
  //-----------------------------------

  //Database reference ----------------
  late DatabaseReference dbair;
  //-----------------------------------

  //Data values------------------------
  late double aqiVal = 0;
  late double amp10Val = 0;
  late double amp25Val = 0;
  late double tvocVal = 0;
  late double co2Val = 0;
  //-----------------------------------

  //Max sensor vals--------------------
  final MAXAQI = 500;
  final MAXAMP10 = 100;
  final MAXAPM25 = 100;
  final MAXTVOC = 100;
  final MAXCO2 = 40000;
  //-----------------------------------

  //Poor air quality wanrning ---------
  late bool airWarning = false;
  late String airWarningText = "Good air quality";
  //-----------------------------------

  //Filter configuration --------------
  late String filterIsOn = "Filter Status";
  late bool automateWaterSupply = false;
  late bool turnFilter = false;

  //-----------------------------------

  final user = FirebaseAuth.instance.currentUser!;

  //DB configuration -----------------------------------------------------------
  void initState() {
    super.initState();
    dbair = FirebaseDatabase.instance
        .ref()
        .child("User-Data")
        .child(user.uid)
        .child("System-Air-Monitor");

    //Data values -------------------------------------
    dbair.child("Data-AQI").onValue.listen((event) {
      setState(() {
        aqiVal = double.parse(event.snapshot.value.toString());
      });
    });

    dbair.child("Data-Apm10").onValue.listen((event) {
      setState(() {
        amp10Val = double.parse(event.snapshot.value.toString());
      });
    });

    dbair.child("Data-Apm2-5").onValue.listen((event) {
      setState(() {
        amp25Val = double.parse(event.snapshot.value.toString());
      });
    });

    dbair.child("Data-TVOC").onValue.listen((event) {
      setState(() {
        tvocVal = double.parse(event.snapshot.value.toString());
      });
    });

    dbair.child("Data-CO2").onValue.listen((event) {
      setState(() {
        co2Val = double.parse(event.snapshot.value.toString());
      });
    });
    //-------------------------------------------------

    //Air quality warning -----------------------------
    dbair.child("Warning-Poor-Air-Quality").onValue.listen((event) {
      if (event.snapshot.value.toString() == "false") {
        airWarningText = "Good air quality";
      } else if (event.snapshot.value.toString() == "true") {
        airWarningText = "Warning: POOR AIR QUALITY DETECTED";
      }
      airWarning = convertStringToBool(event.snapshot.value.toString());
    });
    //-------------------------------------------------

    //Filter configuration ----------------------------
    dbair.child("Command-Automate-System").onValue.listen((event) {
      automateWaterSupply =
          convertStringToBool(event.snapshot.value.toString());
    });

    dbair.child("Command-Filter-On").onValue.listen((event) {
      turnFilter = convertStringToBool(event.snapshot.value.toString());
    });

    dbair.child("Is-Filter-On").onValue.listen((event) {
      if (event.snapshot.value.toString() == "false") {
        filterIsOn = "Filter Status: Off";
      } else if (event.snapshot.value.toString() == "true") {
        filterIsOn = "Filter Status: On";
      }
    });
    //-------------------------------------------------
  }
  //----------------------------------------------------------------------------

  //Function to convert string to bool------------------------------------------
  bool convertStringToBool(String val) {
    bool result = false;
    if (val.toLowerCase() == "true") {
      result = true;
    } else if (val.toLowerCase() == "false") {
      result = false;
    }
    return result;
  }
  //----------------------------------------------------------------------------

  //Clean up -------------------------------------------------------------------
  @override
  void dispose() {
    super.dispose();
  }
  //----------------------------------------------------------------------------

  //Widget ---------------------------------------------------------------------
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
                        "Air Supply",
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
                  // color: airWarning
                  //     ? Colors.red[800]
                  //     : Colors.deepPurple, //if power on or off
                ),
              ),
            ),

            SizedBox(
              height: 15,
            ),

            //Percent indicator-------------------------------------------------
            Expanded(
                child: ListView(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              physics: BouncingScrollPhysics(),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    rounderButton(
                      // title: "Hot water Line",
                      title: "AQI",
                      isActive: clickedAQI,
                      onTap: () {
                        // clickedCold = false;
                        // clickedAQI = true;
                        print("Running on AQI button\n\n");
                        setState(() {
                          clickedAQI = true;
                          clickedCO2 = false;
                          clickedTVOC = false;
                          clickedAmp10 = false;
                          clickedAmp25 = false;
                        });
                      },
                    ),
                    rounderButton(
                      title: "CO2",
                      isActive: clickedCO2,
                      onTap: () {
                        // clickedCold = false;
                        // clickedAQI = true;
                        print("Running on CO2 button\n\n");
                        setState(() {
                          clickedAQI = false;
                          clickedCO2 = true;
                          clickedTVOC = false;
                          clickedAmp10 = false;
                          clickedAmp25 = false;
                        });
                      },
                    ),
                    rounderButton(
                      title: "tVOC",
                      isActive: clickedTVOC,
                      onTap: () {
                        // clickedCold = false;
                        // clickedAQI = true;
                        print("Running on tvoc button\n\n");
                        setState(() {
                          clickedAQI = false;
                          clickedCO2 = false;
                          clickedTVOC = true;
                          clickedAmp10 = false;
                          clickedAmp25 = false;
                        });
                      },
                    ),
                    rounderButton(
                      title: "Apm10",
                      isActive: clickedAmp10,
                      onTap: () {
                        // clickedCold = false;
                        // clickedAQI = true;
                        print("Running on amp10 button\n\n");
                        setState(() {
                          clickedAQI = false;
                          clickedCO2 = false;
                          clickedTVOC = false;
                          clickedAmp10 = true;
                          clickedAmp25 = false;
                        });
                      },
                    ),
                    rounderButton(
                      title: "Apm2-5",
                      isActive: clickedAmp25,
                      onTap: () {
                        // clickedAQI = false;
                        setState(() {
                          clickedAQI = false;
                          clickedCO2 = false;
                          clickedTVOC = false;
                          clickedAmp10 = false;
                          clickedAmp25 = true;
                        });
                        // clickedCold = true;
                        print("Running on amp25 button\n\n");
                      },
                    ),
                  ],
                ),
                SizedBox(height: 15),
                //Button click indicators --------------------------------------
                if (clickedAQI) ...[
                  Text(
                    // hotWarningText,
                    airWarningText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      // DO THE POOR AIR QUALITY WARNING HERE
                      color: airWarning
                          ? Colors.red[800]
                          : Colors.deepPurple, //if power on or off
                      // : Colors.greenAccent[400], //if power on or off
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircularPercentIndicator(
                    radius: 100,
                    lineWidth: 20,
                    percent: aqiVal / MAXAQI, //can use my temp values
                    // percent:0.75,
                    // percent: double.parse(data.percentage) / 100,//can use my temp values
                    // progressColor: Colors.deepPurple,
                    progressColor: Colors.red[800],
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    center: Text(
                      "$aqiVal",
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
                ] else if (clickedCO2) ...[
                  Text(
                    // hotWarningText,
                    airWarningText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      // DO THE POOR AIR QUALITY WARNING HERE
                      color: airWarning
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
                    percent: co2Val / MAXCO2, //can use my temp values
                    // percent:0.75,
                    // percent: double.parse(data.percentage) / 100,//can use my temp values
                    // progressColor: Colors.deepPurple,
                    progressColor: Colors.blue,
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    center: Text(
                      "$co2Val",
                      // "26\u00B0C",
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        // color: Colors.grey[850],
                        // color: Colors.deepPurple,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ] else if (clickedTVOC) ...[
                  Text(
                    // hotWarningText,
                    airWarningText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      // DO THE POOR AIR QUALITY WARNING HERE
                      color: airWarning
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
                    percent: tvocVal / MAXTVOC, //can use my temp values
                    // percent:0.75,
                    // percent: double.parse(data.percentage) / 100,//can use my temp values
                    // progressColor: Colors.deepPurple,
                    progressColor: Colors.green,
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    center: Text(
                      "$tvocVal",
                      // "26\u00B0C",
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        // color: Colors.grey[850],
                        // color: Colors.deepPurple,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ] else if (clickedAmp10) ...[
                  Text(
                    // hotWarningText,
                    airWarningText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      // DO THE POOR AIR QUALITY WARNING HERE
                      color: airWarning
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
                    percent: amp10Val / MAXAMP10, //can use my temp values
                    // percent:0.75,
                    // percent: double.parse(data.percentage) / 100,//can use my temp values
                    // progressColor: Colors.deepPurple,
                    progressColor: Colors.pinkAccent,
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    center: Text(
                      "$amp10Val",
                      // "26\u00B0C",
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        // color: Colors.grey[850],
                        // color: Colors.deepPurple,
                        color: Colors.pinkAccent,
                      ),
                    ),
                  ),
                ] else if (clickedAmp25) ...[
                  Text(
                    // hotWarningText,
                    airWarningText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      // DO THE POOR AIR QUALITY WARNING HERE
                      color: airWarning
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
                    percent: amp25Val / MAXAPM25, //can use my temp values
                    // percent:0.75,
                    // percent: double.parse(data.percentage) / 100,//can use my temp values
                    // progressColor: Colors.deepPurple,
                    progressColor: Colors.yellow[800],
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    center: Text(
                      "$amp25Val",
                      // "26\u00B0C",
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        // color: Colors.grey[850],
                        // color: Colors.deepPurple,
                        color: Colors.yellow[800],
                      ),
                    ),
                  ),
                ]
                //--------------------------------------------------------------
              ],
            )),
            //------------------------------------------------------------------

            //Divider ----------------------------------------------------------
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Divider(
                // color: Colors.deepPurple,
                color: Colors.grey[400],
                thickness: 2,
              ),
            ),
            //------------------------------------------------------------------

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
                      //System configuration -----------------------------------
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
                            // color: airWarning
                            //     ? Colors.red[800]
                            //     : Colors.deepPurple, //if power on or off
                          ),
                        ),
                      ),
                      //--------------------------------------------------------

                      //Automate the system ------------------------------------
                      Row(
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
                      //--------------------------------------------------------

                      //Turn on or off the filter ------------------------------
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 45),
                            child: Text(
                              "Turn on/off Air filter",
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                // color: Colors.grey[850],
                                color: turnFilter
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
                              value: turnFilter,
                              onChanged: turnFilterFunction,
                            ),
                          ),
                        ],
                      ),

                      // Text(filterIsOn),
                      Text(
                        filterIsOn,
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
            // EdgeInsets.symmetric(horizontal: 20, vertical: verticalPadding),
            EdgeInsets.symmetric(horizontal: 10, vertical: verticalPadding),
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
    setState(() {
      dbair.update({"Command-Automate-System": value});
      automateWaterSupply = value;
    });
  }

  void turnFilterFunction(bool value) {
    print("Valve is being pressed");
    setState(() {
      dbair.update({"Command-Filter-On": value});
      turnFilter = value;
    });
  }
}
