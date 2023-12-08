import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/repository/post_api_repository/login_repository/login_repository.dart';
import 'package:nauman/repository/post_api_repository/login_repository/login_timer_repo.dart';
import 'package:nauman/utils/utils.dart';
import 'package:nauman/view/Authentication%20Screens/aboutYouScreen.dart';
import 'package:nauman/view/Authentication%20Screens/loginScree.dart';
import 'package:nauman/view/Authentication%20Screens/personalityQues.dart';
import 'package:nauman/view/Bottom%20Navigation%20Bar/bottomNavigationBar.dart';
import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';

class LoginTimerViewModel extends GetxController {
  final _api = LoginTimerRepository();

  RxString fcm_token = fcmToken!.obs;
  String? type;
  RxBool loading = false.obs;

  void loginTimerApi() {
    loading.value = true;
    print(
        'device_token Printing ---------------------------------------------');
    print(fcm_token);
    Map data = {'fcm_token': fcm_token.value, 'type': type};
    _api.loginTimerApi(data).then((value) async {
      loading.value = false;
     
      print(value['remaining_time']);
      String a = value['remaining_time'];
   
  String m = "";
  String s = "";
  bool min = true;
  for(int i = 0 ; i < a.length; i++){
    if(a[i] == ':'){
      min = false;
      continue;
    }
    if(min == true){
      m += a[i];
    }
    if(min == false){
      s += a[i];
    }
  }
   second.value = int.parse(s);
   minute.value = int.parse(m);
   print("Sec -> ${second.value}");
   print("Min -> ${minute.value}");
    }).onError((error, stackTrace) {
      loading.value = false;
       second.value = 0;
       minute.value = 0;
      Utils.toastMessageCenter(error.toString(), true);
    });
  }
}
