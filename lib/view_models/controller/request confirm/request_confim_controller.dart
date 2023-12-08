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
import 'package:nauman/repository/post_api_repository/request_confirm_repo/request_confirm_repo.dart';
import 'package:nauman/repository/post_api_repository/request_remove_repo/request_remove_repo.dart';
import 'package:nauman/repository/post_api_repository/request_send_repo/request_send_repo.dart';
import 'package:nauman/utils/utils.dart';
import 'package:nauman/view/Authentication%20Screens/aboutYouScreen.dart';
import 'package:nauman/view/Authentication%20Screens/personalityQues.dart';
import 'package:nauman/view/Bottom%20Navigation%20Bar/bottomNavigationBar.dart';
import 'package:nauman/view_models/controller/request_list/request_list_controller.dart';
import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';

class RequestConfirmViewModel extends GetxController {
  final _api = RequestConfirmRepository();

  UserPreference userPreference = UserPreference();

  RxString? request_from_id = ''.obs;
  RxBool loading = false.obs;
  void requestConfirmApi() async {
    String? token = await userPreference.getToken();
    loading.value = true;
    print("Printing token -> $token");
    print("photo id -> ${request_from_id?.value}");

    Map<String, String>? body = {'request_from_id': request_from_id!.value};
    Map<String, String>? head = {
      "Authorization": "Bearer $token",
    };
    _api.requestConfirmApi(head, body).then((value) async {
      loading.value = false;

      if (value['status'] == 'failed') {
        Utils.toastMessageCenter(value['message'], true);
      } else {
        Get.delete<RequestConfirmViewModel>();
        // var requestList = Get.put(RequestListViewModel());
        // requestList.RequestListApi();

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
