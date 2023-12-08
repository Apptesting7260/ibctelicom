import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/routes/routes_name.dart';
import 'package:nauman/models/login/user_model.dart';
import 'package:nauman/repository/post_api_repository/forgot_password_repository/otpSend_repository.dart';
import 'package:nauman/repository/post_api_repository/forgot_password_repository/otpSubmit_repository.dart';
import 'package:nauman/repository/post_api_repository/login_repository/login_repository.dart';
import 'package:nauman/repository/post_api_repository/signUpOtp/signupOtp_repo.dart';
import 'package:nauman/utils/utils.dart';
import 'package:nauman/view/Authentication%20Screens/aboutYouScreen.dart';
import 'package:nauman/view/Forgot%20Password/resetPassword.dart';
import 'package:nauman/view_models/controller/Signup/signup_view_model.dart';
import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';

class SignupOTPViewModel extends GetxController {
  final _api = SignupOTPRepository();

  UserPreference userPreference = UserPreference();

  final emailController = TextEditingController().obs;
  final otpController = TextEditingController().obs;
  final emailFocusNode = FocusNode().obs;

  RxBool loading = false.obs;

  void SignupOTPApi() {
    loading.value = true;
    print('Heeeylo Email -> ${emailController.value.text}');
    print('Heeeylo OTp -> ${otpController.value.toString()}');
    Map data = {
      'email': emailController.value.text,
      'otp': otpController.value.text
    };
    _api.SignupOTPApi(data).then((value) async {
      loading.value = false;

      if (value['status'] == 'failed') {
        Utils.toastMessageCenter(value['message'], true);
      } else {
        await userPreference.setToken(value['token']);
        await userPreference.setStep(value['current_step']);
        userPreference.getToken().then((token) {
          print("With Shared Preference: ${token}");
        });
        userPreference.getStep().then((step) {
          print("With Shared Preference Step : ${step}");
        });
        Get.to(() => AboutYouClass());

        Utils.toastMessageCenter('OTP Verifed Successfully.', false);
      }
      // else {

      //   // UserModel userModel = UserModel(
      //   //     token: value['token'] ,
      //   //   isLogin: true
      //   // );

      //   userPreference.saveUser(userModel).then((value){

      //   //   releasing resouces because we are not going to use this
      //     Get.delete<LoginViewModel>();
      //     Get.toNamed(RouteName.homeView)!.then((value){});
      //     Utils.snackBar('Login', 'Login successfully');

      //   }).onError((error, stackTrace){

      //   });

      // }
    }).onError((error, stackTrace) {
      loading.value = false;

      Utils.toastMessageCenter(error.toString(), true);
    });
  }
}
