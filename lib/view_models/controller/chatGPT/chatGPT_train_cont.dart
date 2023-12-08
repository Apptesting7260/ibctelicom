import 'dart:convert';

import 'package:get/get.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/repository/post_api_repository/chatGPT/chatGPT_train_repo.dart';

import 'package:nauman/utils/utils.dart';

class ChatGPT_trainViewModal extends GetxController {
  final _api = ChatGPTtrainRepository();
  RxString prompt = ''.obs;
  RxInt? user_id;
  RxInt? profile_id;

  RxBool loading = false.obs;
  void ChatGPT_trainApi() async {
    loading.value = true;
   print('Printing Prompt Value for testing');
   print(prompt.value);
   print(user_id);
   print(profile_id);
    Map body = {
      "prompt": prompt.value,
      "role": "user",
      "user_id": user_id!.value,
      "profile_id": profile_id!.value,
      "actioncode": "T"
    };
    Map<String,String> head = {
      "x-api-key": ChatGPTkey,
    };
    var data = jsonEncode(body);
    setHitGPT(false);
    _api.ChatGPTtainApi(head, data).then((value) async {
      loading.value = false;

      if (value['message'] == 'Success') {
        Utils.toastMessageCenter('GPT Train Success', false);
        print(" -----------------------------------------------------------------------------------------------> GPT Trained");
      } else {
        Get.delete<ChatGPT_trainViewModal>();
       
        Utils.toastMessageCenter(value['message'], false);
      }
    }).onError((error, stackTrace) {
      loading.value = false;
      print(error.toString());

      Utils.toastMessageCenter(error.toString(), true);
    });
  }
}
