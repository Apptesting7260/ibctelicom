import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/components/general_exception.dart';
import 'package:nauman/UI%20Components/components/internet_exceptions_widget.dart';
import 'package:nauman/UI%20Components/eucationSelection.dart';
import 'package:nauman/UI%20Components/hobbiesSelection.dart';
import 'package:nauman/UI%20Components/professionSelection.dart';
import 'package:nauman/UI%20Components/uploadPhoto.dart';
import 'package:nauman/UI%20Components/videoUpload.dart';
import 'package:nauman/UI%20Components/video_player.dart';
import 'package:nauman/data/response/status.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/utils/utils.dart';
import 'package:nauman/view_models/controller/aboutYou/aboutYou_view_model.dart';
import 'package:nauman/view_models/controller/color/color_view_model.dart';
import 'package:nauman/view_models/controller/photo_delete/photo_delete_view_model.dart';
import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';
import 'package:nauman/view_models/controller/user_profile_edit/user_profile_eidt_view_model.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';
import 'package:nauman/view_models/controller/video_delete_view_model.dart';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nauman/UI%20Components/button.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/sliderCustomTrackShape.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/UI%20Components/textField.dart';
import 'package:nauman/view/Authentication%20Screens/inviteFriends.dart';

import 'package:nauman/view/Authentication%20Screens/personalityQues.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
class MyProfileEdit extends StatefulWidget {
  @override
  State<MyProfileEdit> createState() => MyProfileEditState();
}

class MyProfileEditState extends State<MyProfileEdit> {
   final String googleAPiKey = "AIzaSyD2fbGTF3K3fsFDwPqrptht7hNipho1VsY";
  String? SelectedLocation;
  String? Sikeraddress;

  // final locationcntroller = TextEditingController();
  List<Predictions> searchPlace = [];
  final colorVM = Get.put(ColorViewModel());
  final UserPreference userPreference = UserPreference();
  final aboutYouViewModel = Get.put(AboutYouViewModel());
  var userProfileView_vm = Get.put(UserProfileView_ViewModel());
  var userProfileEdit_vm = Get.put(UserProfileEditViewModel());
  var photoDelete_view_model = Get.put(PhotoDeleteViewModel());
  var videoDelete_view_model = Get.put(VideoDeleteViewModel());
  List<String> selectedHobbies = [];
  List<String> selectedEducation = [];
  RxString selectedProfession = ''.obs;
  List<dynamic> selectedGalleryPhotos = [];
  bool noVideo = false;
  String? videoGetUrl;
  dynamic profileImageGetUrl;
  dynamic aboutGetValue;
  dynamic nameGetValue;
  RxString? genderGetValue;
  dynamic ageGetValue;
  RxString colorGetValue = ''.obs;
  dynamic heightGetValue;
  dynamic locationGetValue;
  List interestGetValue = [];
  List educationGetValue = [];
  dynamic professionGetValue;
  List galleryGetValue = [];
  int? originalGalleryImagesLength;
  @override
  void initState() {
    colorVM.ColorApi();
    // TODO: implement initState
    super.initState();
    userProfileView_vm.UserProfileViewApi();

    //  Here Iam initializing the get values so that we can pass them to user profile edit api if user don't change any.

    // video
    videoGetUrl = userProfileView_vm
        .UserDataList.value.userData?.userDetails?.userVideoUrl?.userVideo;
    if (videoGetUrl == null) {
      noVideo = true;
    }
    // gallery images array
    for (int i = 0;
        i <
            userProfileView_vm.UserDataList.value.userData!.userDetails!
                .galleryImagesUrl!.length;
        i++) {
          print("runing ${i}");
      galleryGetValue.add(userProfileView_vm.UserDataList.value.userData!
          .userDetails!.galleryImagesUrl![i].galleryImages!);
    }
    originalGalleryImagesLength = galleryGetValue.length;
    // interest
    interestGetValue =
        userProfileView_vm.UserDataList.value.userData!.userDetails!.hobbies!;
    // education
    educationGetValue =
        userProfileView_vm.UserDataList.value.userData!.userDetails!.education!;
    // about
    aboutGetValue =
        userProfileView_vm.UserDataList.value.userData!.userDetails!.about;
    // name
    nameGetValue = userProfileView_vm.UserDataList.value.userData!.userName;
    // age
    ageGetValue = userProfileView_vm
        .UserDataList.value.userData!.userDetails!.age!
        .toDouble();
    // height
    heightGetValue = userProfileView_vm
        .UserDataList.value.userData!.userDetails!.height!
        .toDouble();
    print(userProfileView_vm
        .UserDataList.value.userData!.userDetails!.height!.runtimeType);

    // location
    locationGetValue =
        userProfileView_vm.UserDataList.value.userData!.userDetails!.location;
    // profession
    professionGetValue =
        userProfileView_vm.UserDataList.value.userData!.userDetails!.profession;
    // profile image url
    profileImageGetUrl =
        userProfileView_vm.UserDataList.value.userData!.proImgUrl;
    // color
    colorGetValue =
        userProfileView_vm.UserDataList.value.userData!.userDetails!.color!.obs;
    // gender
    genderGetValue = userProfileView_vm
        .UserDataList.value.userData!.userDetails!.gender!.obs;

    print("with var Image -> $profileImageGetUrl ");
    print(
        "with Direct Image -> ${userProfileView_vm.UserDataList.value.userData!.proImgUrl!}");
  }

  bool newVideoUploaded = false;

  var _formKey = GlobalKey<FormState>();
  final List<String> items = [
    'Male',
    'Female',
    'Other',
  ];

  String? selectedGenderValue;
  String? selectColorValue;

  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      // Get the original image size
      File originalImage = File(pickedImage.path);
      int originalSize = await originalImage.length();

      // Compress the selected image
      var compressedImageData = await FlutterImageCompress.compressWithFile(
        pickedImage.path,
        quality: 85, // Adjust the quality as needed (0 to 100)
      );

      File compressedImage = File(pickedImage.path)
        ..writeAsBytesSync(compressedImageData!);

      int compressedSize = await compressedImage.length();

      print('Original image size: $originalSize bytes');
      print('Compressed image size: $compressedSize bytes');
      print('Path ---> ' + compressedImage.path);

      setState(() {
        _image = compressedImage;
        profileImageGetUrl = _image;
        print("Hello khushal we are printing the path $_image ");
      });
    }
  }

  TextEditingController aboutYouController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final height = Get.height;
    RxBool isAboutEditing = false.obs;
    RxBool isNameEditing = false.obs;
    RxBool isLocationEditing = false.obs;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        bottomSheet: Obx(
          () => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Button(
                loading: userProfileEdit_vm.loading.value,
                // bgcolor: isLoginButtonEnabled ? primaryDark : F3F6F6,
                bgcolor: primaryDark,
                textColor: Colors.white,
                onTap: () {
                  aboutYouController.value.text.isNotEmpty
                      ? userProfileEdit_vm.aboutYouController.value =
                          aboutYouController
                      : userProfileEdit_vm.aboutYouController.value.text =
                          aboutGetValue;
                  nameController.value.text.isNotEmpty
                      ? userProfileEdit_vm.userNameController.value =
                          nameController
                      : userProfileEdit_vm.userNameController.value.text =
                          nameGetValue;
                  locationController.value.text.isNotEmpty
                      ? userProfileEdit_vm.locationController.value =
                          locationController
                      : userProfileEdit_vm.locationController.value.text =
                          locationGetValue;
                  selectedProfession.value.isNotEmpty
                      ? userProfileEdit_vm.profession = selectedProfession
                      : userProfileEdit_vm.profession.value =
                          professionGetValue;
                  userProfileEdit_vm.age = ageGetValue.toString().obs;
                  userProfileEdit_vm.color = colorGetValue;
                  userProfileEdit_vm.educationList = educationGetValue.obs;
                  userProfileEdit_vm.gender = genderGetValue!;

                  userProfileEdit_vm.heightofUser =
                      heightGetValue.toString().trim().obs;
                  userProfileEdit_vm.hobbiesList = interestGetValue.obs;

                  if (profileImageGetUrl is File) {
                    userProfileEdit_vm.singleImagetakingpath =
                        profileImageGetUrl;
                  }
                  if (selectedGalleryPhotos.isNotEmpty) {
                    userProfileEdit_vm.imageList = selectedGalleryPhotos.obs;
                  }
                  print("Height -> ${userProfileEdit_vm.heightofUser.value}");
                  print("Age -> ${userProfileEdit_vm.age.value}");
                  print(
                      "Height -> ${userProfileEdit_vm.heightofUser.runtimeType}");
                  userProfileEdit_vm.userProfileEditApi();
                  // if (userProfileEdit_vm.goback.value = true) {
                  //   userProfileView_vm.UserProfileViewApi();
                  //   Get.back();
                  // }
                  // print("Gallery Get Value -> ${galleryGetValue}");
                  // print("Selected Gallery Photos -> ${selectedGalleryPhotos}");
                  // print("Image Path List -> ${ImagesPathList}");
                  // print(" About Value  fgdg -> ${userProfileEdit_vm.height}");

                  // print(videoGetUrl);
                  // print(profileImageGetUrl);
                  // print(
                  //     "Controller VAlue -> ${userProfileEdit_vm.aboutYouController.value.text}");
                  // print(profileImageGetUrl);
                  // print(aboutGetValue);
                  // print(nameGetValue);
                  // print(genderGetValue);
                  // print(ageGetValue);
                  // print(colorGetValue);
                  // print(heightGetValue);
                  // print(locationGetValue);
                  // print(interestGetValue);
                  // print(educationGetValue);
                  // print(professionGetValue);
                  // print(galleryGetValue);
                  // print(videoGetUrl);
                  // print(galleryGetValue);
                },
                title: 'Save Changes'),
          ),
        ),
        body: Obx(() {
          switch (userProfileView_vm.rxRequestStatus.value) {
            case Status.LOADING:
              return Center(
                  child: CircularProgressIndicator(
                color: primaryDark,
              ));
            case Status.ERROR:
              if (userProfileView_vm.error.value == 'No internet') {
                return InterNetExceptionWidget(
                  onPress: () {
                    userProfileView_vm.refreshApi();
                  },
                );
              } else {
                return GeneralExceptionWidget(onPress: () {
                  userProfileView_vm.refreshApi();
                });
              }
            case Status.COMPLETED:
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 90),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Pic
                      Center(
                        child:
                            Stack(alignment: Alignment.bottomRight, children: [
                          _image == null
                              ? CachedNetworkImage(
                                  imageUrl: profileImageGetUrl.toString(),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 150.0,
                                    height: 150.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(
                                    color: primaryDark,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                )
                              // CircleAvatar(
                              //     radius: 65,
                              //     backgroundImage: CachedNetworkImageProvider(
                              //         profileImageGetUrl.toString()))
                              : CircleAvatar(
                                  radius: 65,
                                  backgroundImage: Image.file(
                                    File(_image!.path),
                                    fit: BoxFit.cover,
                                  ).image,
                                ),
                          InkWell(
                            onTap: () {
                              ShowDialog(context);
                            },
                            child: CircleAvatar(
                              backgroundColor: primaryDark,
                              radius: 15,
                              child: Icon(
                                Icons.pin_end,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          )
                        ]),
                      ),

                      SizedBox(height: height * .05),
                      // About You, Discover Your, Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextClass(
                              size: 18,
                              fontWeight: FontWeight.w500,
                              title: 'Your About',
                              fontColor: primaryDark),
                          IconButton(
                            onPressed: () {
                              isAboutEditing.value = !isAboutEditing.value;
                              aboutGetValue = aboutYouController.value.text;
                            },
                            icon: Icon(
                                isAboutEditing.value ? Icons.done : Icons.edit),
                            color: primaryDark,
                          )
                        ],
                      ),
                      TextFormField(
                        enabled: isAboutEditing.value,
                        controller: aboutYouController,
                        decoration: InputDecoration(hintText: aboutGetValue),
                      ),

                      SizedBox(height: height * .04),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextClass(
                              size: 18,
                              fontWeight: FontWeight.w500,
                              title: 'Your Name',
                              fontColor: primaryDark),
                          IconButton(
                            onPressed: () {
                              isNameEditing.value = !isNameEditing.value;
                            },
                            icon: Icon(
                                isNameEditing.value ? Icons.done : Icons.edit),
                            color: primaryDark,
                          )
                        ],
                      ),
                      TextFormField(
                        enabled: isNameEditing.value,
                        controller: nameController,
                        decoration: InputDecoration(
                            // labelText: 'Your Name',
                            hintText: nameGetValue),
                      ),

                      SizedBox(height: height * .04),
                      //  Gender Drop Down button
                      TextClass(
                          size: 14,
                          fontWeight: FontWeight.w500,
                          title: 'Gender',
                          fontColor: primaryDark),
                      // select gender Dropdown
                      DropdownButtonFormField2<String>(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a gender';
                          }
                          return null;
                        },
                        isExpanded: true,
                        alignment: Alignment.centerLeft,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        hint: Text(
                          genderGetValue.toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        items: items
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        // value: selectedGenderValue,
                        onChanged: (String? value) {
                          setState(() {
                            genderGetValue = value!.obs;
                            selectedGenderValue = value;
                            aboutYouViewModel.gender = value!.obs;
                            print(selectedGenderValue);
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          padding: EdgeInsets.only(right: 10),
                          height: height * .02,
                          width: Get.width,
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          height: height * .05,
                        ),
                        iconStyleData: IconStyleData(
                            icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: primaryDark,
                        )),
                      ),

                      SizedBox(height: height * .04),
                      // Age Text and Show Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextClass(
                              size: 14,
                              fontWeight: FontWeight.w500,
                              title: 'Age',
                              fontColor: primaryDark),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: TextClass(
                                size: 14,
                                fontWeight: FontWeight.w400,
                                title: ageGetValue.toInt().toString(),
                                fontColor: primaryDark),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .01,
                      ),
                      //Age Slider
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SliderTheme(
                          data: SliderThemeData(
                            thumbShape:
                                SliderThumbShape(disabledThumbRadius: 20),
                            trackShape: CustomTrackShape(),
                            thumbColor: Colors.white,
                            activeTrackColor: primaryDark,
                          ),
                          child: Slider(
                              value: ageGetValue,
                              // value: aboutYouViewModel.age,
                              max: 100,
                              divisions: 100,
                              inactiveColor: Colors.grey.shade200,
                              onChanged: (double value) {
                                setState(() {
                                  ageGetValue = value;
                                });
                              }),
                        ),
                      ),
                      SizedBox(height: height * .03),
                      // Color Drop Down
                      TextClass(
                          size: 14,
                          fontWeight: FontWeight.w500,
                          title: 'Color',
                          fontColor: primaryDark),

                      Obx(() {
                        switch (colorVM.rxRequestStatus.value) {
                          case Status.LOADING:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          case Status.ERROR:
                            if (colorVM.error.value == 'No internet') {
                              return InterNetExceptionWidget(
                                onPress: () {
                                  colorVM.refreshApi();
                                },
                              );
                            } else {
                              return GeneralExceptionWidget(
                                onPress: () {
                                  colorVM.refreshApi();
                                },
                              );
                            }
                          case Status.COMPLETED:
                            return DropdownButtonFormField2<String>(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Select a Color';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                              isDense: true,
                              isExpanded: true,
                              hint: Text(
                                colorGetValue.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              items:
                                  colorVM.colorList.value.profileColour == null
                                      ? List.empty()
                                      : colorVM.colorList.value.profileColour!
                                          .map((colorItem) {
                                          return DropdownMenuItem<String>(
                                            value: colorItem.colorName,
                                            child: Text(
                                              colorItem.colorName.toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                              // value: colorGetValue,
                              onChanged: (String? value) {
                                setState(() {
                                  colorGetValue = value!.obs;
                                  // aboutYouViewModel.color = value!.obs;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                padding: EdgeInsets.only(right: 10),
                                height: height * .02,
                                width: Get.width,
                              ),
                              menuItemStyleData: MenuItemStyleData(
                                height: height * .05,
                              ),
                              iconStyleData: IconStyleData(
                                  icon: Icon(
                                Icons.edit,
                                color: primaryDark,
                              )),
                            );
                        }
                      }),

                      SizedBox(height: height * .04),

                      // Height Slider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextClass(
                                size: 15,
                                fontWeight: FontWeight.w500,
                                title: 'Height',
                                fontColor: primaryDark),
                          ),
                          TextClass(
                              size: 15,
                              fontWeight: FontWeight.w500,
                              title:
                                  "${heightGetValue ~/ 12} ft ${(heightGetValue % 12).toInt()} ",
                              fontColor: primaryDark),
                          Padding(
                            padding: const EdgeInsets.only(right: 17),
                            child: TextClass(
                                size: 15,
                                fontWeight: FontWeight.w500,
                                title: 'in',
                                fontColor: primaryDark),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .01,
                      ),
                      SliderTheme(
                        data: SliderThemeData(
                          thumbShape: SliderThumbShape(disabledThumbRadius: 20),
                          trackShape: CustomTrackShape(),
                          thumbColor: Colors.white,
                          activeTrackColor: primaryDark,
                        ),
                        child: Slider(
                            value: heightGetValue,
                            max: 120,
                            min: 0,
                            divisions: 120,
                            inactiveColor: Colors.grey.shade200,
                            onChanged: (double value) {
                              setState(() {
                                heightGetValue = value;
                                int intval = value.toInt();
                                userProfileEdit_vm.heightofUser =
                                    intval.toString().obs;
                              });
                            }),
                      ),

                      // Location
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextClass(
                              size: 18,
                              fontWeight: FontWeight.w500,
                              title: 'Location',
                              fontColor: primaryDark),
                          IconButton(
                            onPressed: () {
                              isLocationEditing.value =
                                  !isLocationEditing.value;
                            },
                            icon: Icon(isLocationEditing.value
                                ? Icons.done
                                : Icons.edit),
                            color: primaryDark,
                          )
                        ],
                      ),
                      // TextFormField(
                      //   controller: locationController,
                      //   enabled: isLocationEditing.value,
                      //   decoration: InputDecoration(hintText: locationGetValue),
                      // ),
                      
                      TextFormField(
                        // enabled: isLocationEditing.value,
                  keyboardType: TextInputType.text,
                  controller: locationController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter your address';
                    }
                  },
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      if (locationController.value.text.isEmpty) {
                        Sikeraddress = value;
                        searchPlace.clear();
                      }
                    });
                    searchAutocomplete(value);
                  },
                  maxLines: 4,
                  minLines: 1,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    labelStyle: TextStyle(
                        color: lableDropDownCol,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                    labelText: locationGetValue ,

                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: primaryDark),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: primaryGrey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: primaryGrey),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: primaryGrey),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: primaryGrey),
                    ),
                  ),
                ),
                Visibility(
                  visible: searchPlace.isNotEmpty,
                  child: Container(
                    width: Get.width,
                    height: height * .25,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100,
                        boxShadow: [BoxShadow(color: primaryGrey)]),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchPlace.length,
                        itemBuilder: (context, index) => ListTile(
                              onTap: () {
                                setState(() {
                                locationController.text =
                                      searchPlace[index].description ?? "";

                                  SelectedLocation = locationController.value.text;
                                  print(SelectedLocation);
                                  Sikeraddress = SelectedLocation;
                                  print("$Sikeraddress=============");
                                  setState(() {
                                    searchPlace.clear();
                                  });
                                });
                              },
                              horizontalTitleGap: 0,
                              title: Text(
                                searchPlace[index].description ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                  ),
                ),
                         

                      // Previous Location
                      // TextFieldClass(
                      //   controller: aboutYouViewModel.locationController.value,
                      //   hint: 'Location',
                      //   isObs: false,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       checkLoginButtonStatus();
                      //     });
                      //   },
                      //   validator: _validateLocation,
                      // ),
                      const SizedBox(height: 30),

                      //  Interests
                      InkWell(
                          onTap: () async {
                            selectedHobbies =
                                await Get.to(() => HobbiesSelection(
                                      fromEditScreen: true,
                                      fromFilter: false,
                                    ));
                            interestGetValue = selectedHobbies;
                            aboutYouViewModel.hobbiesList = selectedHobbies.obs;
                            setState(() {
                              print(selectedHobbies.length);
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextClass(
                                  size: 18,
                                  fontWeight: FontWeight.w500,
                                  title: 'Select Interest',
                                  fontColor: primaryDark),
                              Icon(
                                Icons.edit,
                                color: primaryDark,
                              )
                            ],
                          )),
                      SizedBox(
                        height: height * .02,
                      ),

                      // selectedHobbies.length == 0
                      //     ?
                      GridView.builder(
                          physics:
                              NeverScrollableScrollPhysics(), // Disable scrolling
                          shrinkWrap: true,
                          itemCount: interestGetValue.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  mainAxisExtent: 50,
                                  crossAxisCount: 3),
                          itemBuilder: (context, index) => Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: primaryDark)),
                                child: Center(
                                  child: TextClass(
                                      fontWeight: FontWeight.w700,
                                      size: 13,
                                      fontColor: primaryDark,
                                      title: interestGetValue[index]),
                                ),
                              ))
                      // : GridView.builder(
                      //     physics:
                      //         NeverScrollableScrollPhysics(), // Disable scrolling
                      //     shrinkWrap: true,
                      //     itemCount: selectedHobbies.length,
                      //     gridDelegate:
                      //         SliverGridDelegateWithFixedCrossAxisCount(
                      //             crossAxisSpacing: 5,
                      //             mainAxisSpacing: 5,
                      //             mainAxisExtent: 50,
                      //             crossAxisCount: 3),
                      //     itemBuilder: (context, index) => Container(
                      //           decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(15),
                      //               border: Border.all(color: primaryDark)),
                      //           child: Center(
                      //             child: TextClass(
                      //                 fontWeight: FontWeight.w700,
                      //                 size: 13,
                      //                 fontColor: primaryDark,
                      //                 title: selectedHobbies[index]),
                      //           ),
                      //         )),
                      ,
                      SizedBox(height: height * .03),

                      // Education
                      InkWell(
                          onTap: () async {
                            selectedEducation =
                                await Get.to(() => EducationSelection(
                                      fromEditScreen: true,
                                    ));
                            educationGetValue = selectedEducation;
                            aboutYouViewModel.educationList =
                                selectedEducation.obs;
                            setState(() {
                              print(selectedEducation.length);
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextClass(
                                  size: 18,
                                  fontWeight: FontWeight.w500,
                                  title: 'Select Education',
                                  fontColor: primaryDark),
                              Icon(
                                Icons.edit,
                                color: primaryDark,
                              )
                            ],
                          )),
                      SizedBox(
                        height: height * .02,
                      ),

                      // selectedEducation.length == 0
                      //     ?
                      GridView.builder(
                          physics:
                              NeverScrollableScrollPhysics(), // Disable scrolling
                          shrinkWrap: true,
                          itemCount: educationGetValue.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  mainAxisExtent: 50,
                                  crossAxisCount: 2),
                          itemBuilder: (context, index) => Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: primaryDark)),
                                child: Center(
                                  child: TextClass(
                                      align: TextAlign.center,
                                      fontWeight: FontWeight.w700,
                                      size: 13,
                                      fontColor: primaryDark,
                                      title: educationGetValue[index]),
                                ),
                              ))
                      // : GridView.builder(
                      //     physics:
                      //         NeverScrollableScrollPhysics(), // Disable scrolling
                      //     shrinkWrap: true,
                      //     itemCount: educationGetValue.length,
                      //     gridDelegate:
                      //         SliverGridDelegateWithFixedCrossAxisCount(
                      //             crossAxisSpacing: 5,
                      //             mainAxisSpacing: 5,
                      //             mainAxisExtent: 50,
                      //             crossAxisCount: 2),
                      //     itemBuilder: (context, index) => Container(
                      //           decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(15),
                      //               border: Border.all(color: primaryDark)),
                      //           child: Center(
                      //             child: TextClass(
                      //                 align: TextAlign.center,
                      //                 fontWeight: FontWeight.w700,
                      //                 size: 13,
                      //                 fontColor: primaryDark,
                      //                 title: educationGetValue[index]),
                      //           ),
                      //         )),
                      ,
                      SizedBox(height: height * .03),
                      // Proffession

                      InkWell(
                          onTap: () async {
                            selectedProfession =
                                await Get.to(() => ProfessionSelection(
                                      fromEditScreen: true,
                                    ));
                            professionGetValue = selectedProfession;

                            setState(() {
                              print(professionGetValue);
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextClass(
                                  size: 18,
                                  fontWeight: FontWeight.w500,
                                  title: 'Select Profession',
                                  fontColor: primaryDark),
                              Icon(
                                Icons.edit,
                                color: primaryDark,
                              )
                            ],
                          )),
                      SizedBox(
                        height: height * .02,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height * .01,
                          ),
                          TextClass(
                              title: professionGetValue.toString(),
                              fontColor: Colors.black,
                              fontWeight: FontWeight.w700,
                              size: 14),
                          Divider(
                            color: Color(0xffCDD1D0),
                            thickness: 1,
                          )
                        ],
                      ),

                      SizedBox(
                        height: height * .02,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextClass(
                            size: 16,
                            fontWeight: FontWeight.w700,
                            title: 'Gallery',
                            fontColor: Colors.black),
                      ),
                      SizedBox(
                        height: height * .01,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Stack(children: [
                      //         Image(
                      //           image: NetworkImage(galleryGetValue[0]),
                      //           width: width * .4,
                      //           height: height * .3,
                      //           fit: BoxFit.cover,
                      //           loadingBuilder: (BuildContext context,
                      //               Widget child,
                      //               ImageChunkEvent? loadingProgress) {
                      //             if (loadingProgress == null) {
                      //               // Image loaded successfully
                      //               return child;
                      //             } else if (loadingProgress
                      //                     .cumulativeBytesLoaded ==
                      //                 loadingProgress.expectedTotalBytes) {
                      //               // Image fully loaded, but there was an error before displaying it
                      //               return Center(
                      //                 child: Text("Error loading image"),
                      //               );
                      //             } else {
                      //               // Image is still loading, show a loading indicator
                      //               return CircularProgressIndicator(
                      //                 color: primaryDark,
                      //               );
                      //             }
                      //           },
                      //           errorBuilder: (BuildContext context,
                      //               Object error, StackTrace? stackTrace) {
                      //             // Handle the error gracefully
                      //             return Center(
                      //               child: Text("Error loading image"),
                      //             );
                      //           },
                      //         ),
                      //         IconButton(
                      //           onPressed: () {},
                      //           icon: Icon(Icons.cancel),
                      //           color: Colors.red,
                      //         )
                      //       ]),
                      //       Stack(children: [
                      //         Image(
                      //           image: NetworkImage(galleryGetValue[0]),
                      //           width: width * .4,
                      //           height: height * .3,
                      //           fit: BoxFit.cover,
                      //           loadingBuilder: (BuildContext context,
                      //               Widget child,
                      //               ImageChunkEvent? loadingProgress) {
                      //             if (loadingProgress == null) {
                      //               // Image loaded successfully
                      //               return child;
                      //             } else if (loadingProgress
                      //                     .cumulativeBytesLoaded ==
                      //                 loadingProgress.expectedTotalBytes) {
                      //               // Image fully loaded, but there was an error before displaying it
                      //               return Center(
                      //                 child: Text("Error loading image"),
                      //               );
                      //             } else {
                      //               // Image is still loading, show a loading indicator
                      //               return CircularProgressIndicator(
                      //                 color: primaryDark,
                      //               );
                      //             }
                      //           },
                      //           errorBuilder: (BuildContext context,
                      //               Object error, StackTrace? stackTrace) {
                      //             // Handle the error gracefully
                      //             return Center(
                      //               child: Text("Error loading image"),
                      //             );
                      //           },
                      //         ),
                      //         IconButton(
                      //           onPressed: () {},
                      //           icon: Icon(Icons.cancel),
                      //           color: Colors.red,
                      //         )
                      //       ])
                      //     ],
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: GridView.builder(
                          addSemanticIndexes: true,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                              //  galleryPhotosUrl.length - 2
                              galleryGetValue.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisExtent: 200,
                                  mainAxisSpacing: 5,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5),
                          itemBuilder: (context, index) {
                            final item = galleryGetValue[index];
                           
                            return
                                //  Image.asset(
                                //   galleryPhotosUrl[index + 2],
                                //   fit: BoxFit.cover,
                                // );

                                Stack(children: [
                              item is File
                                  ? Image.file(
                                      galleryGetValue[index],
                                      fit: BoxFit.cover,
                                      height: height * .25,
                                      width: width * .8,
                                    )
                                  : CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: galleryGetValue[index],
                                      progressIndicatorBuilder:
                                          (context, url, progress) => Center(
                                              child: CircularProgressIndicator(
                                        color: primaryDark,
                                      )),
                                    ),
                              IconButton(
                             
                                onPressed: () {
                                  if (galleryGetValue.length > 2) {
                                    // print("enter here");
                                   
                                    // if (selectedGalleryPhotos.isNotEmpty) {
                                    // print('now here');
                                    //   selectedGalleryPhotos.removeAt(
                                    //       index - originalGalleryImagesLength!);
                                    // }
                                    // print('end here');
                                    galleryGetValue.removeAt(index);

                                    photoDelete_view_model.photoId?.value =
                                        index.toString();
                                    photoDelete_view_model.photodeleteApi();
                                    print('printing the index $index');
                                    setState(() {});
                                  } else {
                                    Utils.toastMessageCenter(
                                        'Minimum photo requirement is two',
                                        true);
                                  }
                                },
                                icon: Icon(Icons.cancel),
                                color: Colors.red,
                              )
                            ]);
                          },
                        ),
                      ),
                      SizedBox(
                        height: height * .01,
                      ),
                      SizedBox(
                        height: height * .01,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextClass(
                                size: 16,
                                fontWeight: FontWeight.w700,
                                title: 'Video',
                                fontColor: Colors.black),
                            InkWell(
                              onTap: () {
                                videoGetUrl = null;
                                noVideo = true;
                                videoDelete_view_model.videodeleteApi();
                                setState(() {});
                              },
                              child: TextClass(
                                  size: 14,
                                  fontWeight: FontWeight.w400,
                                  title: 'Delete Video',
                                  fontColor: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      noVideo == true
                          ? newVideoUploaded == false
                              ? Center(
                                  child: TextClass(
                                      size: 14,
                                      fontWeight: FontWeight.w700,
                                      title: "You haven't uploaded video! ",
                                      fontColor: primaryDark),
                                )
                              : Center(child: Text('Video Uploaded (Click on Save Changes)'))
                          : Container(
                                        margin: EdgeInsets.all(10),
                                        width: width,
                                        height: height * .25,
                                        child: IconButton(
                                            onPressed: () {
                                              print(videoGetUrl);
                                              Get.to(() => VideoPlayerClass(
                                                    videoUrl: videoGetUrl!,
                                                  ));
                                            },
                                            icon: Icon(
                                              Icons.play_arrow_rounded,
                                              color: primaryDark,
                                              size: 100,
                                            )),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: primaryDark
                                                    .withOpacity(.3)),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                opacity: .4,
                                                image: AssetImage(
                                                    'assets/images/demoVideoPhoto.jpg')),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                      ),

                      SizedBox(
                        height: height * .04,
                      ),
                      galleryGetValue.length < 11
                          ? Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      selectedGalleryPhotos = await Get.to(
                                          () => UploadPhotoAboutScreen(
                                                fromEditScreen: true,
                                              ));
                                      galleryGetValue
                                          .addAll(selectedGalleryPhotos);
                                      print(
                                          "length -> ${selectedGalleryPhotos.length}");
                                      print(
                                          "Lenght after click -> ${galleryGetValue.length}");
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: height * .04,
                                      width: width * .42,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.photo,
                                            color: Colors.white,
                                            size: 17,
                                          ),
                                          TextClass(
                                              size: 14,
                                              fontWeight: FontWeight.w500,
                                              title: '  Upload Photo',
                                              fontColor: Colors.white)
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          color: primaryDark,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                  ),
                                  videoGetUrl == null
                                      ? InkWell(
                                          onTap: () async {
                                            newVideoUploaded = await Get.to(
                                                () => VideoPickerAndPlayer(
                                                      fromEdit: true,
                                                    ));
                                            setState(() {});
                                          },
                                          child: Container(
                                            height: height * .04,
                                            width: width * .42,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.white,
                                                  size: 17,
                                                ),
                                                TextClass(
                                                    size: 14,
                                                    fontWeight: FontWeight.w500,
                                                    title: '  Upload Video',
                                                    fontColor: Colors.white)
                                              ],
                                            ),
                                            // ),
                                            decoration: BoxDecoration(
                                                color: primaryDark,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                          ),
                                        )
                                      : SizedBox()
                                ],
                              ),
                            )
                          : SizedBox()
                    ],
                  ),
                )),
              );
          }
        })
        // }
        );
  }

//  Dialog box of choosing from gallery and camera image pic
  void ShowDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primaryDark,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          alignment: Alignment.center,
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      _pickImage(ImageSource.gallery);
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.image,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        TextClass(
                            size: 14,
                            fontWeight: FontWeight.w600,
                            title: 'Choose from Gallery',
                            fontColor: Colors.white)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      _pickImage(ImageSource.camera);
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        TextClass(
                            size: 14,
                            fontWeight: FontWeight.w600,
                            title: 'Click a Photo',
                            fontColor: Colors.white)
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
   void searchAutocomplete(String query) async {
    print("calling");
    Uri uri = Uri.https(
        "maps.googleapis.com",
        "maps/api/place/autocomplete/json",
        {"input": query, "key": googleAPiKey});
    print(uri);
    try {
      final response = await http.get(uri);
      print(response.statusCode);
      final parse = jsonDecode(response.body);
      print(parse);
      if (parse['status'] == "OK") {
        setState(() {
          SearchPlaceModel searchPlaceModel = SearchPlaceModel.fromJson(parse);

          searchPlace = searchPlaceModel.predictions!;

          print(searchPlace.length);
        });
      }
    } catch (err) {}
  }
}


class SearchPlaceModel {
  List<Predictions>? predictions;
  String? status;

  SearchPlaceModel({this.predictions, this.status});

  SearchPlaceModel.fromJson(Map<String, dynamic> json) {
    if (json['predictions'] != null) {
      predictions = <Predictions>[];
      json['predictions'].forEach((v) {
        predictions!.add(Predictions.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (predictions != null) {
      data['predictions'] = predictions!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class Predictions {
  String? description;

  Predictions({this.description});

  Predictions.fromJson(Map<String, dynamic> json) {
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['description'] = description;

    return data;
  }
}
//  Padding(
//                   padding: const EdgeInsets.only(left: 5, right: 5),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Get.to(() => UploadPhotoAboutScreen());
//                         },
//                         child: Container(
//                           height: height * .04,
//                           width: widht * .42,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.photo,
//                                 color: Colors.white,
//                                 size: 17,
//                               ),
//                               TextClass(
//                                   size: 14,
//                                   fontWeight: FontWeight.w500,
//                                   title: '  Upload Photo',
//                                   fontColor: Colors.white)
//                             ],
//                           ),
//                           decoration: BoxDecoration(
//                               color: primaryDark,
//                               borderRadius: BorderRadius.circular(15)),
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           Get.to(() => VideoPickerAndPlayer());
//                         },
//                         child: Container(
//                           height: height * .04,
//                           width: widht * .42,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.camera_alt,
//                                 color: Colors.white,
//                                 size: 17,
//                               ),
//                               TextClass(
//                                   size: 14,
//                                   fontWeight: FontWeight.w500,
//                                   title: '  Upload Video',
//                                   fontColor: Colors.white)
//                             ],
//                           ),
//                           // ),
//                           decoration: BoxDecoration(
//                               color: primaryDark,
//                               borderRadius: BorderRadius.circular(15)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

class SliderThumbShape extends SliderComponentShape {
  /// Create a slider thumb that draws a circle.

  const SliderThumbShape({
    this.enabledThumbRadius = 10.0,
    required this.disabledThumbRadius,
    this.elevation = 1.0,
    this.pressedElevation = 6.0,
  });

  /// The preferred radius of the round thumb shape when the slider is enabled.
  ///
  /// If it is not provided, then the material default of 10 is used.
  final double enabledThumbRadius;

  /// The preferred radius of the round thumb shape when the slider is disabled.
  ///
  /// If no disabledRadius is provided, then it is equal to the
  /// [enabledThumbRadius]
  final double disabledThumbRadius;
  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  /// The resting elevation adds shadow to the unpressed thumb.
  ///
  /// The default is 1.
  ///
  /// Use 0 for no shadow. The higher the value, the larger the shadow. For
  /// example, a value of 12 will create a very large shadow.
  ///
  final double elevation;

  /// The pressed elevation adds shadow to the pressed thumb.
  ///
  /// The default is 6.
  ///
  /// Use 0 for no shadow. The higher the value, the larger the shadow. For
  /// example, a value of 12 will create a very large shadow.
  final double pressedElevation;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
        isEnabled == true ? enabledThumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    assert(context != null);
    assert(center != null);
    assert(enableAnimation != null);
    assert(sliderTheme != null);
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);
    assert(!sizeWithOverflow.isEmpty);

    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );

    final double radius = radiusTween.evaluate(enableAnimation);

    final Tween<double> elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    final double evaluatedElevation =
        elevationTween.evaluate(activationAnimation);

    {
      final Path path = Path()
        ..addArc(
            Rect.fromCenter(
                center: center, width: 1 * radius, height: 1 * radius),
            0,
            math.pi * 2);

      Paint paint = Paint()..color = Colors.white;
      paint.strokeWidth = 18;

      paint.style = PaintingStyle.stroke;
      canvas.drawCircle(
        center,
        radius,
        paint,
      );

      {
        Paint paint = Paint()..color = primaryDark;
        paint.strokeWidth = 8;
        paint.style = PaintingStyle.stroke;
        canvas.drawCircle(
          center,
          radius,
          paint,
        );
      }
      {
        Paint paint = Paint()..color = primaryDark;
        paint.strokeWidth = 5;
        paint.style = PaintingStyle.fill;
        canvas.drawCircle(
          center,
          radius,
          paint,
        );
      }
    }
  }
}
