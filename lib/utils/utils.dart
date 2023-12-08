import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/color.dart';

// import 'package:getx_mvvm/res/colors/app_color.dart';
class Utils {
  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static toastMessage(String message, bool error) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: error ? Colors.red : primaryDark,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static toastMessageCenter(String message, bool error) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: error ? Colors.red : primaryDark,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_SHORT,
      textColor: Colors.white,
    );
  }

  static snackBar(String title, String message, bool error) {
    Get.snackbar(title, message,
       
        backgroundColor: error == true ? Colors.red : primaryDark,
        colorText: Colors.white);
  }
  
}
