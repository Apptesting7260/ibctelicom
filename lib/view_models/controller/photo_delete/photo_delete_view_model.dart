import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
// import 'package:getx_mvvm/models/login/user_model.dart';
// import 'package:getx_mvvm/repository/login_repository/login_repository.dart';
// import 'package:getx_mvvm/res/routes/routes_name.dart';
// import 'package:getx_mvvm/utils/utils.dart';
// import 'package:getx_mvvm/view_models/controller/user_preference/user_prefrence_view_model.dart';
import 'package:nauman/UI%20Components/routes/routes_name.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/models/login/user_model.dart';
import 'package:nauman/repository/post_api_repository/login_repository/login_repository.dart';
import 'package:nauman/repository/post_api_repository/photo_delete_repo/photo_delete_repo.dart';
import 'package:nauman/utils/utils.dart';
import 'package:nauman/view/Authentication%20Screens/aboutYouScreen.dart';
import 'package:nauman/view/Authentication%20Screens/personalityQues.dart';
import 'package:nauman/view/Bottom%20Navigation%20Bar/bottomNavigationBar.dart';
import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';

class PhotoDeleteViewModel extends GetxController {
  final _api = PhotoDeleteRepository();

  UserPreference userPreference = UserPreference();

  RxString? photoId = ''.obs;
  RxBool loading = false.obs;
  void photodeleteApi() async {
    String? token = await userPreference.getToken();
    loading.value = true;
    print("Printing token -> $token");
    print("photo id -> ${photoId?.value}");
    print(photoId.runtimeType);
    Map<String, String>? body = {'gallery_image_key': photoId!.value};
    Map<String, String>? head = {
      "Authorization": "Bearer $token",
    };
    _api.photoDeleteApi(head, body).then((value) async {
      loading.value = false;

      if (value['status'] == 'failed') {
        Utils.toastMessageCenter(value['message'], true);
      } else {
        Get.delete<PhotoDeleteViewModel>();

        Utils.toastMessageCenter('Image removed successfully.', false);
        print("success");
        var userProfileView_vm = Get.put(UserProfileView_ViewModel());
        userProfileView_vm.UserProfileViewApi();
      }
    }).onError((error, stackTrace) {
      loading.value = false;
      print(error.toString());

      Utils.toastMessageCenter(error.toString(), true);
    });
  }
}
