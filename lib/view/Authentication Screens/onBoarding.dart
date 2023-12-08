import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:nauman/UI%20Components/button.dart';
// import 'package:nauman/Authentication Screens//signUp.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/repository/post_api_repository/login_repository/login_timer_repo.dart';
import 'package:nauman/view/Authentication%20Screens/signUp.dart';
import 'package:nauman/view_models/controller/login/login_timer_controller.dart';
import 'package:nauman/view_models/controller/third_party_auth/third_party_auth.dart';
import 'package:signin_with_linkedin/signin_with_linkedin.dart';

import 'loginScree.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
 

 var thirdPartyController = Get.put(ThirdPartyViewModel());
  final height = Get.height;
  final width = Get.width;
  final linkedInConfig = LinkedInConfig(
    clientId: '78end1570g9a8w',
    clientSecret: 'O5wIuR9ZMc1wDVVX',
    redirectUrl: 'https://www.linkedin.com/home',
    scope: ['openid', 'profile', 'email'],
  );
  LinkedInUser? _linkedInUser;
  Map userFb = {};

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Image.asset('assets/images/onboardTop.png')),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Container(
                    child: Text(
                      'Discover Your Perfect Match',
                      style: TextStyle(color: Colors.white, fontSize: 50),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Container(
                    child: Text(
                      'Where Hearts Align',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Container(
                    child: Text(
                      'Our match making app bring hearts together',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Container(
                    child: Text(
                      'Your perfect match awaits with SoulMate.AI',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print('Fb Tapped');
                          signInWithFacebook();
                        },
                        child: Image.asset(
                          'assets/images/facebook.png',
                          width: width * .1,
                          height: height * .06,
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          googleSignIn();
                        },
                        child: Image.asset(
                          'assets/images/google.png',
                          width: width * .1,
                          height: height * .06,
                        ),
                      ),

                      // SizedBox(
                      //   width: width * .035,
                      // ),
                      GestureDetector(
                        onTap: () {
                          linkedinSignIn();
                        },
                        child: Image.asset(
                          'assets/images/linkedin.png',
                          width: width * .1,
                          height: height * .06,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Image.asset('assets/images/or.png'),
                  SizedBox(
                    height: 30,
                  ),
                  Button(
                    textColor: Colors.black,
                    bgcolor: Colors.white,
                    title: 'Sign Up',
                    onTap: () async {
                      Get.to(() => SignUpClass());
                      // // await FirebaseAuth.instance.signOut();
                      // bool bb = await SignInWithLinkedIn.logout();
                      // print(bb);
                    },
                  ),
                  SizedBox(height: height * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: "Existing account?",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: existingAcColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(() => LoginScreen());
                              }),
                        TextSpan(
                            text: " Log in",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: existingAcColor,
                                    decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(() => LoginScreen());
                              })
                      ])),
                      SizedBox(height: height * 0.05),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInWithFacebook() async {
    try {
       final LoginResult loginResult = await FacebookAuth.instance.login();
   print("Login REsullt AcessToken -> ${loginResult.accessToken?.token}");
   print("other things -> ${loginResult.accessToken?.userId}");
    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
 UserCredential userCredential =  await  FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
     print(loginResult.accessToken?.applicationId);
     print(loginResult.status);
     print(loginResult.message);
     print("FRom FireBase ------------------------------------------------------------->");
     print(userCredential.user!.email);
     print(userCredential.user!.displayName);
     print(userCredential.user!.uid);
     
      thirdPartyController.socailite_id.value = userCredential.user!.uid.toString();
    thirdPartyController.socailite_type.value = 'facebook';
    thirdPartyController.email.value = userCredential.user!.email!.toString();
    thirdPartyController.user_name.value = userCredential.user!.displayName!.toString();
    thirdPartyController.thirdPartyApi();
    setFacebook(true);

    } catch (e) {
      print('Hello Error');
      print(e.toString());
      
    }
    // Trigger the sign-in flow
   
  }
  // Future<void> signInWithFacebook() async {
  //   try {
  //     // var loginResult = await FacebookAuth.instance.login();
  //     // print(loginResult.accessToken);
  //     // print(loginResult.message);
  //     // print(loginResult.status);
  //     // Trigger the sign-in flow
  //     // final LoginResult loginResult = await FacebookAuth.instance.login(
      
  //     // );
  //     final LoginResult loginResult =
  //     await FacebookAuth.instance.login(
  //        permissions: ["public_profile","email"],
  //            loginBehavior: LoginBehavior.nativeWithFallback
  //      ).then((value) {
  //        return
  //        FacebookAuth.instance.getUserData().then((value){
          
  //          if(value != null){
  //     setState(() {
  //            userFb = value;
  //          });
  //          }
    
  //        }
      
  //        );
  //      },);
  //     print(userFb);
  //     print(loginResult.accessToken);
  //     print(loginResult.message);
  //     print(loginResult.status);

  //     // Create a credential from the access token
  //     // /

  //     // Once signed in, return the UserCredential
  //     final UserCredential user = await FirebaseAuth.instance
  //         .signInWithCredential(facebookAuthCredential);
  //     print(user);
  //     await loginWithThirdParty(user, AuthMethod.FACEBOOK);
  //   } catch (ex) {
  //     print(ex);
  //     print('Hello error');
  //   }
  // }

  googleSignIn() async {
    try{
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print("Name -> ${userCredential.user?.displayName}");
    print("Email -> ${userCredential.user?.email}");
  
    print("Uid -> ${userCredential.user?.uid}");
    
    thirdPartyController.socailite_id.value = userCredential.user!.uid;
    thirdPartyController.socailite_type.value = 'google';
    thirdPartyController.email.value = userCredential.user!.email!;
    thirdPartyController.user_name.value = userCredential.user!.displayName!;
    thirdPartyController.thirdPartyApi();
    setGoogle(true);
    }catch(error){
      print("Error");
      print(error.toString());
    }
  }

  linkedinSignIn() {
    SignInWithLinkedIn.signIn(
      context,
      appBar: AppBar(title: Text('')),
      config: linkedInConfig,
      onGetAuthToken: (data) {
        log('Auth token data: ${data.toJson()}');
      },
      onGetUserProfile: (linkedin,user) {
        log('LinkedIn User: ${user.toJson()}');
        setState(() => _linkedInUser = user);
         thirdPartyController.socailite_id.value = _linkedInUser.hashCode.toString();
    thirdPartyController.socailite_type.value = 'linkedin'.toString();
    thirdPartyController.email.value = _linkedInUser!.email!.toString();
    thirdPartyController.user_name.value = _linkedInUser!.givenName!.toString();
    thirdPartyController.thirdPartyApi();
    setLinkedin(true);

      },
      onSignInError: (error) {
        log('Error on sign in: $error');
      },
    );
    print("Email ---> ${_linkedInUser?.email}");
  
    print("GivenName ----> ${_linkedInUser?.givenName}");
    print("Hashcode ----> ${_linkedInUser?.hashCode}");
  
  }
}
