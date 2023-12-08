import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
// import 'package:getx_mvvm/models/login/user_model.dart';
// import 'package:getx_mvvm/repository/login_repository/login_repository.dart';
// import 'package:getx_mvvm/res/routes/routes_name.dart';
// import 'package:getx_mvvm/utils/utils.dart';
// import 'package:getx_mvvm/view_models/controller/user_preference/user_prefrence_view_model.dart';
import 'package:nauman/UI%20Components/routes/routes_name.dart';
import 'package:nauman/data/response/status.dart';
import 'package:nauman/models/color/color_modal.dart';
import 'package:nauman/models/education/education_modal_class.dart';
import 'package:nauman/models/hobbies/hobbies_modal_class.dart';
import 'package:nauman/models/login/user_model.dart';
import 'package:nauman/models/profession/profession_modal_class.dart';
import 'package:nauman/repository/get_api_repository/color_repository/color_repository.dart';
import 'package:nauman/repository/get_api_repository/education_repo/education_repo.dart';
import 'package:nauman/repository/get_api_repository/hobbes_repo/hobbies_repository.dart';
import 'package:nauman/repository/get_api_repository/profession_repo/profession_repo.dart';
import 'package:nauman/repository/post_api_repository/login_repository/login_repository.dart';
import 'package:nauman/utils/utils.dart';
import 'package:nauman/view/Authentication%20Screens/aboutYouScreen.dart';
import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';

class ProfessionViewModel extends GetxController {
  final _api = ProfessionGetRepository();
  final rxRequestStatus = Status.LOADING.obs;

  final ProfessionList = ProfessionModalClass().obs;
  RxString error = ''.obs;
  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;
  void setProfessionList(ProfessionModalClass _value) =>
      ProfessionList.value = _value;
  void setError(String _value) => error.value = _value;

  void ProfessionApi() {
    //  setRxRequestStatus(Status.LOADING);

    _api.ProfessionApi().then((value) {
      setRxRequestStatus(Status.COMPLETED);
      setProfessionList(value);
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }

  void refreshApi() {
    setRxRequestStatus(Status.LOADING);

    _api.ProfessionApi().then((value) {
      setRxRequestStatus(Status.COMPLETED);
      setProfessionList(value);
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }
}
