import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/global_variables.dart';

import 'package:nauman/view/Authentication%20Screens/splashScreen.dart';

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print(notificationBell.value);
//   notificationBell.value = true;
//   print(notificationBell.value);
//   print("Handling a background message");
//   print('hello');
//   print('new');
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  
  await FlutterBranchSdk.init(
      useTestKey: false, enableLogging: false, disableTracking: false);
  FlutterBranchSdk.validateSDKIntegration();

  
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  
 

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  settings.sound;
   fcmToken = await messaging.getToken();
  
  runApp(MainClass());
  
}

class MainClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Value =============> ${notificationBell.value}");
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      theme: ThemeData()
          .copyWith(primaryColor: primaryDark, splashColor: primaryDark),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
