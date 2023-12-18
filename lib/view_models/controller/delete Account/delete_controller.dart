
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:nauman/UI%20Components/app_url/app_url.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/utils/utils.dart';
import 'package:nauman/view/Authentication%20Screens/splashScreen.dart';



import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';
import 'package:signin_with_linkedin/signin_with_linkedin.dart';


class AccountDeleteController extends GetxController {
  // final _api = PhotoDeleteRepository();

  UserPreference userPreference = UserPreference();
    var userProfileView_vm = Get.put(UserProfileView_ViewModel());
 deletingDeviceToken()async{
   print("****************************************************************************************************");
   var dTokenSnapshot = await FirebaseFirestore.instance.collection(userProfileView_vm.UserDataList.value.userData!.userDetails!.userId!.toString()).doc('Device Token').get();
    if(dTokenSnapshot.exists){
      var tt = await FirebaseFirestore.instance.collection(userProfileView_vm.UserDataList.value.userData!.userDetails!.userId.toString()).doc('Device Token');
      tt.update({"device token": ""});
    }
  }
 
  RxBool loading = false.obs;
  void accountdeleteFunc() async {
    String? token = await userPreference.getToken();
    loading.value = true;
   
    
   
   
    Map<String, String>? head = {
      "Authorization": "Bearer $token",
    };
    var response = await http.delete(Uri.parse(AppUrl.userAccountDelete),
    headers: head
    );
    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      if(data['status'] == 'success'){
        print("yes");
         deletingDeviceToken();
        Get.delete<AccountDeleteController>();
        
        Utils.toastMessageCenter('Account Delete Successfully', false);
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
      };
    }
    else{
      Utils.toastMessageCenter("Try Again!", true);
    }
  }
}
