import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/button.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/UI%20Components/textField.dart';
import 'package:nauman/view/Forgot%20Password/resetPassword.dart';
import 'package:nauman/view_models/controller/forgotPassword/otpSend_view_model.dart';
import 'package:nauman/view_models/controller/forgotPassword/otpSubmit_view_model.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  // TextEditingController otpController = TextEditingController();
  final otpSubmitVM = Get.put(OtpSubmitViewModel());
  final VMinstanceOTPSubmit = Get.put(OtpSendViewModel());
  bool isResendEnabled = false;
  int countdown = 60; // 1 minutes in seconds
  late Timer resendTimer;
  final formKey = GlobalKey<FormState>();
  String? _validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter OTP.';
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    startResendTimer();
  }

  void startResendTimer() {
    resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        countdown--;
        if (countdown <= 0) {
          isResendEnabled = true;
          resendTimer.cancel();
        }
      });
    });
  }

  void resendOtp() {
    // Implement the logic to resend the OTP
    setState(() {
      VMinstanceOTPSubmit.OtpSendApi();
      countdown = 60;
      isResendEnabled = false;
      startResendTimer();
      // if (formKey.currentState!.validate()) {
      //   otpSubmitVM.emailController.value =
      //       VMinstanceOTPSubmit.emailController.value;

      //   otpSubmitVM.OtpSubmitApi();
      // }
      // if (formKey.currentState!.validate()) {

      // }
    });
  }

  // void submitOtp() {
  //   // Implement the logic to verify the OTP
  //   // You can use the value from 'otpController.text'
  // }

  @override
  void dispose() {
    resendTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = Get.height;
    final width = Get.width;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: Get.width,
                    height: Get.height * .23,
                    color: primaryDark,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Get.height * .03,
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: Get.height * .03,
                          ),
                          TextClass(
                            fontColor: Colors.white,
                            fontWeight: FontWeight.w700,
                            size: 18,
                            title: 'OTP Verification',
                          ),
                          SizedBox(
                            height: Get.height * .01,
                          ),
                          TextClass(
                            fontColor: Colors.white,
                            fontWeight: FontWeight.w300,
                            size: 14,
                            title: 'Enter OTP sent to your mentioned email Id.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * .15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Pinput(
                      validator: _validateOTP,
                      
                      controller: otpSubmitVM.otpController.value,
                      length: 6,
                      closeKeyboardWhenCompleted: true,
                      // focusedPinTheme: PinTheme(),
                      defaultPinTheme: PinTheme(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                          ),
                          height: 50,
                          width: 55,
                          textStyle: TextStyle(fontSize: 23)),
                  
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  ),

                  // TextFieldClass(
                  //   // controller: otpSubmitVM.otpController,
                  //   keyboardType: TextInputType.number,
                  //   hint: 'Enter OTP',
                  //   isObs: false,
                  //   validator: _validateOTP,
                  // ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Resend OTP in: $countdown seconds'),
                      SizedBox(width: 10.0),
                      isResendEnabled
                          ? ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(primaryDark)),
                              onPressed: resendOtp,
                              child: Text('Resend OTP'),
                            )
                          : Container(),
                    ],
                  ),
                  SizedBox(height: height * .06),
                  isResendEnabled
                      ? Container()
                      : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Button(
                        
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                otpSubmitVM.emailController.value =
                                    VMinstanceOTPSubmit.emailController.value;
                                    print(VMinstanceOTPSubmit.emailController.value);
                                 print(otpSubmitVM.emailController.value);
                                 print(otpSubmitVM.otpController.value.text);
                                otpSubmitVM.OtpSubmitApi();
                              }
                            },
                            loading: otpSubmitVM.loading.value,
                            bgcolor: primaryDark,
                            textColor: Colors.white,
                            title: 'Submit',
                          ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
