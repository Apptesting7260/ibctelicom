import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/button.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/UI%20Components/textField.dart';
import 'package:nauman/view/Authentication%20Screens/aboutYouScreen.dart';
import 'package:nauman/view/Forgot%20Password/enterOtp.dart';
import 'package:nauman/view_models/controller/forgotPassword/otpSend_view_model.dart';

import '../../view_models/controller/forgotPassword/otpSubmit_view_model.dart';

class EnterEmailScreen extends StatefulWidget {
  @override
  State<EnterEmailScreen> createState() => EnterEmailScreenState();
}

class EnterEmailScreenState extends State<EnterEmailScreen> {
  TextEditingController email = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final sendOtpVM = Get.put(OtpSendViewModel());
  final otpSubmitVM = Get.put(OtpSubmitViewModel());
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

  bool isButtonEnabled = false;
  void checkButtonStatus() {
    setState(() {
      isButtonEnabled = sendOtpVM.emailController.value.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = Get.height;
    final widht = Get.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text('Forgot Password'),
      ),
      body: Obx(
        () => Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: height * .1,
                  ),
                  TextClass(
                    size: 18,
                    fontWeight: FontWeight.w700,
                    title: 'Enter your email address to reset you password',
                    fontColor: Colors.black,
                    align: TextAlign.center,
                  ),
                  SizedBox(height: height * .1),
                  TextFieldClass(
                    controller: sendOtpVM.emailController.value,
                    hint: 'Enter Email',
                    isObs: false,
                    validator: _validateEmail,
                    onChanged: (p0) {
                      setState(() {
                        checkButtonStatus();
                      });
                    },
                  ),
                  SizedBox(height: height * .1),
                  Button(
                    loading: sendOtpVM.loading.value,
                    textColor: isButtonEnabled ? Colors.white : primaryGrey,
                    bgcolor: isButtonEnabled ? primaryDark : F3F6F6,
                    title: 'Get OTP',
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        otpSubmitVM.emailController.value = sendOtpVM.emailController.value;
                        sendOtpVM.OtpSendApi();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
