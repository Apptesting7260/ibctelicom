import 'package:get/get.dart';
import 'package:nauman/repository/post_api_repository/chat/chat_request_repo.dart';

import 'package:nauman/repository/post_api_repository/request_send_repo/request_send_repo.dart';
import 'package:nauman/utils/utils.dart';

import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';

class ChatRequestViewModel extends GetxController {
  final _api = ChatRequestRepository();

  UserPreference userPreference = UserPreference();

  RxString? room_id = ''.obs;
  RxBool loading = false.obs;
  void ChatRequestSendApi() async {
    String? token = await userPreference.getToken();
    loading.value = true;
   
    

    Map<String, String>? body = {'room_id': room_id!.value};
    Map<String, String>? head = {
      "Authorization": "Bearer $token",
    };
    _api.chatRequestSendApi(head, body).then((value) async {
      loading.value = false;

      if (value['status'] == 'failed') {
        Utils.toastMessageCenter(value['message'], true);
      } else {
        Get.delete<RequestSendRepository>();

        Utils.toastMessageCenter(value['message'], false);
        print("success");
      }
    }).onError((error, stackTrace) {
      loading.value = false;
      print(error.toString());

      Utils.toastMessageCenter(error.toString(), true);
    });
  }
}
