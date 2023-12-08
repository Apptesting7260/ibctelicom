import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:nauman/data/response/status.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/models/agora%20token%20modal/agora_token.dart';
import 'package:nauman/models/favouriteList/favouriteListModalClass.dart';
import 'package:nauman/models/home/home_screen_modal_class.dart';
import 'package:nauman/repository/post_api_repository/agora%20token/agora_repo.dart';
import 'package:nauman/repository/post_api_repository/favourite_list_repo/favourite_list_repo.dart';
import 'package:nauman/repository/post_api_repository/home_screen_repo/home_screen_repo.dart';
import 'package:nauman/view/Bottom%20Navigation%20Bar/bottomNavigationBar.dart';
import 'package:nauman/view/Chat%20Screens/audioCallScreen.dart';
import 'package:nauman/view/Chat%20Screens/videoCallScreen.dart';
import 'package:http/http.dart' as http;

import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';

class AgoraTokenViewModal extends GetxController {
  final _api = AgoraTokenRepository();
  final rxRequestStatus = Status.LOADING.obs;
  RxBool loading = false.obs;
  final UserDataList = AgoraTokenModalClass().obs;
  RxString error = ''.obs;
  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;
  void setUserDataList(AgoraTokenModalClass _value) =>
      UserDataList.value = _value;
  void setError(String _value) => error.value = _value;

  UserPreference userPreference = UserPreference();
  RxString other_user_id = ''.obs;
  RxString room_id = ''.obs;
  RxString calling_type = ''.obs;
  sendNotification(String fcm, String title, String photoUrl, String token,
      String channelName, String what, String uid) async {
    print("CALLIN");
    var notificationContent = {
      'to':
          fcm,
      'notification': {'title': title, "image": photoUrl},
      'data': {
        'token': token,
        'img': photoUrl,
        'what': what,
        'channelName': channelName,
        'uid': uid
      }
    };
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(notificationContent),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAAYVChC60:APA91bFM8uA66qxVhQ4iOIlbEtjqHYytrxrN2ydBChrX-gHbq1kR3RdQxQh763nWtLH2t0w2BXuY92ta-RNtUMN8OSZiT6DIh_CJ6Q_afwBeu0tKiRxOuJ3s9YYnx8nyGVDNz8DalR8q'
        }).then((value) {
      if (kDebugMode) {
        print(value.body.toString());
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
    });
  }

  void AgoraTokenApi() async {
    String? token = await userPreference.getToken();

    setRxRequestStatus(Status.LOADING);

    Map<String, String>? head = {
      "Authorization": "Bearer $token",
    };
    Map<String, String> body = {
      "other_user_id": other_user_id.value,
      "room_id": room_id.value,
      "calling_type": calling_type.value
    };

    _api.AgoraTokenApi(head, body).then((value) {
      print("Correct value getting");
      setRxRequestStatus(Status.COMPLETED);
      setUserDataList(value);
      RxBool loading = false.obs;
      print(value.details!.rtcToken);
      if(value.details!.callingType == 'audio'){
        Get.off(()=>AudioCall(channelName: value.details!.channelName.toString(),token: value.details!.rtcToken.toString(),uid: value.details!.uid!,));   
      }
      else{

      Get.off(()=>VideoCall(channelName: value.details!.channelName.toString(),token: value.details!.rtcToken.toString(),uid: value.details!.uid!,));
      }
      sendNotification(
          value.details!.otherUserFcmToken!,
          value.details!.userName!,
          value.details!.userProfile!,
          value.details!.rtcToken!,
          value.details!.channelName!,
          value.details!.callingType!,
          value.details!.uid.toString());
    }).onError((error, stackTrace) {
      print("Error Getting");
      print(error.toString());

      loading = false.obs;
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }
}
