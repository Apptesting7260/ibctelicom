import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:nauman/data/response/status.dart';

import 'package:nauman/models/chatGPT/chatGPT_responseModal.dart';

import 'package:nauman/repository/post_api_repository/chatGPT/chatGPT_response_repo.dart';

class ChatGPT_responseViewModal extends GetxController {
  final _api = ChatGPT_responseRepository();
  var rxRequestStatus = Status.LOADING.obs;
  RxBool loading = false.obs;
  final UserDataList = ChatGPT_responseModalClass().obs;
  RxString error = ''.obs;
  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;
  void setUserDataList(ChatGPT_responseModalClass _value) =>
      UserDataList.value = _value;
  void setError(String _value) => error.value = _value;

  var prompt = TextEditingController().obs;
  RxInt? user_id;
  RxInt? profile_id;
  void ChatGPT_responseApi() async {
    setRxRequestStatus(Status.LOADING);

    Map<String, String> head = {
      "x-api-key": "5KoOINAy3g71nPiaBR54e3nkZ9goUtQg4HKp7GPG",
    };

    Map<String, dynamic> body = {
      "prompt": prompt.value.text,
      "role": "user",
      "user_id": user_id!.value,
      "profile_id": profile_id!.value,
      "actioncode": "C"
    };

    var d = jsonEncode(body);

    _api.ChatGPT_responseApi(head, d).then((value) {
      print("Correct gpt value getting");
      setRxRequestStatus(Status.COMPLETED);
      setUserDataList(value);
      loading = false.obs;
    }).onError((error, stackTrace) {
      print("Error Getting");
      print(error.toString());

      loading = false.obs;
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }
}
