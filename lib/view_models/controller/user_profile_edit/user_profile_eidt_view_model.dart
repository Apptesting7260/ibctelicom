import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/app_url/app_url.dart';

import 'package:nauman/UI%20Components/uploadPhoto.dart';
import 'package:nauman/repository/post_api_repository/about_you_repo/about_you_repo.dart';

import 'package:nauman/utils/utils.dart';
import 'package:nauman/view/Authentication%20Screens/personalityQues.dart';
import 'package:nauman/view/Bottom%20Navigation%20Bar/bottomNavigationBar.dart';
import 'package:nauman/view/My%20Profile/myProfile_view.dart';

import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';

class UserProfileEditViewModel extends GetxController {
  // UploadPhotoAboutScreen uploadPhotoObject = UploadPhotoAboutScreen(
  //   fromEditScreen: false,
  // );
  // final _api = AboutYouRepository();
  UserPreference userPreference = UserPreference();
  final aboutYouController = TextEditingController().obs;
  final userNameController = TextEditingController().obs;
  var gender = ''.obs;
  RxBool goback = false.obs;
  var age = ''.obs;
  var color = ''.obs;
  RxString heightofUser = ''.obs;
  var singleImagetakingpath;
  RxString? videotakingpath;
  final locationController = TextEditingController().obs;
  RxList<dynamic> hobbiesList = <String>[].obs;
  RxList<dynamic> educationList = <String>[].obs;
  var profession = ''.obs;
  RxList<dynamic> imageList = <dynamic>[].obs;
  var tokenid;
  RxBool loading = false.obs;

  void userProfileEditApi() async {
    loading.value = true;
    // userPreference.getToken().then((token) {
    //   tokenid = token;
    // });
    tokenid = await userPreference.getToken();
    print("height -> ${heightofUser.value}");
    print("Age -> ${age.value}");

// Chat Gpt
    var request =
        http.MultipartRequest('POST', Uri.parse(AppUrl.userProfileEditApiUrl));
    request.headers['Authorization'] = 'Bearer $tokenid';

    request.fields["about"] = aboutYouController.value.text;
    request.fields["user_name"] = userNameController.value.text;
    request.fields["gender"] = gender.value;
    request.fields["age"] = age.value;
    request.fields["color"] = color.value;
    request.fields["height"] = heightofUser.value;
    request.fields["location"] = locationController.value.text;
    request.fields["hobbies"] = hobbiesList.toString();
    request.fields["education"] = educationList.toString();
    request.fields["profession"] = profession.value;

    if (singleImagetakingpath != null) {
      File singleImage = singleImagetakingpath;
      String singleImageMimeType =
          lookupMimeType(singleImage.path) ?? 'image/jpeg';
      http.MultipartFile singleImageMultipartFile =
          await http.MultipartFile.fromPath(
        'pro_img', // Use appropriate field name for the single image
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
    if (imageList.isNotEmpty) {
      for (File image in imageList) {
        String mimeType = lookupMimeType(image.path) ?? 'image/jpeg';
        http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
          'gallery_img[]', // Use appropriate field name for images
          image.path,
          contentType: MediaType.parse(mimeType),
        );
        request.files.add(multipartFile);
      }
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        loading.value = false;

        Utils.toastMessageCenter('Profile updated successfully', false);
        var responseBody = jsonDecode(await response.stream.bytesToString());

        print('Response Body: $responseBody');
        Get.delete<UserProfileEditViewModel>();

        var userProfileView_vm = Get.put(UserProfileView_ViewModel());
        userProfileView_vm.refreshGPTApi();
      
     
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
