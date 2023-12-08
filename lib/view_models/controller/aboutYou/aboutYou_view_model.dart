import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/app_url/app_url.dart';

import 'package:nauman/UI%20Components/uploadPhoto.dart';
import 'package:nauman/global_variables.dart';

import 'package:nauman/utils/utils.dart';
import 'package:nauman/view/Authentication%20Screens/personalityQues.dart';

import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';

class AboutYouViewModel extends GetxController {
  UploadPhotoAboutScreen uploadPhotoObject = UploadPhotoAboutScreen(
    fromEditScreen: false,
  );
  // final _api = AboutYouRepository();
  UserPreference userPreference = UserPreference();
  final aboutYouController = TextEditingController().obs;
  final userNameController = TextEditingController().obs;
  var gender = ''.obs;
  RxString? age;
  var color = ''.obs;
  RxString? height;
  var singleImagetakingpath;
  RxString? videotakingpath;
  final locationController = TextEditingController().obs;
  RxList<dynamic> hobbiesList = <String>[].obs;
  RxList<dynamic> educationList = <String>[].obs;
  var profession = ''.obs;

  RxList<dynamic> imageList = <dynamic>[].obs;
  var tokenid;
  RxBool loading = false.obs;

  void aboutYouApi() async {
    loading.value = true;
    // userPreference.getToken().then((token) {
    //   tokenid = token;
    // });
    tokenid = await userPreference.getToken();

// Chat Gpt
    var request =
        http.MultipartRequest('POST', Uri.parse(AppUrl.aboutYouApiUrl));
    request.headers['Authorization'] = 'Bearer $tokenid';

    request.fields["about_you"] = aboutYouController.value.text;
    // request.fields["user_name"] = userNameController.value.text;
    request.fields["gender"] = gender.value;
    request.fields["age"] = age!.value;
    request.fields["color"] = color.value;
    request.fields["height"] = height!.value;
    request.fields["location"] = locationController.value.text;
    request.fields["hobbies"] = hobbiesList.toString();
    request.fields["education"] = educationList.toString();
    request.fields["profession"] = profession.value;

    // File singleImage = File('path_to_single_image.jpg');
    if (singleImagetakingpath != null) {
      File singleImage = File(singleImagetakingpath);
      String singleImageMimeType =
          lookupMimeType(singleImage.path) ?? 'image/jpeg';
      http.MultipartFile singleImageMultipartFile =
          await http.MultipartFile.fromPath(
        'profile_img', // Use appropriate field name for the single image
        singleImage.path,
        contentType: MediaType.parse(singleImageMimeType),
      );
      request.files.add(singleImageMultipartFile);
    }

    // Add video file
    if (videotakingpath != null) {
      File videoFile = File(videotakingpath.toString());
      String videoMimeType =
          lookupMimeType(videoFile.path) ?? 'application/octet-stream';
      http.MultipartFile videoMultipartFile = await http.MultipartFile.fromPath(
        'user_video', // Use appropriate field name for video
        videoFile.path,
        contentType: MediaType.parse(videoMimeType),
      );
      request.files.add(videoMultipartFile);
    }

    // Add multiple images as a list
    for (File image in imageList) {
      String mimeType = lookupMimeType(image.path) ?? 'image/jpeg';
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'gallery_img[]', // Use appropriate field name for images
        image.path,
        contentType: MediaType.parse(mimeType),
      );
      request.files.add(multipartFile);
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        loading.value = false;

        Utils.toastMessageCenter('Profile details inserted', false);
        var responseBody = jsonDecode(await response.stream.bytesToString());
        print("REsponse printing step $responseBody['current_step']");
        await userPreference.setStep(responseBody['current_step']);
        userPreference.getStep().then((step) {
          print("With Shared Preference Step : ${step}");
        });
        print('Response Body: $responseBody');
        Get.delete<AboutYouViewModel>();
        Get.to(() => PersonalityQuesClass());
        ImagesPathList.clear();
        videoPath = null;
      } else {
        loading.value = false;

        Utils.toastMessageCenter('Failed to upload data.', true);
        print("printing status code ${response.statusCode}");
      }
    } catch (error) {
      Utils.toastMessageCenter(error.toString(), true);
      loading.value = false;
    } finally {
      loading.value = false;
    }
  }
}























// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:nauman/UI%20Components/routes/routes_name.dart';
// import 'package:nauman/repository/post_api_repository/about_you_repo/about_you_repo.dart';
// import 'package:nauman/repository/post_api_repository/signup_repository/signup_repository.dart';

// import 'package:nauman/utils/utils.dart';
// import 'package:nauman/view/Authentication%20Screens/aboutYouScreen.dart';
// import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';

// class AboutYouViewModel extends GetxController {
//   final _api = AboutYouRepository();
//   UserPreference userPreference = UserPreference();
//   final aboutYouController = TextEditingController().obs;
//   final userNameController = TextEditingController().obs;
//   final gender = ''.obs;
//   final age = ''.obs;
//   final color = ''.obs;
//   final height = ''.obs;
//   final locationController = TextEditingController().obs;
//   final RxList<String> hobbiesList = <String>[].obs;
//   final RxList<String> educationList = <String>[].obs;
//   final proffessionController = TextEditingController().obs;
//   var tokenid;
//   RxBool loading = false.obs;

//   void signUpApi() {
//     loading.value = true;
//     userPreference.getToken().then((token) {
//       tokenid = token;
//     });
//     Map data = {
//       "about_you": aboutYouController.value.text,
//       "user_name": userNameController.value.text,
//       "gender": gender.value,
//       "age": age.value,
//       "color": color.value,
//       "height": height.value,
//       "location": locationController.value.text,
//       "hobbies": hobbiesList,
//       "education": educationList,
//       "profession": proffessionController.value.text,
//     };
//     Map header = {
//       "Authorization": 'Bearer $tokenid',
//     };
//     _api.aboutYouUpApi(data, header).then((value) {
//       loading.value = false;

//       if (value['status'] == 'failed') {
//         Utils.snackBar('Error', value['message'], true);
//       } else {
//         if (value['current_step'] == '2') {
//           Get.to(() => AboutYouClass());
//           Utils.snackBar('Success', 'Profile details inserted.', false);
//         }

//         Get.delete<AboutYouViewModel>();
//       }
//     }).onError((error, stackTrace) {
//       loading.value = false;
//       Utils.snackBar('Error', error.toString(), true);
//     });
//   }
// }
