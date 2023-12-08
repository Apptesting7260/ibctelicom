import 'package:get/get.dart';
import 'package:nauman/repository/post_api_repository/like_repo/like_repo.dart';

import 'package:nauman/utils/utils.dart';

import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';

class LikeViewModel extends GetxController {
  final _api = LikeRepository();

  UserPreference userPreference = UserPreference();

  RxString? like_to = ''.obs;
  RxString? fav_sataus = ''.obs;
  RxBool loading = false.obs;
  void likeApi() async {
    String? token = await userPreference.getToken();
    loading.value = true;

    Map<String, String>? body = {
      'like_to': like_to!.value,
      "fav_sataus": fav_sataus!.value
    };
    Map<String, String>? head = {
      "Authorization": "Bearer $token",
    };
    _api.likeApi(head, body).then((value) async {
      loading.value = false;

      if (value['status'] == 'failed') {
        Utils.toastMessageCenter(value['message'], true);
      } else {
        Get.delete<LikeViewModel>();

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
