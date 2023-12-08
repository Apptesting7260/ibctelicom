import 'package:get/get.dart';

import 'package:nauman/data/response/status.dart';

import 'package:nauman/models/other_user_profile_modal.dart/other_user_profile_view_modalClass.dart';

import 'package:nauman/repository/post_api_repository/other_person_profile_view_repo/ohter_person_profile_view_repo.dart';

import 'package:nauman/view/Other%20Profile/otherProfile.dart';
import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';

class OtherProfileView_ViewModel extends GetxController {
  final _api = OtherProfileViewRepository();
  final rxRequestStatus = Status.LOADING.obs;
  RxBool loading = false.obs;
  final UserDataList = OtherProfileView_ModalClass().obs;
  RxString error = ''.obs;
  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;
  void setUserDataList(OtherProfileView_ModalClass _value) =>
      UserDataList.value = _value;
  void setError(String _value) => error.value = _value;
  var user_id = ''.obs;
  UserPreference userPreference = UserPreference();

  void OtherProfileViewApi() async {
    String? token = await userPreference.getToken();
    setRxRequestStatus(Status.LOADING);
    Map<String, String>? head = {
      "Authorization": "Bearer $token",
    };
    Map<String, String>? body = {'other_user_id': user_id.value};

    _api.OtherProfileViewPostApi(head, body).then((value) {
      print("succcccccccccccccc");
      setRxRequestStatus(Status.COMPLETED);
      setUserDataList(value);
     
      Get.to(() => OtherProfile(fromLink: true,));
    }).onError((error, stackTrace) {
      print("errrrrrrrrrrrrrrrrrrrrrrrrrrr");
      loading = false.obs;
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }

  void refreshApi() async {
    setRxRequestStatus(Status.LOADING);
    String? token = await userPreference.getToken();
    Map<String, String>? head = {
      "Authorization": "Bearer $token",
    };
    Map<String, String>? body = {'other_user_id': user_id.value};
    setRxRequestStatus(Status.LOADING);

    _api.OtherProfileViewPostApi(head, body).then((value) {
      setRxRequestStatus(Status.COMPLETED);
      setUserDataList(value);

      Get.to(OtherProfile(fromLink: true,));
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }
}
