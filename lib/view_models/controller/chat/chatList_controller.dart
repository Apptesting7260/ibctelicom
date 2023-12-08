
import 'package:get/get.dart';
// import 'package:getx_mvvm/models/login/user_model.dart';
// import 'package:getx_mvvm/repository/login_repository/login_repository.dart';
// import 'package:getx_mvvm/res/routes/routes_name.dart';
// import 'package:getx_mvvm/utils/utils.dart';
// import 'package:getx_mvvm/view_models/controller/user_preference/user_prefrence_view_model.dart';

import 'package:nauman/data/response/status.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/models/chatList/chatList_modalClass.dart';
import 'package:nauman/models/my_connections/my_connections_modalClass.dart';
import 'package:nauman/repository/post_api_repository/chat/chat_list_repo.dart';
import 'package:nauman/repository/post_api_repository/my_connections/my_connections_repo.dart';
import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';

class ChatListViewModel extends GetxController {
  final _api = ChatListRepository();
  final rxRequestStatus = Status.LOADING.obs;

  final UserDataList = ChatListModalClass().obs;
  RxString error = ''.obs;
  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;
  void setUserDataList(ChatListModalClass _value) =>
      UserDataList.value = _value;
  void setError(String _value) => error.value = _value;
  RxString per_page = '9'.obs;
  RxString page_no = '1'.obs;
    UserPreference userPreference = UserPreference();
  void MyConnectionsApi(bool pagination) async{
     if(pagination == false){
      ChatDataList.clear();
     }
     String? token = await userPreference.getToken();
     if(pagination == false){

    setRxRequestStatus(Status.LOADING);
     }
    Map<String, String>? head = {
      "Authorization": "Bearer $token",
    };
    Map<String, String> body = {
      "page_no": page_no.value,
      "per_page": per_page.value
    };
    _api.chatListApi(head,body).then((value) {
      setRxRequestStatus(Status.COMPLETED);
      setUserDataList(value);
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }

  void refreshApi() async{
       String? token = await userPreference.getToken();
    setRxRequestStatus(Status.LOADING);
Map<String, String>? head = {
      "Authorization": "Bearer $token",
    };
    Map<String, String> body = {
      "page_no": page_no.value,
      "per_page": per_page.value
    };
    _api.chatListApi(head,body).then((value) {
      setRxRequestStatus(Status.COMPLETED);
      setUserDataList(value);
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }
}
