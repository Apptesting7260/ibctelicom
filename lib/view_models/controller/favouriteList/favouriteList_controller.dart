import 'package:get/get.dart';

import 'package:nauman/data/response/status.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/models/favouriteList/favouriteListModalClass.dart';
import 'package:nauman/models/home/home_screen_modal_class.dart';
import 'package:nauman/repository/post_api_repository/favourite_list_repo/favourite_list_repo.dart';
import 'package:nauman/repository/post_api_repository/home_screen_repo/home_screen_repo.dart';
import 'package:nauman/view/Bottom%20Navigation%20Bar/bottomNavigationBar.dart';

import 'package:nauman/view/Other%20Profile/otherProfile.dart';
import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';

class FavouriteListViewModal extends GetxController {
  final _api = FavouriteListRepository();
  final rxRequestStatus = Status.LOADING.obs;
  RxBool loading = false.obs;
  final UserDataList = FavouriteListModalClass().obs;
  RxString error = ''.obs;
  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;
  void setUserDataList(FavouriteListModalClass _value) =>
      UserDataList.value = _value;
  void setError(String _value) => error.value = _value;
  RxString page_no = '1'.obs;
  RxString per_page = '6'.obs;
  UserPreference userPreference = UserPreference();

  void FavouriteListApi(bool pagination) async {
    print("Typeeee -> ${page_no.value.runtimeType}");
    print("Typeeee -> ${per_page.value.runtimeType}");
    if (pagination == false) {
      FavouriteDataList.clear();
    }
    String? token = await userPreference.getToken();
    if (pagination == false) {
      setRxRequestStatus(Status.LOADING);
    }
    Map<String, String>? head = {
      "Authorization": "Bearer $token",
    };
    Map<String, String> body = {
      "page_no": page_no.value,
      "per_page": per_page.value
    };

    _api.FavouriteListApi(head, body).then((value) {
      print("Correct value getting");
      setRxRequestStatus(Status.COMPLETED);
      setUserDataList(value);
      RxBool loading = false.obs;
    }).onError((error, stackTrace) {
      print("Error Getting");
      print(error.toString());

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
    Map<String, dynamic>? body = {
      'page_no': page_no.value,
      "per_page": per_page.value
    };
    setRxRequestStatus(Status.LOADING);

    _api.FavouriteListApi(head, body).then((value) {
      setRxRequestStatus(Status.COMPLETED);
      setUserDataList(value);
      Get.to(() => BottomNavigation(
        fromClear: false,
            passedIndex: 0,
          ));
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }
}
