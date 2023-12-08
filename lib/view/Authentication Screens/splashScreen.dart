import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nauman/UI%20Components/uploadPhoto.dart';
import 'package:nauman/UI%20Components/videoUpload.dart';
import 'package:nauman/demo.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/utils/utils.dart';
import 'package:nauman/view/Authentication%20Screens/aboutYouScreen.dart';
import 'package:nauman/view/Authentication%20Screens/loginScree.dart';
import 'package:nauman/view/Authentication%20Screens/pageView.dart';
import 'package:nauman/view/Authentication%20Screens/personalityQues.dart';
import 'package:nauman/view/Authentication%20Screens/signUp.dart';
import 'package:nauman/view/Bottom%20Navigation%20Bar/bottomNavigationBar.dart';
import 'package:nauman/view/HomeScreens/homePage.dart';
import 'package:nauman/view_models/controller/homeScreen/homeScreen_view_model.dart';
import 'package:nauman/view_models/controller/login/login_timer_controller.dart';
import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';
// import 'package:nauman/Authentication%20Screens/pageView.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
   var passTimer = Get.put(LoginTimerViewModel());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     passTimer.type = 'view';
    passTimer.loginTimerApi();
    Timer(Duration(seconds: 3), () async {
      String? token = await UserPreference().getToken();
      String? step = await UserPreference().getStep();
      print(token);
      print(step);
 
      googleActive = await getGoogle();
      facebookActive = await getFacebook();
      linkedinActive = await getLinkedin();
      hitGPT = await getHitGPT();
      if (hitGPT == null) {
        print("hit gpt null");
        hitGPT = true;
      }
    
      if (token != null && step == '3') {
        print("home yes");

        Get.off(() => BottomNavigation(
              fromClear: false,
              passedIndex: 0,
            ));
      } else if (token != null && step == '1') {
        print('about yes');
        Get.off(() => AboutYouClass());
      } else if (token != null && step == '2') {
        print('personality yes');
        Get.off(() => PersonalityQuesClass());
      } else {
        Get.off(() => PgView());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/imgpsh_four.png',
        ),
      ),
    );
  }
}
