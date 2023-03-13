import 'dart:math';

import 'package:app_v1/pages/4_water.dart';
import 'package:app_v1/pages/5_air.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SystemMonitorBox extends StatelessWidget {
  //variables
  final String systemName;
  final String iconPath;
  final bool powerOn;
  void Function(bool)? onChanged; //function for on change

  SystemMonitorBox({
    super.key,
    required this.systemName,
    required this.iconPath,
    required this.powerOn,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("pressed");
        if (systemName.toLowerCase().contains("water")) {
          print("call water");

          // Navigator.push(context, MaterialPageRoute(builder: (context) => const WaterPage());
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WaterPage()),
          );
        } else if (systemName.toLowerCase().contains("air")) {
          print("Call Air filter");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AirPage()),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0), //10
        child: Container(
          decoration: BoxDecoration(
            color: powerOn
                ? Colors.deepPurple
                : Colors.grey[300], //if power on or off
            // color: Colors.grey[300], //200
            // color: Colors.white,//200
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 25),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  iconPath,
                  height: 50,
                  color: powerOn
                      ? Colors.white
                      : Colors.grey[850], //if power on or off
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //name
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          systemName,
                          style: GoogleFonts.openSans(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: powerOn
                                ? Colors.white
                                : Colors.grey[850], //if power on or off
                          ),
                        ),
                      ),
                    ),

                    //Power swtich
                    CupertinoSwitch(
                      // activeColor: Colors.black,
                      value: powerOn,
                      onChanged: onChanged,
                    ),
                    /*
                    Transform.rotate(
                      angle: pi/2,
                      child: CupertinoSwitch(
                        // activeColor: Colors.black,
                        value: powerOn,
                        onChanged: onChanged,
                      ),
                    )
                     */
                  ],
                ),

                // SizedBox(height: 20,),

                //power switch
              ]),
        ),
      ),
    );
  }
}

/*---before trying to add ontap-----------------------
@override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0), //10
      child: Container(
        decoration: BoxDecoration(
          color: powerOn
              ? Colors.deepPurple
              : Colors.grey[300], //if power on or off
          // color: Colors.grey[300], //200
          // color: Colors.white,//200
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(vertical: 25),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                iconPath,
                height: 50,
                color: powerOn
                    ? Colors.white
                    : Colors.grey[850], //if power on or off
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //name
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        systemName,
                        style: GoogleFonts.openSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: powerOn
                              ? Colors.white
                              : Colors.grey[850], //if power on or off
                        ),
                      ),
                    ),
                  ),

                  //Power swtich
                  CupertinoSwitch(
                    // activeColor: Colors.black,
                    value: powerOn,
                    onChanged: onChanged,
                  ),
                  /*
                  Transform.rotate(
                    angle: pi/2,
                    child: CupertinoSwitch(
                      // activeColor: Colors.black,
                      value: powerOn,
                      onChanged: onChanged,
                    ),
                  )
                   */
                ],
              ),

              // SizedBox(height: 20,),

              //power switch
            ]),
      ),
    );
  }

 */
