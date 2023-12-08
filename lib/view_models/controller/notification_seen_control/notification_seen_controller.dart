import 'package:get/get.dart';
import 'package:nauman/repository/post_api_repository/like_repo/like_repo.dart';
import 'package:nauman/repository/post_api_repository/notification_seen_repo/notification_seen_repo.dart';

import 'package:nauman/utils/utils.dart';

import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';

class NotificationSeenViewModel extends GetxController {
  final _api = NotificationSeenRepository();

  UserPreference userPreference = UserPreference();

  RxString? othere_user_id = ''.obs;
  RxString? about = ''.obs;
  RxBool loading = false.obs;
  void notificationSeenApi() async {
    String? token = await userPreference.getToken();
    loading.value = true;

    Map<String, String>? body = {
      'othere_user_id': othere_user_id!.value,
      "about": about!.value
    };
    Map<String, String>? head = {
      "Authorization": "Bearer $token",
    };
    _api.NotificationSeenApi(head, body).then((value) async {
      loading.value = false;

      if (value['status'] == 'failed') {
        Utils.toastMessageCenter(value['message'], true);
      } else {
        Get.delete<NotificationSeenViewModel>();

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
