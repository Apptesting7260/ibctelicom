import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nauman/UI%20Components/button.dart';
import 'package:nauman/UI%20Components/passwordTextField.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/UI%20Components/textField.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/view/Authentication%20Screens/aboutYouScreen.dart';
import 'package:nauman/view_models/controller/Signup/signup_view_model.dart';

// import 'package:nauman/Authentication Screens//aboutYouScreen.dart';

class SignUpClass extends StatefulWidget {
  @override
  State<SignUpClass> createState() => SignUpClassState();
}

class SignUpClassState extends State<SignUpClass> {
  var formKey = GlobalKey<FormState>();
  // var isLoading = false;
  final signupVM = Get.put(SignupViewModel());

  // void _submit() async {
  //   // final isValid = formKey.currentState!.validate();
  //   // if (!isValid) {
  //   //   print('Not valid');
  //   //   return;
  //   // }

  //   // String res = await SignUpFunctionClass().signUpFunc(nameCont.text,
  //   //     emailCont.text, passwordCont.text, confirmPasswordCont.text);
  //   // print(res);

  //   // // Display the SnackBar
  //   // Get.snackbar('Error', 'An error occurred: $res');

  //   Get.to(() => AboutYouClass());
  // }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username.';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter confirm password.';
    }
    if (value != signupVM.passwordController.value.text) {
      return "Password doesn't match";
    }
    return null;
  }

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

  // TextEditingController nameCont = TextEditingController();

  // TextEditingController emailCont = TextEditingController();

  // TextEditingController passwordCont = TextEditingController();

  // TextEditingController confirmPasswordCont = TextEditingController();
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   nameCont.dispose();
  //   emailCont.dispose();
  //   passwordCont.dispose();
  //   confirmPasswordCont.dispose();
  //   super.dispose();
  //   print('Values disposed');
  // }
  bool isButtonEnabled = false;
  void checkButtonStatus() {
    setState(() {
      isButtonEnabled = signupVM.emailController.value.text.isNotEmpty &&
          signupVM.userNameController.value.text.isNotEmpty &&
          signupVM.passwordController.value.text.length > 5 &&
          signupVM.confirmPasswordController.value.text ==
              signupVM.passwordController.value.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = Get.height;
    final widht = Get.width;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Obx(
        () => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Button(
              textColor: isButtonEnabled ? Colors.white : primaryGrey,
              bgcolor: isButtonEnabled ? primaryDark : F3F6F6,
              title: 'Next'.tr,
              loading: signupVM.loading.value,
              onTap: () {
                signupVM.emailController.value.text = signupVM.emailController.value.text.toLowerCase();
                if (formKey.currentState!.validate()) {
                    print('hello');
                    print(signupVM.emailController.value.text);
                  signupVM.signUpApi();
              
                }
               
              }),
        ),
      ),
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextClass(
                  size: 18,
                  fontWeight: FontWeight.w700,
                  title: 'Sign up with Email',
                  fontColor: Colors.black),
              SizedBox(
                height: height * .04,
              ),
              TextClass(
                  size: 14,
                  fontWeight: FontWeight.w900,
                  title: 'Discover your perfect match where  hearts align',
                  fontColor: primaryGrey,
                  align: TextAlign.center),
              SizedBox(
                height: height * .07,
              ),
              TextFieldClass(
                  onChanged: (value) {
                    setState(() {
                      checkButtonStatus();
                    });
                  },
                  controller: signupVM.userNameController.value,
                  hint: 'Your name',
                  isObs: false,
                  validator: _validateUsername),
              SizedBox(
                height: height * .03,
              ),
              TextFieldClass(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    checkButtonStatus();
                  });
                },
                controller: signupVM.emailController.value,
                hint: 'Your email',
                isObs: false,
                validator: _validateEmail,
              ),
              SizedBox(
                height: height * .03,
              ),
              PasswordTextFormField(
                  controller: signupVM.passwordController.value,
                  labelText: 'Password',
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (value) {
                    setState(() {
                      checkButtonStatus();
                    });
                  },
                  validator: _validatePassword),
              SizedBox(
                height: height * .03,
              ),
              PasswordTextFormField(
                  controller: signupVM.confirmPasswordController.value,
                  labelText: 'Confirm Password',
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (value) {
                    setState(() {
                      checkButtonStatus();
                    });
                  },
                  validator: _validateConfirmPassword),
              SizedBox(
                height: height * .01,
              ),
            ],
          ),
        )),
      ),
    );
  }
}
