import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nauman/data/response/status.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/models/home/home_screen_modal_class.dart';
import 'package:nauman/repository/post_api_repository/home_screen_repo/home_screen_repo.dart';
import 'package:nauman/view/Bottom%20Navigation%20Bar/bottomNavigationBar.dart';

import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';

class HomeViewModel extends GetxController {
  final _api = HomeRepository();
  final rxRequestStatus = Status.LOADING.obs;
  RxBool loading = false.obs;
  final UserDataList = HomeModalClass().obs;
  
  RxString error = ''.obs;
  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;
  void setUserDataList(HomeModalClass _value) => UserDataList.value = _value;

  void setError(String _value) => error.value = _value;
  // Parameters of filter api
  
  var locationController = TextEditingController().obs;
  RxString distance = ''.obs;
  RxString gender = ''.obs;
  RxString age_from = ''.obs;
  RxString age_to = ''.obs;
  RxString profession = ''.obs;
  RxString height_from = ''.obs;
  RxString height_to = ''.obs;
  RxString colour = ''.obs;
  RxList<String> education = <String>[].obs;
  RxList<String> hobbies = <String>[].obs;
  RxString rating = ''.obs;
  RxString per_page = '10'.obs;
  RxString page_no = '1'.obs;
  RxList<String> personality_traits = <String>[].obs;

  UserPreference userPreference = UserPreference();


  void HomeApi(bool pagination) async {
    if(pagination == false){

    HomeDataList.clear();
    }
    print('Calling Home Function');
    print("Gender -> ${gender.value}");
    String? token = await userPreference.getToken();
    if(pagination == false){

    setRxRequestStatus(Status.LOADING);
    }
    Map<String, String>? head = {
      "Authorization": "Bearer $token",
    };
    Map<String, dynamic> body = {
      'interested_in': gender.value,
      'location': locationController.value.text,
      'distance': distance.value,
      'age_from': age_from.value,
      'age_to': age_to.value,
      'profession': profession.value,
      'height_from': height_from.value,
      'height_to': height_to.value,
      'colour': colour.value,
      'per_page': per_page.value,
      'page_no': page_no.value,
      'education': education.isEmpty ? '' : education.toString(),
      'hobbies': hobbies.isEmpty ? '' : hobbies.toString(),
      'rating': rating.value,
      'personality_traits':
          personality_traits.isEmpty ? '' : personality_traits.toString(),
    };
     
 

    _api.HomePostApi(head, body).then((value) {
      print("Correct value getting");
     if(value.status == "failed"){
        noDataHome.value = true;
              callHomePagination.value = false;
     }
     
      // if(pagination == false.obs){

      setRxRequestStatus(Status.COMPLETED);
      // }
      setUserDataList(value);
      
      
    }).onError((error, stackTrace) {
      print("Error Getting");
      print(error.toString());

      loading = false.obs;
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    }) ;

  }

  void refreshApi() async {
    print('heheeerererereerer');
    HomeDataList.clear();
    setRxRequestStatus(Status.LOADING); 
    String? token = await userPreference.getToken();
    Map<String, String>? head = {
      "Authorization": "Bearer $token",
    };
    Map<String, dynamic> body = {
      'interested_in': gender.value,
      'location': locationController.value.text,
       'distance': distance.value,
      'age_from': age_from.value,
      'age_to': age_to.value,
      'profession': profession.value,
      'height_from': height_from.value,
      'height_to': height_to.value,
      'colour': colour.value,
      'per_page': per_page.value,
      'page_no': page_no.value,
      'education': education.isEmpty ? '' : education.toString(),
      'hobbies': hobbies.isEmpty ? '' : hobbies.toString(),
      'rating': rating.value,
      'personality_traits':
          personality_traits.isEmpty ? '' : personality_traits.toString(),
    };

    setRxRequestStatus(Status.LOADING);

    _api.HomePostApi(head, body).then((value) {
      setRxRequestStatus(Status.COMPLETED);
      setUserDataList(value);
      // Get.to(() => BottomNavigation(
      //       passedIndex: 0,
      //     ));
      
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }


 



}
