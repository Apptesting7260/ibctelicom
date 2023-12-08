import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
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
import 'package:nauman/data/response/status.dart';
import 'package:nauman/utils/utils.dart';
import 'package:nauman/view/My%20Profile/myProfile_edit.dart';
import 'package:nauman/view/Other%20Profile/otherProfile.dart';
import 'package:nauman/view_models/controller/aboutYou/aboutYou_view_model.dart';
import 'package:nauman/view_models/controller/color/color_view_model.dart';
import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';

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

class AboutYouClass extends StatefulWidget {
  @override
  State<AboutYouClass> createState() => AboutYouClassState();
}

class AboutYouClassState extends State<AboutYouClass> {
  String googleAPiKey = "AIzaSyD2fbGTF3K3fsFDwPqrptht7hNipho1VsY";
  String? SelectedLocation;
  String? Sikeraddress;

  // final locationcntroller = TextEditingController();
  List<Predictions> searchPlace = [];
  final colorVM = Get.put(ColorViewModel());
  UserPreference userPreference = UserPreference();
  final aboutYouViewModel = Get.put(AboutYouViewModel());

  List<String> selectedHobbies = [];
  List<String> selectedEducation = [];
  RxString selectedProfession = ''.obs;
  @override
  void initState() {
    colorVM.ColorApi();
    // TODO: implement initState
    super.initState();
  }

  double initialAgeValue = 5;
  double initialHeightValue = 5;

  var _formKey = GlobalKey<FormState>();
  final List<String> items = [
    'Male',
    'Female',
    'Other',
  ];

  String? selectedGenderValue;
  String? selectColorValue;

  String? _validateAbout(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter about you.';
    }
    return null;
  }

  String? _validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your location.';
    }
    return null;
  }

  bool isLoginButtonEnabled = false;
  void checkLoginButtonStatus() {
    setState(() {
      isLoginButtonEnabled =
          aboutYouViewModel.aboutYouController.value.text.isNotEmpty &&
              aboutYouViewModel.locationController.value.text.isNotEmpty &&
              interestValidation.value &&
              educationValidation.value &&
              professionValidation.value &&
              postValidation.value &&
              profileValidation.value &&
              aboutYouViewModel.gender.value.isNotEmpty &&
              aboutYouViewModel.color.value.isNotEmpty;

      if (isLoginButtonEnabled == true) {
        hitApi.value = true;
      }
    });
  }

  File? _image;
  RxBool hitApi = false.obs;
  RxBool profileValidation = false.obs;
  RxBool postValidation = false.obs;
  RxBool interestValidation = false.obs;
  RxBool educationValidation = false.obs;
  RxBool professionValidation = false.obs;
  RxInt postLength = 0.obs;

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
        aboutYouViewModel.singleImagetakingpath = _image!.path;
        profileValidation.value = true;
        checkLoginButtonStatus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final widht = Get.width;
    final height = Get.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        bottomSheet: Padding(
          padding: EdgeInsets.all(20),
          child: Obx(
            () => Button(
                loading: aboutYouViewModel.loading.value,
                bgcolor: isLoginButtonEnabled ? primaryDark : F3F6F6,
                onTap: () {
                  if (aboutYouViewModel.height == null) {
                    aboutYouViewModel.height = '60'.obs;
                  }
                  if (aboutYouViewModel.age == null) {
                    aboutYouViewModel.age = '25'.obs;
                  }
                  print(aboutYouViewModel.hobbiesList);
                  print(aboutYouViewModel.locationController.value.text);
                  if (_formKey.currentState!.validate() &&
                      hitApi.value == true) {
                    aboutYouViewModel.aboutYouApi();
                 
                  } else {
                    if (aboutYouViewModel.singleImagetakingpath == null) {
                      Utils.toastMessageCenter(
                          'Please select profile photo!', true);
                    } else if (aboutYouViewModel.imageList.isEmpty) {
                      Utils.toastMessageCenter(
                          'Please upload mimimum 2 posts!', true);
                    } else if (selectedHobbies.isEmpty) {
                      Utils.toastMessageCenter(
                          "Please select your interest", true);
                    } else if (selectedEducation.isEmpty) {
                      Utils.toastMessageCenter(
                          "Please select your education!", true);
                    } else if (selectedProfession.isEmpty) {
                      Utils.toastMessageCenter(
                          "Please choose your profession!", true);
                    }
                  }
                },
                textColor: isLoginButtonEnabled ? Colors.white : primaryGrey,
                title: 'Next'),
          ),
        ),
        body: Obx(
          () => Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Pic
                  Center(
                    child: Stack(alignment: Alignment.bottomRight, children: [
                      _image == null
                          ? CircleAvatar(
                              radius: 65,
                              backgroundImage: AssetImage(
                                  'assets/images/aboutYouAvtarImg.png'),
                            )
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
                  SizedBox(
                    height: height * .03,
                  ),
                  // Upload Photo Video Row
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            postLength =
                                await Get.to(() => UploadPhotoAboutScreen(
                                      fromEditScreen: false,
                                    ));
                            setState(() {
                              if (postLength > 1) {
                                postValidation.value = true;
                              }
                              checkLoginButtonStatus();
                            });
                          },
                          child: Container(
                            height: height * .04,
                            width: widht * .42,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => VideoPickerAndPlayer(
                                  fromEdit: false,
                                ));
                          },
                          child: Container(
                            height: height * .04,
                            width: widht * .42,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * .05),
                  // About You, Discover Your, Row
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextClass(
                          size: 17,
                          fontWeight: FontWeight.w700,
                          title: 'About You',
                          fontColor: primaryDark),
                      TextFieldClass(
                        onChanged: (value) {
                          setState(() {
                            checkLoginButtonStatus();
                          });
                        },
                        controller: aboutYouViewModel.aboutYouController.value,
                        hint: '',
                        isObs: false,
                        validator: _validateAbout,
                      )
                    ],
                  ),

                  SizedBox(height: height * .04),

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
                      'Select Gender',
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
                    value: selectedGenderValue,
                    onChanged: (String? value) {
                      setState(() {
                        selectedGenderValue = value;
                        aboutYouViewModel.gender = value!.obs;
                        print(selectedGenderValue);
                        checkLoginButtonStatus();
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
                            title: initialAgeValue.toInt().toString(),
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
                        thumbShape: SliderThumbShape(disabledThumbRadius: 20),
                        trackShape: CustomTrackShape(),
                        thumbColor: Colors.white,
                        activeTrackColor: primaryDark,
                      ),
                      child: Slider(
                          value: initialAgeValue,
                          // value: aboutYouViewModel.age,
                          max: 100,
                          divisions: 100,
                          inactiveColor: Colors.grey.shade200,
                          onChanged: (double value) {
                            setState(() {
                              initialAgeValue = value;

                              aboutYouViewModel.age = value.toString().obs;
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
                        return Center(
                          child: CircularProgressIndicator(
                            color: primaryDark,
                          ),
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            'Select your Skin Tone',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          items: colorVM.colorList.value.profileColour == null
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
                          value: selectColorValue,
                          onChanged: (String? value) {
                            setState(() {
                              selectColorValue = value;
                              aboutYouViewModel.color = value!.obs;
                              checkLoginButtonStatus();
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
                              "${initialHeightValue ~/ 12} ft ${(initialHeightValue % 12).toInt()} ",
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
                        value: initialHeightValue,
                        max: 120,
                        min: 0,
                        divisions: 120,
                        inactiveColor: Colors.grey.shade200,
                        onChanged: (double value) {
                          setState(() {
                            initialHeightValue = value;
                            aboutYouViewModel.height = value.toString().obs;
                          });
                        }),
                  ),

                  // Location

                  TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: aboutYouViewModel.locationController.value,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _validateLocation,
                      // onChanged: (value) {
                      //   setState(() {
                      //     checkLoginButtonStatus();
                      //   });
                      // },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          if (aboutYouViewModel
                              .locationController.value.text.isEmpty) {
                            Sikeraddress = value;
                            searchPlace.clear();
                          }
                          checkLoginButtonStatus();
                        });
                        searchAutocomplete(value);
                      },
                      maxLines: 4,
                      minLines: 1,
                      decoration: InputDecoration(
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: primaryDark),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: CDD1D0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: CDD1D0),
                          ),
                          enabled: true,
                          labelStyle: TextStyle(
                              fontSize: 14,
                              color: primaryDark,
                              fontWeight: FontWeight.w500),
                          labelText: 'Location')),
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
                                    aboutYouViewModel
                                            .locationController.value.text =
                                        searchPlace[index].description ?? "";

                                    SelectedLocation = aboutYouViewModel
                                        .locationController.value.text;
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

                  //  Hobbies
                  InkWell(
                      onTap: () async {
                        selectedHobbies = await Get.to(() => HobbiesSelection(
                              fromFilter: false,
                              fromEditScreen: false,
                            ));
                        aboutYouViewModel.hobbiesList = selectedHobbies.obs;
                        setState(() {
                          if (selectedHobbies.isNotEmpty) {
                            interestValidation.value = true;
                          }
                          checkLoginButtonStatus();
                          print(selectedHobbies.length);
                        });
                      },
                      child: TextClass(
                          size: 18,
                          fontWeight: FontWeight.w500,
                          title: 'Select Interest',
                          fontColor: primaryDark)),

                  selectedHobbies.length == 0
                      ? Divider(
                          color: Color(0xffCDD1D0),
                          thickness: 1,
                        )
                      : SizedBox(
                          height: height * .02,
                        ),
                  GridView.builder(
                      physics:
                          NeverScrollableScrollPhysics(), // Disable scrolling
                      shrinkWrap: true,
                      itemCount: selectedHobbies.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                  title: selectedHobbies[index]),
                            ),
                          )),

                  SizedBox(height: height * .03),

                  // Education
                  InkWell(
                      onTap: () async {
                        selectedEducation =
                            await Get.to(() => EducationSelection(
                                  fromEditScreen: false,
                                ));

                        aboutYouViewModel.educationList = selectedEducation.obs;
                        setState(() {
                          if (selectedEducation.isNotEmpty) {
                            educationValidation.value = true;
                          }
                          checkLoginButtonStatus();
                        });
                      },
                      child: TextClass(
                          size: 18,
                          fontWeight: FontWeight.w500,
                          title: 'Select Education',
                          fontColor: primaryDark)),
                  selectedEducation.length == 0
                      ? Divider(
                          color: Color(0xffCDD1D0),
                          thickness: 1,
                        )
                      : SizedBox(
                          height: height * .02,
                        ),
                  GridView.builder(
                      physics:
                          NeverScrollableScrollPhysics(), // Disable scrolling
                      shrinkWrap: true,
                      itemCount: selectedEducation.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                  fontWeight: FontWeight.w700,
                                  size: 13,
                                  align: TextAlign.center,
                                  fontColor: primaryDark,
                                  title: selectedEducation[index]),
                            ),
                          )),

                  SizedBox(height: height * .03),
                  // Proffession
                  InkWell(
                      onTap: () async {
                        selectedProfession =
                            await Get.to(() => ProfessionSelection(
                                  fromEditScreen: false,
                                ));

                        aboutYouViewModel.profession = selectedProfession;
                        setState(() {
                          if (selectedProfession.isNotEmpty) {
                            professionValidation.value = true;
                          }
                          checkLoginButtonStatus();
                        });
                      },
                      child: TextClass(
                          size: 18,
                          fontWeight: FontWeight.w500,
                          title: 'Select Profession',
                          fontColor: primaryDark)),
                  selectedProfession == ''
                      ? Divider(
                          color: Color(0xffCDD1D0),
                          thickness: 1,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height * .01,
                            ),
                            TextClass(
                                title: selectedProfession.value.toString(),
                                fontColor: Colors.black,
                                fontWeight: FontWeight.w700,
                                size: 14),
                            Divider(
                              color: Color(0xffCDD1D0),
                              thickness: 1,
                            )
                          ],
                        ),

                  const SizedBox(height: 30),
                ],
              ),
            )),
          ),
        )
        // }
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
