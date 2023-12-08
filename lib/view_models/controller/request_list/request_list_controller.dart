import 'package:get/get.dart';

import 'package:nauman/data/response/status.dart';
import 'package:nauman/global_variables.dart';

import 'package:nauman/models/request_list/request_list.dart';

import 'package:nauman/repository/get_api_repository/request_list_repo/request_list_repo.dart';
import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';

class RequestListViewModel extends GetxController {
  final _api = RequestListRepository();
  final rxRequestStatus = Status.LOADING.obs;

  final UserDataList = RequestListModalClass().obs;
  RxString error = ''.obs;
  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;
  void setUserDataList(RequestListModalClass _value) =>
      UserDataList.value = _value;
  void setError(String _value) => error.value = _value;
  UserPreference userPreference = UserPreference();
  RxString page_no = '1'.obs;
  RxString per_page = '8'.obs;
  void RequestListApi(bool pagination) async {
    if(pagination == false){
      OutgoingDataList.clear();
      IncomingDataList.clear();
      setRxRequestStatus(Status.LOADING);
    }
    String? token = await userPreference.getToken();
    Map<String, String>? head = {
      "Authorization": "Bearer $token",
    };
    Map<String, String> body = {
      "page_no": page_no.value,
      "per_page": per_page.value
    };
    _api.RequestListGetApi(head, body).then((value) {
      setRxRequestStatus(Status.COMPLETED);
      setUserDataList(value);
    }).onError((error, stackTrace) {
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
    Map<String, String> body = {
      "page_no": page_no.value,
      "per_page": per_page.value
    };
    _api.RequestListGetApi(head, body).then((value) {
      setRxRequestStatus(Status.COMPLETED);
      setUserDataList(value);
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }
}
