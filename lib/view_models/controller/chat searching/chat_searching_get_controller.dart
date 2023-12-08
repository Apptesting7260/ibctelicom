import 'package:get/get.dart';
import 'package:nauman/repository/post_api_repository/Chat%20Searching/chat_person_add_repo.dart';
import 'package:nauman/repository/post_api_repository/Chat%20Searching/chat_person_get_repo.dart';
import 'package:nauman/repository/post_api_repository/like_repo/like_repo.dart';

import 'package:nauman/utils/utils.dart';

import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';

class ChatPersonAddViewModel extends GetxController {
  final _api = ChatPersonAddRepository();

  UserPreference userPreference = UserPreference();

  RxString? other_user_id = ''.obs;
  RxString? other_user_name = ''.obs;
  RxString? room_id = ''.obs;
  RxBool loading = false.obs;
  void ChatPersonAddApi() async {
    String? token = await userPreference.getToken();
    loading.value = true;

    Map<String, String>? body = {
      'other_user_id': other_user_id!.value,
      "other_user_name": other_user_name!.value,
      "room_id": room_id!.value,
    };
    Map<String, String>? head = {
      "Authorization": "Bearer $token",
    };
    _api.ChatPersonAddApi(head, body).then((value) async {
      loading.value = false;

      if (value['status'] == 'failed') {
       print("failed");
      } else {
        Get.delete<ChatPersonAddViewModel>();

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
