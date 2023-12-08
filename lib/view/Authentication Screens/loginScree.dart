import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/button.dart';
import 'package:nauman/UI%20Components/passwordTextField.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/UI%20Components/textField.dart';

import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/view/Authentication%20Screens/onBoarding.dart';
import 'package:nauman/view/Authentication%20Screens/signUp.dart';
import 'package:nauman/view/Forgot%20Password/enterEmail.dart';
import 'package:nauman/view_models/controller/login/login_view_model.dart';
import 'package:signin_with_linkedin/signin_with_linkedin.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(second.value == 0 && minute.value == 0){
      print("Yes zero");
      second.value = 59;
      minute.value = 59;
    }
    else{
      print("Else condition");
       hideLoginButton.value = true;
           print(hideLoginButton.value);
           LoginScreenState().startResendTimer();
    }
  }
  var formKey = GlobalKey<FormState>();
  final loginVM = Get.put(LoginViewModel());
  final linkedInConfig = LinkedInConfig(
    clientId: '78end1570g9a8w',
    clientSecret: 'O5wIuR9ZMc1wDVVX',
    redirectUrl: 'https://www.linkedin.com/home',
    scope: ['openid', 'profile', 'email'],
  );
  LinkedInUser? _linkedInUser;
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address.';
    }
    // Use a regular expression to validate the email format
    // This is a simple example, you might want to use a more robust regex
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  bool isLoginButtonEnabled = false;
  void checkLoginButtonStatus() {
    setState(() {
      isLoginButtonEnabled = loginVM.emailController.value.text.isNotEmpty &&
          loginVM.passwordController.value.text.isNotEmpty &&
          loginVM.passwordController.value.text.length > 5;
    });
  }
 
  late Timer resendTimer;

  void startResendTimer() {
    resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
   
   
        second.value = second.value - 1;
         if (minute.value == 0 && second.value == 0) {
          print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
          hideLoginButton.value = false;
          resendTimer.cancel();
      
        }
        else if ( second.value == 0){
   minute.value = minute.value - 1;
        second.value = 60;
        }
       
       else{}
       
      
      
    });
  }

  @override
  Widget build(BuildContext context) {
   
    final height = Get.height;
    final width = Get.width;
    // TextEditingController emailController = TextEditingController();
    // TextEditingController passwordController = TextEditingController();
    return WillPopScope(
      onWillPop: () async{
        second.value = 0;
        minute.value = 0;
        print("yes");
       return true;
      },
      child: Scaffold(
        body: Obx(
          () => Form(
            key: formKey,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: height * .04,
                      ),
                      TextClass(
                          size: 18,
                          fontWeight: FontWeight.w700,
                          title: 'Log in',
                          fontColor: Colors.black),
                      SizedBox(
                        height: height * .025,
                      ),
                      TextClass(
                          size: 14,
                          fontWeight: FontWeight.w900,
                          title: 'Welcome back!',
                          fontColor: Color(0xff797C7B)),
                      SizedBox(
                        height: height * .04,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              OnboardingScreenState().signInWithFacebook();
                            },
                            child: Image.asset(
                              'assets/images/facebook.png',
                              width: width * .12,
                              height: height * .06,
                            ),
                          ),
                          SizedBox(
                            width: width * .05,
                          ),
                          InkWell(
                            onTap: () {
                              OnboardingScreenState().googleSignIn();
                            },
                            child: Image.asset(
                              'assets/images/google.png',
                              width: width * .12,
                              height: height * .06,
                            ),
                          ),
                          SizedBox(
                            width: width * .05,
                          ),
                          InkWell(
                            onTap: () {
                              linkedinSignIn();
                            },
                            child: Image.asset(
                              'assets/images/linkedin.png',
                              width: width * .12,
                              height: height * .06,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            color: CDD1D0.withOpacity(.5),
                            width: width * .39,
                            height: 2,
                          ),
                          SizedBox(
                            width: width * .02,
                          ),
                          TextClass(
                              size: 14,
                              fontWeight: FontWeight.w900,
                              title: 'OR',
                              fontColor: primaryGrey),
                          SizedBox(
                            width: width * .02,
                          ),
                          Container(
                            color: CDD1D0.withOpacity(.5),
                            width: width * .39,
                            height: 2,
                          )
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      TextFieldClass(
                        onChanged: (p0) => checkLoginButtonStatus,
                        hint: 'Your Email',
                        controller: loginVM.emailController.value,
                        isObs: false,
                        validator: _validateEmail,
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                    
                      PasswordTextFormField(
                          controller: loginVM.passwordController.value,
                          labelText: 'Password',
                          keyboardType: TextInputType.visiblePassword,
                          onChanged: (p0) {
                            setState(() {
                              checkLoginButtonStatus();
                            });
                          },
                          validator: _validatePassword),
                      SizedBox(
                        height: height * .04,
                      ),
                      InkWell(
                        onTap: () {
                          Get.off(() => SignUpClass());
                        },
                        child: TextClass(
                          size: 16,
                          fontWeight: FontWeight.w700,
                          title: 'Create New Account',
                          fontColor: primaryDark,
                        ),
                      ),
                      SizedBox(
                        height: height * .1,
                      ),
    
                     hideLoginButton.value?
                      
                      Text("${minute}:${second}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 18),)
                      :
                      Button(
                        loading: loginVM.loading.value,
                        textColor:
                            isLoginButtonEnabled ? Colors.white : primaryGrey,
                        bgcolor: isLoginButtonEnabled ? primaryDark : F3F6F6,
                        title: 'Log in'.tr,
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            loginVM.loginApi();
                          }
                        },
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      InkWell(
                        onTap: () => Get.to(() => EnterEmailScreen()),
                        child: TextClass(
                            size: 14,
                            fontWeight: FontWeight.w500,
                            title: 'Forgot Password?',
                            fontColor: primaryDark),
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
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

      },
      onSignInError: (error) {
        log('Error on sign in: $error');
      },
    );
    print("Email ---> ${_linkedInUser?.email}");
    print("Name ---> ${_linkedInUser?.name}");
    print("GivenName ----> ${_linkedInUser?.givenName}");
    print("Hashcode ----> ${_linkedInUser?.hashCode}");
    print("Locale ----> ${_linkedInUser?.locale}");
    print("EmailVerified ----> ${_linkedInUser?.emailVerified}");
    print("FamilyName ----> ${_linkedInUser?.familyName}");
    print("Picture ----> ${_linkedInUser?.picture}");
    print("Sub ----> ${_linkedInUser?.sub}");
  }
 

}
