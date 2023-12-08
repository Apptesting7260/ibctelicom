import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/routes/routes_name.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/repository/post_api_repository/signup_repository/signup_repository.dart';

import 'package:nauman/utils/utils.dart';
import 'package:nauman/view/Authentication%20Screens/aboutYouScreen.dart';
import 'package:nauman/view/Authentication%20Screens/signUpOTP.dart';
import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';

class SignupViewModel extends GetxController {
  final _api = SignupRepository();
  UserPreference userPreference = UserPreference();

  final userNameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final confirmPasswordController = TextEditingController().obs;
  RxString device_token = fcmToken!.obs;
  RxBool loading = false.obs;

  void signUpApi() {
    loading.value = true;
    Map data = {
      "user_name": userNameController.value.text,
      "email": emailController.value.text,
      "password": passwordController.value.text,
      "Confirm_password": confirmPasswordController.value.text,
      'device_token': device_token.value
    };
    _api.signUpApi(data).then((value) async {
      loading.value = false;

      if (value['status'] == 'failed') {
        Utils.toastMessageCenter(value['message'], true);
      } else {
        // Get.delete<SignupViewModel>();
        // Get.toNamed(RouteName.homeView)!.then((value) {});
        // await userPreference.setToken(value['token']);
        // await userPreference.setStep(value['current_step']);

        // Utils.toastMessageCenter('Success', 'OTP sent to mentioned emial', false);
        Utils.toastMessageCenter('OTP sent to mentioned email', false);
        // userPreference.getToken().then((token) {
        //   print("With Shared Preference: ${token}");
        // });
        // userPreference.getStep().then((step) {
        //   print("With Shared Preference Step : ${step}");
        // });

        Get.to(() => SignUpOtpScreen());
      }
    }).onError((error, stackTrace) {
      loading.value = false;

      Utils.toastMessageCenter(error.toString(), true);
    });
  }
}
