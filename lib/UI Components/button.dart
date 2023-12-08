import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nauman/UI%20Components/color.dart';

class Button extends StatelessWidget {
  String title;
  Color bgcolor;
  Color textColor;
  void Function()? onTap;
  final bool loading;
  Button(
      {required this.textColor,
      required this.bgcolor,
      required this.title,
      required this.onTap,
      this.loading = false});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: Get.width,
          height: 48,
          decoration: BoxDecoration(
              color: bgcolor, borderRadius: BorderRadius.circular(15)),
          child: loading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Center(
                  child: Text(
                    title,
                    style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                )),
    );
  }
}
