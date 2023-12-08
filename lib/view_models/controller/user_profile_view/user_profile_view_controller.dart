

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:nauman/data/response/status.dart';
import 'package:nauman/global_variables.dart';


import 'package:nauman/models/user_profile_view_model.dart/user_profile_view.dart';

import 'package:nauman/repository/get_api_repository/user_profile_view_repository/user_profile_view_repo.dart';
import 'package:nauman/view_models/controller/chatGPT/chatGPT_train_cont.dart';


class UserProfileView_ViewModel extends GetxController {
  final _api = UserProfileViewRepository();
  final rxRequestStatus = Status.LOADING.obs;

  final UserDataList = UserProfileViewModalClass().obs;
  RxString error = ''.obs;
  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;
  void setUserDataList(UserProfileViewModalClass _value) =>
      UserDataList.value = _value;
  void setError(String _value) => error.value = _value;
   settingDeviceToken(String name)async{
   print("*************************************************************** Setting Setting Setting Setting Setting Setting Setting Setting Setting Setting Setting ********************************************");
   var dTokenSnapshot = await FirebaseFirestore.instance.collection(name).doc('Device Token');
   var dToken = await dTokenSnapshot.get();
    if(dToken.exists){
      print("here alos");
      dTokenSnapshot.update({"device token": fcmToken});
    }
  }
  void UserProfileViewApi()async {


    _api.UserProfileViewGetApi().then((value)async {
   
      print('success');
      setRxRequestStatus(Status.COMPLETED);
      setUserDataList(value);
       settingDeviceToken(value.userData!.userDetails!.userId.toString());
      

     

    }).onError((error, stackTrace) {
      print('This is error');
      print(error.toString());
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }

  void refreshApi() {
    setRxRequestStatus(Status.LOADING);
     
    _api.UserProfileViewGetApi().then((value) {
      setRxRequestStatus(Status.COMPLETED);
      setUserDataList(value);
 
    }).onError((error, stackTrace) {
      print('This is error');
      print(error.toString());
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }
  void refreshGPTApi() {
    setRxRequestStatus(Status.LOADING);
     
    _api.UserProfileViewGetApi().then((value) {
      setRxRequestStatus(Status.COMPLETED);
      setUserDataList(value);
 var       chatGPTVM = Get.put(ChatGPT_trainViewModal());
       var data = value.userData;
       Chat_GPT_Modal_Train_Sentence = "My name is ${data?.userName.toString()}, I am ${data?.userDetails?.age.toString()} years old, My interests are ${data?.userDetails?.hobbies.toString()}, By profession I am ${data?.userDetails?.profession.toString()}, I have degree in ${data?.userDetails?.education.toString()}, I live at ${data?.userDetails?.location}.";
       chatGPTVM.prompt.value = Chat_GPT_Modal_Train_Sentence;
       chatGPTVM.profile_id = data!.userDetails!.userId!.toInt().obs;
       chatGPTVM.user_id = data.userDetails!.userId!.toInt().obs;
       chatGPTVM.ChatGPT_trainApi();
    }).onError((error, stackTrace) {
      print('This is error');
      print(error.toString());
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }

}
