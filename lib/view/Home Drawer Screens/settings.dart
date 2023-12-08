import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  var status = false;
  @override
  Widget build(BuildContext context) {
    final height = Get.height;
    final width = Get.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: TextClass(
            fontColor: Colors.black,
            fontWeight: FontWeight.w600,
            size: 20,
            title: 'Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextClass(
                    size: 18,
                    fontWeight: FontWeight.w400,
                    title: 'Push Notifications',
                    fontColor: Colors.black),
                FlutterSwitch(
                  activeColor: primaryDark,
                  width: width * .2,
                  height: height * .042,
                  // valueFontSize: 14,
                  toggleSize: 40.0,
                  value: status,
                  borderRadius: 30.0,

                  onToggle: (val) {
                    setState(() {
                      status = val;
                      print(status);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
