import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:nauman/repository/post_api_repository/block_unblock_repo/block_unblock_repo.dart';

import 'package:nauman/utils/utils.dart';
import 'package:nauman/view/Other%20Profile/otherProfile.dart';
import 'package:nauman/view_models/controller/other_profile_view/other_profile_view_viewModel.dart';

import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';

class BlockUnblockViewModel extends GetxController {
  final _api = BlockUnblockRepository();
  var otherProfileController = Get.put(OtherProfileView_ViewModel());
  UserPreference userPreference = UserPreference();

  RxString? blocked_user_id = ''.obs;
  RxBool fromChat = false.obs;
  RxBool loading = false.obs;
  RxString? collection = ''.obs;
  RxString? collectionOth = ''.obs;
  RxString? rid = ''.obs;
  RxBool fromBlock = false.obs;
  Future<void> createOrJoinChatRoom(
      bool blockVal, String collectionN, String rId) async {
    var _firestore = FirebaseFirestore.instance;
    DocumentReference roomRef = _firestore.collection(collectionN).doc(rId);

    await roomRef.update({'ownBlock': blockVal});
  }

  Future<void> createOrJoinChatRoomOther(
      bool blockVal, String collectionN, String rId) async {
    var _firestore = FirebaseFirestore.instance;
    DocumentReference roomRef = _firestore.collection(collectionN).doc(rId);
    roomRef.update({'block': blockVal});
  }

  void blockUnblockApi() async {
    String? token = await userPreference.getToken();
    loading.value = true;
    print("Printing token -> $token");
    print("photo id -> ${blocked_user_id?.value}");

    Map<String, String>? body = {'blocked_user_id': blocked_user_id!.value};
    Map<String, String>? head = {
      "Authorization": "Bearer $token",
    };
    _api.blockUnblockApi(head, body).then((value) async {
      loading.value = false;

      if (value['status'] == 'failed') {
        Utils.toastMessageCenter(value['message'], true);
      } else {
        Get.delete<BlockUnblockViewModel>();

        Utils.toastMessageCenter(value['message'], false);
        print("success");
        if (value['message'] == "Blocked Succesfuly") {
          if (otherProfileController
                  .UserDataList.value.candidateList?.requestStatus ==
              3) {
            OtherProfileState().createOrJoinChatRoomOther(true);
            OtherProfileState().createOrJoinChatRoom(true);
          } else if (fromChat.value == true) {
            print("calling this this this ");
            createOrJoinChatRoom(true, collection!.value, rid!.value);
            createOrJoinChatRoomOther(true, collectionOth!.value, rid!.value);
          } else {
            print('Not a connection');
          }
        } else {
          if (otherProfileController
                  .UserDataList.value.candidateList?.requestStatus ==
              3) {
            OtherProfileState().createOrJoinChatRoomOther(false);
            OtherProfileState().createOrJoinChatRoom(false);
          } else if (fromChat.value == true) {
            print("calling that thatthat that ");

            createOrJoinChatRoom(false, collection!.value, rid!.value);
            createOrJoinChatRoomOther(false, collectionOth!.value, rid!.value);
          } 
          else if(rid != null && fromBlock.value == true){
            print('going here');
                   createOrJoinChatRoom(false, collection!.value, rid!.value);
            createOrJoinChatRoomOther(false, collectionOth!.value, rid!.value);
          }
          
          else {
            print('Not a connection');
          }
        }
      }
    }).onError((error, stackTrace) {
      loading.value = false;
      print(error.toString());

      Utils.toastMessageCenter(error.toString(), true);
    });
  }
}
