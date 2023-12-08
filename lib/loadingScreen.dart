import 'package:flutter/material.dart';
import 'package:nauman/UI%20Components/color.dart';

class LoadingScreen extends StatelessWidget{
  @override Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: primaryDark,),
      ),
    );
  }
}