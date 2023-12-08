import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:nauman/global_variables.dart';
import 'package:nauman/repository/post_api_repository/third_party_auth/third_party_auth_repo.dart';
import 'package:nauman/utils/utils.dart';
import 'package:nauman/view/Authentication%20Screens/aboutYouScreen.dart';
import 'package:nauman/view/Authentication%20Screens/personalityQues.dart';
import 'package:nauman/view/Bottom%20Navigation%20Bar/bottomNavigationBar.dart';
import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';

class ThirdPartyViewModel extends GetxController {
  final _api = Third_PartyRepository();

  UserPreference userPreference = UserPreference();

  RxString socailite_id = ''.obs;
  RxString user_name = ''.obs;
  RxString email = ''.obs;
  RxString socailite_type = ''.obs;
  RxBool loading = false.obs;
   RxString device_token = fcmToken!.obs;

  void thirdPartyApi() {
    loading.value = true;
    print(" ------------------------------- PRINTING THE VALUE TYPES--------------------------");
    print(socailite_id.runtimeType);
    print(user_name.runtimeType);
    print(email.runtimeType);
    print(socailite_type.runtimeType);
    print(" ------------------------------- PRINTING THE VALUE--------------------------");
    print(socailite_id.value);
    print(user_name.value);
    print(email.value);
    print(socailite_type.value);
    Map data = {
      'socailite_id': socailite_id.value,
      'user_name': user_name.value,
      'email': email.value,
      'socailite_type': socailite_type.value,
      'device_token': device_token.value
    };
    print("data data  data dtata stata datat data data data data data");
    print(data['device_token']);
    _api.thirdPartyApi(data).then((value) async {
      loading.value = false;

      if (value['status'] == 'failed') {
        print("------------------------------------------------------------------------- Status is FAILED");
        Utils.toastMessageCenter(value['message'], true);
      } else {
        print("--------------------------------- Success--------------------");
        print("------------Token--------------${value['token']}--------------------");
        print("------------Step--------------${value['current_step']}--------------------");
        // storing token value in shared preference
        await userPreference.setToken(value['token']);
        await userPreference.setStep(value['current_step']);
        userPreference.getStep().then((step) {
          print("With Shared Preference Step : ${step}");
        });
        print("Without Shared Preference ${value['token']}");

        userPreference.getToken().then((token) {
          print("With Shared Preference: ${token}");
        });
       

        Utils.toastMessageCenter('Authenticated Successfully', false);
        // Get.toNamed(RouteName.homeView)!.then((value) {});
        if (value['current_step'] == '1') {
          Get.to(() => AboutYouClass());
        } else if (value['current_step'] == '2') {
          Get.to(() => PersonalityQuesClass());
        } else {
          Get.offAll(() => BottomNavigation(fromClear: false, passedIndex: 0));
        }

        // Utils.snackBar('', value['token'], false);
        // print(value['token']);
        Get.delete<ThirdPartyViewModel>();
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
      print('Toast msg center');
      Utils.toastMessageCenter(error.toString(), true);
    });
  }
}
