import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/button.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/passwordTextField.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/UI%20Components/textField.dart';
import 'package:nauman/view_models/controller/forgotPassword/otpSend_view_model.dart';
import 'package:nauman/view_models/controller/forgotPassword/passwordChange_view_model.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';

class NewPasswordScreen extends StatefulWidget {
  @override
  State<NewPasswordScreen> createState() => NewPasswordScreenState();
}

class NewPasswordScreenState extends State<NewPasswordScreen> {
  // TextEditingController newPasswordController = TextEditingController();
  final newPassVM = Get.put(PasswordChangeViewModel());
  final formKey = GlobalKey<FormState>();
  final VMinstanceOTPSubmit = Get.put(OtpSendViewModel());
  var userProfileView_vm = Get.put(UserProfileView_ViewModel());
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter confirm password.';
    }
    if (value != newPassVM.passwordController.value.text) {
      return "Password doesn't match";
    }
    return null;
  }

  bool isButtonEnabled = false;
  void checkButtonStatus() {
    setState(() {
      isButtonEnabled = newPassVM.passwordController.value.text.isNotEmpty &&
          newPassVM.confirmPasswordController.value.text ==
              newPassVM.passwordController.value.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = Get.height;
    final width = Get.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: primaryDark,
        backgroundColor: Colors.white,
      ),
      body: Form(
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
                  title: 'Confirm Password',
                  fontColor: Colors.black,
                  align: TextAlign.center,
                ),
                SizedBox(height: height * .06),
                PasswordTextFormField(
                  onChanged: (p0) {
                    setState(() {
                      checkButtonStatus();
                    });
                  },
                  controller: newPassVM.passwordController.value,
                  keyboardType: TextInputType.emailAddress,
                  labelText: 'New Password',
                  validator: _validatePassword,
                ),
                SizedBox(height: height * .05),
                PasswordTextFormField(
                  onChanged: (p0) {
                    setState(() {
                      checkButtonStatus();
                    });
                  },
                  controller: newPassVM.confirmPasswordController.value,
                  keyboardType: TextInputType.emailAddress,
                  labelText: 'Confirm Password',
                  validator: _validateConfirmPassword,
                ),
                SizedBox(height: height * .06),
                Obx(
                  () => Button(
                    bgcolor: isButtonEnabled ? primaryDark : F3F6F6,
                    loading: newPassVM.loading.value,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        if (VMinstanceOTPSubmit
                            .emailController.value.text.isNotEmpty) {
                          newPassVM.emailController.value =
                              VMinstanceOTPSubmit.emailController.value;
                        } else {
                          newPassVM.emailController.value.text =
                              userProfileView_vm
                                  .UserDataList.value.userData!.email!;
                        }

                        newPassVM.PasswordChangeApi();
                        // print(newPassVM.emailController.value.text);
                        // print(newPassVM.passwordController.value.text);
                        // print(newPassVM.confirmPasswordController.value.text);
                      }
                    },
                    textColor: isButtonEnabled ? Colors.white : primaryGrey,
                    title: 'Save Password',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}






// {"personality_questions": [{"id": "1", "answer": "Outgoing"}, {"id": "2", "answer": "Resilient and adaptable"}, {"id": "3", "answer": "Spontaneous adventures"}, {"id": "4", "answer": "Not much"}, {"id": "5", "answer": "Willingness to compromise and find common ground"}, {"id": "6", "answer": "Spontaneous decision-maker"}]}