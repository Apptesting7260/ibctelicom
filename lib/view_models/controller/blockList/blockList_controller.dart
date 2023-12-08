
import 'package:get/get.dart';


import 'package:nauman/data/response/status.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/models/blockList/blockList_modal_class.dart';
import 'package:nauman/repository/post_api_repository/block_list_repo/block_list_repo.dart';
import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';




class BlockListViewModel extends GetxController {
  final _api = BlockListRepository();
  final rxRequestStatus = Status.LOADING.obs;
   UserPreference userPreference = UserPreference();
  final UserDataList = BlockListModalClass().obs;
  RxString error = ''.obs;
  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;
  void setUserDataList(BlockListModalClass _value) =>
      UserDataList.value = _value;
  void setError(String _value) => error.value = _value;
   RxString page_no = '1'.obs;
  RxString per_page = '9'.obs;
  void BlockListApi(bool pagination) async{
    print('We are calling the api bro');
    print(page_no.value);
    if(pagination == false){
      BlockDataList.clear();
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

    _api.BlockListGetApi(head,body).then((value) {
      setRxRequestStatus(Status.COMPLETED);
      setUserDataList(value);
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }

  void refreshApi() async{
    setRxRequestStatus(Status.LOADING);
     String? token = await userPreference.getToken();
    Map<String, String>? head = {
      "Authorization": "Bearer $token",
    };
    Map<String, String> body = {
      "page_no": page_no.value,
      "per_page": per_page.value
    };
    _api.BlockListGetApi(head,body).then((value) {
      setRxRequestStatus(Status.COMPLETED);
      setUserDataList(value);
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }
}
