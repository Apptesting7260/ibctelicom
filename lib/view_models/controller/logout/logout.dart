import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:nauman/global_variables.dart';

import 'package:nauman/repository/post_api_repository/logout/logout.dart';
import 'package:nauman/utils/utils.dart';
import 'package:nauman/view/Authentication%20Screens/splashScreen.dart';

import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';
import 'package:signin_with_linkedin/signin_with_linkedin.dart';

class LogoutViewModel extends GetxController {
  final _api = LogoutRepository();

  UserPreference userPreference = UserPreference();
  var userProfileView_vm = Get.put(UserProfileView_ViewModel());
  RxBool loading = false.obs;
  deletingDeviceToken()async{
   print("****************************************************************************************************");
   var dTokenSnapshot = await FirebaseFirestore.instance.collection(userProfileView_vm.UserDataList.value.userData!.userDetails!.userId!.toString()).doc('Device Token').get();
    if(dTokenSnapshot.exists){
      var tt = await FirebaseFirestore.instance.collection(userProfileView_vm.UserDataList.value.userData!.userDetails!.userId.toString()).doc('Device Token');
      tt.update({"device token": ""});
    }
  }
  void logoutApi() async {
    loading.value = true;
    String? token = await userPreference.getToken();
    print(token);
    print("token token ererkjeork ekrj ");
    Map<String, String>? head = {
      "Authorization": "Bearer $token",
    };

    _api.logoutApi(head).then((value) async {
      loading.value = false;

      if (value['status'] == 'failed') {
        print('error');
        Utils.toastMessageCenter(value['message'], true);
      }
      else {
        deletingDeviceToken();
        Get.delete<LogoutViewModel>();
        
        Utils.toastMessageCenter('Logout Successfully', false);
        print("Google ${googleActive}");
                      print("Linkedin ${linkedinActive}");
                      print("Facebook ${facebookActive}");
                      UserPreference().logOutUserTokenDelete();
                      UserPreference().deleteStep();
                      if (googleActive == true) {
                        print(FirebaseAuth.instance.currentUser);

                        await FirebaseAuth.instance.signOut();
                        print('google sign out');
                        print(FirebaseAuth.instance.currentUser);
                        setGoogle(false);
                      }

                      if (linkedinActive == true) {
                        bool val = await SignInWithLinkedIn.logout();

                        print('Linkedin sign out');
                        print(val);
                        setLinkedin(false);
                      }       
                      if(facebookActive == true){
                            await FacebookAuth.instance.logOut();
                            print(FacebookAuth.instance.logOut());
                              await FirebaseAuth.instance.signOut();
                            print('Fb sign out');
                            setFacebook(false);
                      }

                      print("Google 2${googleActive}");
                      print("Linkedin2 ${linkedinActive}");
                      print("Facebook 2${facebookActive}");
                      setHitGPT(true);
                      Get.offAll(SplashScreen());
      }
    }).onError((error, stackTrace) {
      print("error rrrrr");
      print(error.toString());
      loading.value = false;

      Utils.toastMessageCenter(error.toString(), true);
    });
  }
}
