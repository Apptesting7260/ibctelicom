import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/routes/routes_name.dart';
import 'package:nauman/models/login/user_model.dart';
import 'package:nauman/repository/post_api_repository/forgot_password_repository/otpSend_repository.dart';
import 'package:nauman/repository/post_api_repository/login_repository/login_repository.dart';
import 'package:nauman/utils/utils.dart';
import 'package:nauman/view/Authentication%20Screens/aboutYouScreen.dart';
import 'package:nauman/view/Forgot%20Password/enterOtp.dart';
import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';

class OtpSendViewModel extends GetxController {
  final _api = OtpSendRepository();

  UserPreference userPreference = UserPreference();

  final emailController = TextEditingController().obs;

  final emailFocusNode = FocusNode().obs;

  RxBool loading = false.obs;

  void OtpSendApi() {
    print(emailController.value.text);
    loading.value = true;
    Map data = {
      'email': emailController.value.text,
    };
    _api.OtpSendApi(data).then((value) {
      loading.value = false;

      if (value['status'] == 'failed') {
        Utils.toastMessageCenter(value['message'], true);
      } else {
        // Get.delete<OtpSendViewModel>();
        // Get.toNamed(RouteName.homeView)!.then((value) {});
        Get.to(() => OtpScreen());

        Utils.toastMessageCenter('OTP Send Successfully', false);
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
