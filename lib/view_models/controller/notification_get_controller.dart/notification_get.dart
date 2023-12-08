import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
// import 'package:getx_mvvm/models/login/user_model.dart';
// import 'package:getx_mvvm/repository/login_repository/login_repository.dart';
// import 'package:getx_mvvm/res/routes/routes_name.dart';
// import 'package:getx_mvvm/utils/utils.dart';
// import 'package:getx_mvvm/view_models/controller/user_preference/user_prefrence_view_model.dart';
import 'package:nauman/UI%20Components/routes/routes_name.dart';
import 'package:nauman/data/response/status.dart';
import 'package:nauman/models/color/color_modal.dart';
import 'package:nauman/models/hobbies/hobbies_modal_class.dart';
import 'package:nauman/models/login/user_model.dart';
import 'package:nauman/models/notification_get/notification_get.dart';
import 'package:nauman/repository/get_api_repository/color_repository/color_repository.dart';
import 'package:nauman/repository/get_api_repository/hobbes_repo/hobbies_repository.dart';
import 'package:nauman/repository/get_api_repository/notifcation_get/notification_get_repo.dart';
import 'package:nauman/repository/post_api_repository/login_repository/login_repository.dart';
import 'package:nauman/utils/utils.dart';
import 'package:nauman/view/Authentication%20Screens/aboutYouScreen.dart';
import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';

class NotificationGetController extends GetxController {
  final _api = NotificationGetRepository();
  final rxRequestStatus = Status.LOADING.obs;

  final NotificationList = NotificationGetListModalClass().obs;
  RxString error = ''.obs;
  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;
  void setNotificationList(NotificationGetListModalClass _value) => NotificationList.value = _value;
  void setError(String _value) => error.value = _value;

  void NotificationGetAPI() {
     setRxRequestStatus(Status.LOADING);

    _api.NotificationGetApi().then((value) {
      setRxRequestStatus(Status.COMPLETED);
      setNotificationList(value);
        
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }

  void refreshApi() {
    setRxRequestStatus(Status.LOADING);

    _api.NotificationGetApi().then((value) {
      setRxRequestStatus(Status.COMPLETED);
      setNotificationList(value);
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }
}
