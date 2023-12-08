import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nauman/UI%20Components/app_url/app_url.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/utils/utils.dart';
import 'package:nauman/view/Authentication%20Screens/personalityQues.dart';
import 'package:nauman/view/Bottom%20Navigation%20Bar/bottomNavigationBar.dart';
import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';

class PersonalityQuestionPostViewModel extends GetxController {
  UserPreference userPreference = UserPreference();

  RxBool loading = false.obs;
  void personalityQPostApi(List<Map<String, dynamic>> questions) async {
    String? token = await UserPreference().getToken();
    loading.value = true;
    try {
      var url = Uri.parse(AppUrl.personalityQPostApiUrl);
      var payLoad = {"personality_questions": questions};
      print("Printing $payLoad");
      print(token);
      var jsonPayload = jsonEncode(payLoad);
      print("Json Response $jsonPayload");
      print("This is token id $token");
      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(payLoad));
      var jsonResponse = jsonDecode(response.body);

      print("Printing body own side $jsonResponse");
      if (response.statusCode == 200) {
        loading.value = false;
        if (jsonResponse['status'] == 'success') {
          Utils.toastMessageCenter(
              "Profile has been created successfully", false);

          Get.offAll(() => BottomNavigation(
            fromClear: false,
                passedIndex: 0,
              ));

          await userPreference.setStep(jsonResponse['current_step']);
          userPreference.getStep().then((step) {
            print("With Shared Preference Step : ${step}");
          });
          // Get.delete<PersonalityQuestionPostViewModel>();
        } else {
          loading.value = false;

          Utils.toastMessageCenter(jsonResponse['message'], true);
        }
        PersonalityQuesClassState().slectedListAnswers.clear();
      } else {
        loading.value = false;

        Utils.toastMessageCenter(jsonResponse['message'], true);
      }
    } catch (e) {
      loading.value = false;

      Utils.toastMessageCenter(e.toString(), true);
    }
  }
}
