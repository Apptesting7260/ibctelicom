import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/repository/post_api_repository/login_repository/login_repository.dart';
import 'package:nauman/utils/utils.dart';
import 'package:nauman/view/Authentication%20Screens/aboutYouScreen.dart';
import 'package:nauman/view/Authentication%20Screens/loginScree.dart';
import 'package:nauman/view/Authentication%20Screens/personalityQues.dart';
import 'package:nauman/view/Bottom%20Navigation%20Bar/bottomNavigationBar.dart';
import 'package:nauman/view_models/controller/login/login_timer_controller.dart';
import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';

class LoginViewModel extends GetxController {
  final _api = LoginRepository();

  UserPreference userPreference = UserPreference();
  var passTimer = Get.put(LoginTimerViewModel());
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  RxString device_token = fcmToken!.obs;
  final emailFocusNode = FocusNode().obs;
  final passwordFocusNode = FocusNode().obs;

  RxBool loading = false.obs;

  void loginApi() {
    loading.value = true;
    print('device_token Printing ---------------------------------------------');
    print(device_token);
    Map data = {
      'email': emailController.value.text,
      'password': passwordController.value.text,
      'device_token': device_token.value
    };
    _api.loginApi(data).then((value) async {
      loading.value = false;
     
      if (value['status'] == 'failed') {
        Utils.toastMessageCenter(value['message'], true);
        if(value['message'] == 'Please Enter Correct Password'){
         if(attempts > 0){

         Utils.snackBar("Alert!!", "${attempts} attempts remaning.", true);
         attempts = attempts - 1;
    
         }
         else{
           hideLoginButton.value = true;
           print(hideLoginButton.value);
           LoginScreenState().startResendTimer();
           passTimer.type = 'update';
           passTimer.loginTimerApi();
         }


        }
      } else {
        // storing token value in shared preference
        await userPreference.setToken(value['token']);
        await userPreference.setStep(value['current_step']);
        userPreference.getStep().then((step) {
          print("With Shared Preference Step : ${step}");
        });
        print("Without Shared Preference ${value['token']}");

        // print("with shared ${userPreference.getToken().toString()}");
        userPreference.getToken().then((token) {
          print("With Shared Preference: ${token}");
        });
        Get.delete<LoginViewModel>();
        print("This is token id $Tokenid");

        Utils.toastMessageCenter('Login Successfully', false);
        // Get.toNamed(RouteName.homeView)!.then((value) {});
        if (value['current_step'] == '1') {
          Get.to(() => AboutYouClass());
        } else if (value['current_step'] == '2') {
          Get.to(() => PersonalityQuesClass());
        } else {
          Get.offAll(() => BottomNavigation(
            fromClear: false,
            passedIndex: 0));
        }


      }

    }).onError((error, stackTrace) {
      loading.value = false;

      Utils.toastMessageCenter(error.toString(), true);
    });
  }
}
