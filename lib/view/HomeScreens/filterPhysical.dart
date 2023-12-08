import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/components/general_exception.dart';
import 'package:nauman/UI%20Components/components/internet_exceptions_widget.dart';
import 'package:nauman/UI%20Components/eucationSelection.dart';
import 'package:nauman/UI%20Components/hobbiesSelection.dart';

import 'package:nauman/UI%20Components/sliderCustomTrackShape.dart';
import 'package:nauman/UI%20Components/textDesign.dart';

import 'package:nauman/data/response/status.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/view/Authentication%20Screens/aboutYouScreen.dart';
import 'package:nauman/view/Bottom%20Navigation%20Bar/bottomNavigationBar.dart';

import 'package:nauman/view_models/controller/color/color_view_model.dart';
import 'package:nauman/view_models/controller/favouriteList/favouriteList_controller.dart';
import 'package:nauman/view_models/controller/homeScreen/homeScreen_view_model.dart';
import 'package:nauman/view_models/controller/profession/profession_controller.dart';
import 'package:http/http.dart' as http;
import 'package:nauman/view_models/controller/request_list/request_list_controller.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';
import 'package:toggle_switch/toggle_switch.dart';

class PhysicalTraits extends StatefulWidget {
  HomeViewModel homeVm;
  PhysicalTraits({required this.homeVm});
  @override
  State<PhysicalTraits> createState() => PhysicalTraitsState();
}

class PhysicalTraitsState extends State<PhysicalTraits> {
  var homeScreen_viewModel = Get.put(HomeViewModel());
  var requestList = Get.put(RequestListViewModel());
  var userProfileView = Get.put(UserProfileView_ViewModel());
  var favouriteList = Get.put(FavouriteListViewModal());
  final colorVM = Get.put(ColorViewModel());
  final professionVM = Get.put(ProfessionViewModel());
  final String googleAPiKey = "AIzaSyD2fbGTF3K3fsFDwPqrptht7hNipho1VsY";
  String? SelectedLocation;
  String? Sikeraddress;

  // final locationcntroller = TextEditingController();
  List<Predictions> searchPlace = [];
  // List<dynamic> locations = [];
  @override
  void initState() {
    colorVM.ColorApi();
    professionVM.ProfessionApi();
    // TODO: implement initState
    super.initState();
  }

  final height = Get.height;
  final width = Get.width;
  bool isPressed = true;
  Color girlsBackgroundColor = Colors.white;
  Color boysBackgroundColor = primaryDark;
  Color bothBackgroundColor = Colors.white;
  Color girlsTextColor = Colors.black;
  Color boysTextColor = Colors.white;
  Color bothTextColor = Colors.black;

  FontWeight girlsFontWeight = FontWeight.w400;
  FontWeight boysFontWeight = FontWeight.w600;
  FontWeight bothFontWeight = FontWeight.w400;
  String? selectedLocation;
  List<String> selectedHobbies = [];
  List<String> selectedEducation = [];
  List<String> Gender = ['Male', 'Female', 'Both'];
  String? selectedProffesion;
  String? selectedColor;
  double initialDistanceValue = 8000;

  RangeValues currentHeightValues = RangeValues(30, 100);
  RangeValues currentAgeValues = RangeValues(18, 80);
  var ownGender = Get.put(UserProfileView_ViewModel());

  String defaultGender = '';
  int initialGenderIndex = 0;
  @override
  Widget build(BuildContext context) {
    if (widget.homeVm.age_from.isNotEmpty && widget.homeVm.age_to.isNotEmpty) {
      currentAgeValues = RangeValues(
          double.parse(widget.homeVm.age_from.toString()),
          double.parse(widget.homeVm.age_to.toString()));
    }
    if (widget.homeVm.height_from.isNotEmpty &&
        widget.homeVm.height_to.isNotEmpty) {
      currentHeightValues = RangeValues(
          double.parse(widget.homeVm.height_from.toString()),
          double.parse(widget.homeVm.height_to.toString()));
    }

    if (widget.homeVm.distance.isNotEmpty) {
      initialDistanceValue = double.parse(widget.homeVm.distance.value);
    }
    if (widget.homeVm.gender.isEmpty) {
      String gender =
          ownGender.UserDataList.value.userData!.userDetails!.gender!;
      if (gender == 'Male') {
        defaultGender = 'Female';
      } else if (gender == 'Female') {
        defaultGender = 'Male';
      } else {
        defaultGender =
            ownGender.UserDataList.value.userData!.userDetails!.gender!;
      }
    } else {
      defaultGender = widget.homeVm.gender.value;
    }
    if (defaultGender == 'Male') {
      initialGenderIndex = 0;
    } else if (defaultGender == 'Female') {
      initialGenderIndex = 1;
    } else {
      initialGenderIndex = 2;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: width, height: height * .03),

                //  Second row for Intrested in ,  Clear
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextClass(
                        size: 16,
                        fontWeight: FontWeight.w700,
                        title: 'Interested in',
                        fontColor: Colors.black),
                    InkWell(
                      onTap: () {
                        fromFilterScr.value = false;
                        optionList.clear();

                        HomeDataList.clear();
                        homeScreen_viewModel.page_no.value = '1';
                        page.value = 1;
                           noDataHome.value = false;
                        callHomePagination.value = true;

                        homeScreen_viewModel.HomeApi(false);

                        homeScreen_viewModel.locationController =
                            TextEditingController().obs;
                        homeScreen_viewModel.distance = ''.obs;
                        homeScreen_viewModel.gender = ''.obs;
                        homeScreen_viewModel.age_from = ''.obs;
                        homeScreen_viewModel.age_to = ''.obs;
                        homeScreen_viewModel.profession = ''.obs;
                        homeScreen_viewModel.height_from = ''.obs;
                        homeScreen_viewModel.height_to = ''.obs;
                        homeScreen_viewModel.colour = ''.obs;
                        homeScreen_viewModel.education = <String>[].obs;
                        homeScreen_viewModel.hobbies = <String>[].obs;
                        homeScreen_viewModel.rating = ''.obs;
                        homeScreen_viewModel.per_page = '10'.obs;
                        homeScreen_viewModel.page_no = '1'.obs;
                        homeScreen_viewModel.personality_traits =
                            <String>[].obs;
                        Get.back();
                      },
                      child: TextClass(
                          size: 15,
                          fontWeight: FontWeight.w700,
                          title: 'Clear',
                          fontColor: primaryGrey),
                    )
                  ],
                ),
                SizedBox(width: width, height: height * .03),
                // Container for girls, boys
                // Container(
                //   width: width,
                //   height: height * .075,
                //   decoration: BoxDecoration(
                //       border: Border.fromBorderSide(
                //           BorderSide(color: containerBorderColor)),
                //       borderRadius: BorderRadius.circular(15)),
                //   child: Padding(
                //     padding: const EdgeInsets.all(.3),
                //     child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         children: [
                //           // Girls Container
                //           Expanded(
                //             flex: 3,
                //             child: InkWell(
                //               onTap: () {
                //                 setState(() {
                //                   girlsBackgroundColor = primaryDark;
                //                   girlsTextColor = Colors.white;
                //                   girlsFontWeight = FontWeight.w600;
                //                   boysBackgroundColor = Colors.white;
                //                   boysTextColor = Colors.black;
                //                   boysFontWeight = FontWeight.w400;
                //                   bothBackgroundColor = Colors.white;
                //                   bothTextColor = Colors.black;
                //                   bothFontWeight = FontWeight.w400;

                //                   widget.homeVm.gender = 'Female'.obs;
                //                 });
                //               },
                //               child: Container(
                //                 decoration: BoxDecoration(
                //                     color: girlsBackgroundColor,
                //                     borderRadius: const BorderRadius.only(
                //                         bottomLeft: Radius.circular(15),
                //                         topLeft: Radius.circular(15))),
                //                 child: Center(
                //                   child: TextClass(
                //                       size: 14,
                //                       fontWeight: girlsFontWeight,
                //                       title: 'Girls',
                //                       fontColor: girlsTextColor),
                //                 ),
                //               ),
                //             ),
                //           ),
                //           //  Boys Container
                //           Expanded(
                //             flex: 3,
                //             child: InkWell(
                //               onTap: () {
                //                 setState(() {
                //                   girlsBackgroundColor = Colors.white;
                //                   girlsTextColor = Colors.black;
                //                   girlsFontWeight = FontWeight.w400;
                //                   boysBackgroundColor = primaryDark;
                //                   boysTextColor = Colors.white;
                //                   boysFontWeight = FontWeight.w600;
                //                   bothBackgroundColor = Colors.white;
                //                   bothTextColor = Colors.black;
                //                   bothFontWeight = FontWeight.w400;

                //                   widget.homeVm.gender = 'Male'.obs;
                //                 });
                //               },
                //               child: Container(
                //                 color: boysBackgroundColor,
                //                 child: Center(
                //                   child: TextClass(
                //                       size: 14,
                //                       fontWeight: boysFontWeight,
                //                       title: 'Boys',
                //                       fontColor: boysTextColor),
                //                 ),
                //               ),
                //             ),
                //           ),
                //           //  Both Container
                //           Expanded(
                //             flex: 3,
                //             child: InkWell(
                //               onTap: () {
                //                 setState(() {
                //                   girlsBackgroundColor = Colors.white;
                //                   girlsTextColor = Colors.black;
                //                   girlsFontWeight = FontWeight.w400;
                //                   boysBackgroundColor = Colors.white;
                //                   boysTextColor = Colors.black;
                //                   boysFontWeight = FontWeight.w400;
                //                   bothBackgroundColor = primaryDark;
                //                   bothTextColor = Colors.white;
                //                   bothFontWeight = FontWeight.w600;
                //                   widget.homeVm.gender = 'Both'.obs;
                //                 });
                //               },
                //               child: Container(
                //                 child: Center(
                //                   child: TextClass(
                //                       size: 14,
                //                       fontWeight: bothFontWeight,
                //                       title: 'Both',
                //                       fontColor: bothTextColor),
                //                 ),
                //                 decoration: BoxDecoration(
                //                     color: bothBackgroundColor,
                //                     borderRadius: const BorderRadius.only(
                //                         bottomRight: Radius.circular(15),
                //                         topRight: Radius.circular(15))),
                //               ),
                //             ),
                //           ),
                //         ]),
                //   ),
                // ),
                // Here, default theme colors are used for activeBgColor, activeFgColor, inactiveBgColor and inactiveFgColor
                Center(
                  child: ToggleSwitch(
                    minWidth: width * .27,
                    minHeight: height * .07,
                    inactiveBgColor: Colors.white,
                    borderColor: [Color(0xffE8E6EA)],
                    borderWidth: 1,
                    initialLabelIndex: initialGenderIndex,
                    totalSwitches: 3,
                    labels: Gender,
                    onToggle: (index) {
                      widget.homeVm.gender.value = Gender[index!];
                    },
                  ),
                ),
                SizedBox(width: width, height: height * .05),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: widget.homeVm.locationController.value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter your address';
                    }
                  },
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      if (widget.homeVm.locationController.value.text.isEmpty) {
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
                    labelText: 'Search Address',

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
                                  widget.homeVm.locationController.value.text =
                                      searchPlace[index].description ?? "";

                                  SelectedLocation = widget
                                      .homeVm.locationController.value.text;
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

                SizedBox(width: width, height: height * .05),
                //  Distance Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextClass(
                          size: 16,
                          fontWeight: FontWeight.w700,
                          title: 'Distance',
                          fontColor: Colors.black),
                    ),
                    TextClass(
                        size: 14,
                        fontWeight: FontWeight.w400,
                        title: initialDistanceValue.toInt().toString(),
                        fontColor: primaryGrey),
                    TextClass(
                      fontColor: primaryGrey,
                      fontWeight: FontWeight.w400,
                      size: 14,
                      title: ' (in Miles)',
                    )
                  ],
                ),
                //  Distance Slider
                SliderTheme(
                  data: SliderThemeData(
                    thumbShape: SliderThumbShape(disabledThumbRadius: 20),
                    trackShape: CustomTrackShape(),
                    thumbColor: Colors.white,
                    activeTrackColor: primaryDark,
                  ),
                  child: Slider(
                      value: initialDistanceValue,
                      max: 10000,
                      divisions: 10000,
                      inactiveColor: containerBorderColor,
                      onChanged: (double value) {
                        setState(() {
                          initialDistanceValue = value;
                          widget.homeVm.distance = value.toInt().toString().obs;
                        });
                      }),
                ),
                SizedBox(width: width, height: height * .05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextClass(
                          size: 16,
                          fontWeight: FontWeight.w700,
                          title: 'Age',
                          fontColor: Colors.black),
                    ),
                    TextClass(
                        size: 14,
                        fontWeight: FontWeight.w400,
                        title: currentAgeValues.start.toInt().toString(),
                        fontColor: primaryGrey),
                    TextClass(
                      fontColor: primaryGrey,
                      fontWeight: FontWeight.w400,
                      size: 14,
                      title: '-${currentAgeValues.end.toInt().toString()}',
                    )
                  ],
                ),
                SliderTheme(
                  data: SliderThemeData(
                    rangeThumbShape:
                        RoundRangeSliderThumbShape(enabledThumbRadius: 15),
                    rangeTrackShape: RangeCustomTrackShape(),
                    thumbColor: primaryDark,
                    activeTrackColor: primaryDark,
                  ),
                  child: RangeSlider(
                    values: currentAgeValues,

                    inactiveColor: containerBorderColor,
                    max: 100,
                    min: 10,
                    divisions: 90,

                    // overlayColor: MaterialStatePropertyAll(primaryDark),
                    // labels: RangeLabels(
                    //   currentAgeValues.start.round().toString(),
                    //   currentAgeValues.end.round().toString(),
                    // ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        currentAgeValues = values;
                        widget.homeVm.age_from =
                            values.start.toInt().toString().obs;
                        widget.homeVm.age_to =
                            values.end.toInt().toString().obs;
                      });
                    },
                  ),
                ),

                SizedBox(width: width, height: height * .05),
                //  Profession Drop Down

                Obx(() {
                  switch (professionVM.rxRequestStatus.value) {
                    case Status.LOADING:
                      return Center(
                        child: CircularProgressIndicator(
                          color: primaryDark,
                        ),
                      );
                    case Status.ERROR:
                      if (professionVM.error.value == 'No internet') {
                        return InterNetExceptionWidget(
                          onPress: () {
                            professionVM.refreshApi();
                          },
                        );
                      } else {
                        return GeneralExceptionWidget(
                          onPress: () {
                            professionVM.refreshApi();
                          },
                        );
                      }
                    case Status.COMPLETED:
                      return InputDecorator(
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: lableDropDownCol,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                          labelText: 'Profession',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          contentPadding: EdgeInsets.all(10),
                        ),
                        child: ButtonTheme(
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              isDense: true,
                              hint: Text(
                                widget.homeVm.profession.value.isNotEmpty
                                    ? widget.homeVm.profession.value
                                    : 'Choose a profession',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: professionVM.ProfessionList.value
                                          .profileProfession ==
                                      null
                                  ? List.empty()
                                  : professionVM
                                      .ProfessionList.value.profileProfession!
                                      .map((item) => DropdownMenuItem<String>(
                                            value:
                                                item.professionName.toString(),
                                            child: Text(
                                              item.professionName.toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                              value: selectedProffesion,
                              onChanged: (value) {
                                setState(() {
                                  selectedProffesion = value;
                                  widget.homeVm.profession = value!.obs;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                height: 40,
                                width: Get.width,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: height * .2,
                                width: width * .9,
                                useSafeArea: true,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                offset: const Offset(-20, 0),
                                isOverButton: false,
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness:
                                      MaterialStateProperty.all<double>(6),
                                  thumbVisibility:
                                      MaterialStateProperty.all<bool>(true),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                              ),
                            ),
                          ),
                        ),
                      );
                    // LabelDropDownButton(
                    //     labelText: 'Color',
                    //     items: colorVM.colorList.value.profileColour!,
                    //     selectedItem: selectedColor);
                  }
                }),

                // LabelDropDownButton(
                //     labelText: 'Profession',
                //     items: ProfessionItems,
                //     selectedItem: selectedProffesion),
                SizedBox(width: width, height: height * .05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextClass(
                          size: 16,
                          fontWeight: FontWeight.w700,
                          title: 'Height',
                          fontColor: Colors.black),
                    ),
                    TextClass(
                        size: 15,
                        fontWeight: FontWeight.w500,
                        title:
                            "${currentHeightValues.start ~/ 12} ft ${(currentHeightValues.start % 12).toInt()}'' ",
                        fontColor: primaryGrey),
                    TextClass(
                        size: 15,
                        fontWeight: FontWeight.w500,
                        title:
                            "- ${currentHeightValues.end ~/ 12} ft ${(currentHeightValues.end % 12).toInt()}'' ",
                        fontColor: primaryGrey),
                  ],
                ),
                SliderTheme(
                  data: SliderThemeData(
                    rangeThumbShape:
                        RoundRangeSliderThumbShape(enabledThumbRadius: 15),
                    rangeTrackShape: RangeCustomTrackShape(),
                    thumbColor: primaryDark,
                    activeTrackColor: primaryDark,
                  ),
                  child: RangeSlider(
                    values: currentHeightValues,

                    inactiveColor: containerBorderColor,
                    max: 120,
                    min: 0,
                    divisions: 120,

                    // overlayColor: MaterialStatePropertyAll(primaryDark),
                    // labels: RangeLabels(
                    //   currentAgeValues.start.round().toString(),
                    //   currentAgeValues.end.round().toString(),
                    // ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        currentHeightValues = values;
                        widget.homeVm.height_from =
                            values.start.toInt().toString().obs;
                        widget.homeVm.height_to =
                            values.end.toInt().toString().obs;
                      });
                    },
                  ),
                ),
                // SliderTheme(
                //   data: SliderThemeData(
                //     thumbShape: SliderThumbShape(disabledThumbRadius: 20),
                //     trackShape: CustomTrackShape(),
                //     thumbColor: Colors.white,
                //     activeTrackColor: primaryDark,
                //   ),
                //   child: Slider(
                //       value: initialHeightValue,
                //       max: 244,
                //       min: 91,
                //       divisions: 153,
                //       inactiveColor: Colors.grey.shade200,
                //       onChanged: (double value) {
                //         setState(() {
                //           initialHeightValue = value;
                //         });
                //       }),
                // ),

                SizedBox(width: width, height: height * .05),
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
                      return InputDecorator(
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: lableDropDownCol,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                          labelText: 'Color',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          contentPadding: EdgeInsets.all(10),
                        ),
                        child: ButtonTheme(
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              isDense: true,
                              hint: Text(
                                widget.homeVm.colour.value.isNotEmpty
                                    ? widget.homeVm.colour.value
                                    : 'Choose a color',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: colorVM.colorList.value.profileColour ==
                                      null
                                  ? List.empty()
                                  : colorVM.colorList.value.profileColour!
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item.colorName.toString(),
                                            child: Text(
                                              item.colorName.toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                              value: selectedColor,
                              onChanged: (value) {
                                setState(() {
                                  selectedColor = value;
                                  widget.homeVm.colour = value.toString().obs;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                height: 40,
                                width: Get.width,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: height * .2,
                                width: width * .9,
                                useSafeArea: true,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                offset: const Offset(-20, 0),
                                isOverButton: false,
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness:
                                      MaterialStateProperty.all<double>(6),
                                  thumbVisibility:
                                      MaterialStateProperty.all<bool>(true),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                              ),
                            ),
                          ),
                        ),
                      );
                    // LabelDropDownButton(
                    //     labelText: 'Color',
                    //     items: colorVM.colorList.value.profileColour!,
                    //     selectedItem: selectedColor);
                  }
                }),
                SizedBox(width: width, height: height * .05),
                InkWell(
                    onTap: () async {
                      selectedEducation = await Get.to(() => EducationSelection(
                            fromEditScreen: false,
                          ));

                      // aboutYouViewModel.educationList = selectedEducation.obs;
                      if (selectedEducation.isNotEmpty) {
                        widget.homeVm.education = selectedEducation.obs;
                      }
                      setState(() {});
                    },
                    child: selectedEducation.length == 0
                        ? TextClass(
                            size: 16,
                            fontWeight: FontWeight.w500,
                            title: 'Select Education',
                            fontColor: primaryDark)
                        : TextClass(
                            size: 16,
                            fontWeight: FontWeight.w500,
                            title: 'Selected Education',
                            fontColor: primaryDark)),
                widget.homeVm.education.length == 0
                    ? Divider(
                        color: Color(0xffCDD1D0),
                        thickness: 1,
                      )
                    : SizedBox(
                        height: height * .02,
                      ),
                widget.homeVm.education.isNotEmpty
                    ? GridView.builder(
                        physics:
                            NeverScrollableScrollPhysics(), // Disable scrolling
                        shrinkWrap: true,
                        itemCount: widget.homeVm.education.length,
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
                                    title: widget.homeVm.education[index]),
                              ),
                            ))
                    : GridView.builder(
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
                SizedBox(width: width, height: height * .05),
                InkWell(
                    onTap: () async {
                      selectedHobbies = await Get.to(() => HobbiesSelection(
                            fromFilter: true,
                            fromEditScreen: false,
                          ));
                      // aboutYouViewModel.hobbiesList = selectedHobbies.obs;
                      if (selectedHobbies.isNotEmpty) {
                        widget.homeVm.hobbies = selectedHobbies.obs;
                      }
                      setState(() {
                        print(selectedHobbies.length);
                      });
                    },
                    child: selectedHobbies.length == 0
                        ? TextClass(
                            size: 16,
                            fontWeight: FontWeight.w500,
                            title: 'Select Interest',
                            fontColor: primaryDark)
                        : TextClass(
                            size: 16,
                            fontWeight: FontWeight.w500,
                            title: 'Selected Interest',
                            fontColor: primaryDark)),

                widget.homeVm.hobbies.length == 0
                    ? Divider(
                        color: Color(0xffCDD1D0),
                        thickness: 1,
                      )
                    : SizedBox(
                        height: height * .02,
                      ),
                widget.homeVm.hobbies.isNotEmpty
                    ? GridView.builder(
                        physics:
                            NeverScrollableScrollPhysics(), // Disable scrolling
                        shrinkWrap: true,
                        itemCount: widget.homeVm.hobbies.length,
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
                                    align: TextAlign.center,
                                    fontWeight: FontWeight.w700,
                                    size: 13,
                                    fontColor: primaryDark,
                                    title: widget.homeVm.hobbies[index]),
                              ),
                            ))
                    : GridView.builder(
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
                                    align: TextAlign.center,
                                    fontWeight: FontWeight.w700,
                                    size: 13,
                                    fontColor: primaryDark,
                                    title: selectedHobbies[index]),
                              ),
                            )),
                // LabelDropDownButton(
                //     labelText: 'Hobbies',
                //     items: HobbiesItems,
                //     selectedItem: selectedHobbies),

                SizedBox(width: width, height: height * .03),

                // Star Rating
                Align(
                  alignment: Alignment.topLeft,
                  child: TextClass(
                      size: 16,
                      fontWeight: FontWeight.w700,
                      title: 'Star Rating',
                      fontColor: Colors.black),
                ),
                SizedBox(
                  height: height * .01,
                ),
                RatingBar.builder(
                  onRatingUpdate: (value) =>
                      {widget.homeVm.rating = value.toInt().toString().obs},
                  initialRating: widget.homeVm.rating.value.isNotEmpty
                      ? double.parse(widget.homeVm.rating.value)
                      : 0,
                  minRating: 0,
                  itemSize: 30,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
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
