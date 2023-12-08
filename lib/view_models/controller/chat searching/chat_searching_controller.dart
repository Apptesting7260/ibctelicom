import 'package:get/get.dart';

import 'package:nauman/data/response/status.dart';
import 'package:nauman/models/chat%20person%20searching/chat_searching_modal.dart';

import 'package:nauman/models/other_user_profile_modal.dart/other_user_profile_view_modalClass.dart';
import 'package:nauman/repository/post_api_repository/Chat%20Searching/chat_person_get_repo.dart';

import 'package:nauman/repository/post_api_repository/other_person_profile_view_repo/ohter_person_profile_view_repo.dart';
import 'package:nauman/utils/utils.dart';

import 'package:nauman/view/Other%20Profile/otherProfile.dart';
import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';

class ChatPersonGetViewModel extends GetxController {
  final _api = ChatPersonGetRepository();
  final rxRequestStatus = Status.LOADING.obs;
  RxBool loading = false.obs;
  final UserDataList = ChatPersonGetModalClass().obs;
  RxString error = ''.obs;
  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;
  void setUserDataList(ChatPersonGetModalClass _value) =>
      UserDataList.value = _value;
  void setError(String _value) => error.value = _value;
  var other_user_name = ''.obs;
  UserPreference userPreference = UserPreference();

  void ChatPersonGetApi() async {
    String? token = await userPreference.getToken();
    setRxRequestStatus(Status.LOADING);
    Map<String, String>? head = {
      "Authorization": "Bearer $token",
    };
    Map<String, String>? body = {'other_user_name': other_user_name.value};

    _api.ChatPersonGetApi(head, body).then((value) {
      Utils.toastMessageCenter('Success',false);
      print("succcccccccccccccc");
      setRxRequestStatus(Status.COMPLETED);
      setUserDataList(value);
     
     
    }).onError((error, stackTrace) {
      print("errrrrrrrrrrrrrrrrrrrrrrrrrrr");
      loading = false.obs;
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }

 
}
