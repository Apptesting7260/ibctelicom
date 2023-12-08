import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/button.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/components/general_exception.dart';
import 'package:nauman/UI%20Components/components/internet_exceptions_widget.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/data/response/status.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/utils/utils.dart';
import 'package:nauman/view/Authentication%20Screens/aboutYouScreen.dart';
import 'package:nauman/view_models/controller/user%20Profile%20hobbies/hobbies_controller.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';
// import 'package:nauman/view_models/controller/Hobbies/hobbie_controller.dart';

class HobbiesSelection extends StatefulWidget {
  bool? fromEditScreen;
  bool? fromFilter;
  HobbiesSelection({required this.fromEditScreen, required this.fromFilter});
  @override
  State<HobbiesSelection> createState() => HobbiesSelectionState();
}

class HobbiesSelectionState extends State<HobbiesSelection> {
  final userHobbiesViewModel = Get.put(HobbiesViewModel());
  var userProfileView_vm = Get.put(UserProfileView_ViewModel());
  List<String> savedInterests = [];

  List<Color> containerColors = List.generate(
    100,
    (index) => Colors.transparent,
  );

  List<Color> fontColors = List.generate(
    100,
    (index) => Colors.black,
  );
  List<Color> containerColorsApi = List.generate(
    100,
    (index) => primaryGrey,
  );

  List<Color> fontColorsApi = List.generate(
    100,
    (index) => Colors.white,
  );

  bool showDoneButton = false;
  List<int> selectedIndexes = [];
  List<String> selectedHobbies = [];

  void _changeColor(int index) {
    setState(() {
      if (containerColors[index] != primaryDark) {
        if (selectedIndexes.length == 5 && widget.fromFilter == false) {
          Utils.toastMessageCenter( 'You can select only 5 interests',true
            );
        }
        if (selectedIndexes.length < 5 && widget.fromFilter == false) {
          containerColors[index] = primaryDark;
          fontColors[index] = Colors.white;
          selectedIndexes.add(index);
          selectedHobbies.add(userHobbiesViewModel
              .HobbesList.value.profileHobbie![index].hobbieName
              .toString());
        }
        if (widget.fromFilter == true) {
          containerColors[index] = primaryDark;
          fontColors[index] = Colors.white;
          selectedIndexes.add(index);
          selectedHobbies.add(userHobbiesViewModel
              .HobbesList.value.profileHobbie![index].hobbieName
              .toString());
        }
      } else {
        containerColors[index] = Colors.transparent;
        fontColors[index] = Colors.black;
        selectedHobbies.remove(userHobbiesViewModel
            .HobbesList.value.profileHobbie![index].hobbieName);
        selectedIndexes.remove(index);
      }
    });
    printSelectedHobbies();
  }

  void _changeColorApi(int index) {
    setState(() {
      if (containerColorsApi[index] != primaryDark) {
        if (selectedIndexes.length == 5 && widget.fromFilter == false) {
             Utils.toastMessageCenter( 'You can select only 5 interests',true
            );
        }  
        if (selectedIndexes.length < 5 && widget.fromFilter == false) {
          containerColorsApi[index] = primaryDark;
          fontColorsApi[index] = Colors.white;
          selectedIndexes.add(index);
          selectedHobbies.add(userHobbiesViewModel
              .HobbesList.value.profileHobbie![index].hobbieName
              .toString());
        }
        if (widget.fromFilter == true) {
          containerColorsApi[index] = primaryDark;
          fontColorsApi[index] = Colors.white;
          selectedIndexes.add(index);
          selectedHobbies.add(userHobbiesViewModel
              .HobbesList.value.profileHobbie![index].hobbieName
              .toString());
        }
      } else {
        containerColorsApi[index] = primaryGrey;
        fontColorsApi[index] = Colors.white;
        selectedHobbies.remove(userHobbiesViewModel
            .HobbesList.value.profileHobbie![index].hobbieName);
        selectedIndexes.remove(index);
      }
    });
    printSelectedHobbies();
  }

  void printSelectedHobbies() {
    print("Selected Hobbies: ${selectedHobbies}");
  }

  List<String>? apiGetHobbies;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Printing saved Interest $savedInterests");
    selectedHobbies = savedInterests;
    userHobbiesViewModel.HobbiesApi();
    if (widget.fromEditScreen == true) {
      apiGetHobbies =
          userProfileView_vm.UserDataList.value.userData!.userDetails!.hobbies;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("from filter ${widget.fromFilter}");
    return Scaffold(
        bottomNavigationBar: selectedIndexes.length == 0
            ? Container(
                width: 20,
                height: 10,
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Button(
                  textColor: Colors.white,
                  bgcolor: primaryDark,
                  title: 'Done',
                  onTap: () {
                    savedInterests = selectedHobbies;
                    globalHobbies = savedInterests;
                    print("Printing saved Interest $savedInterests");
                    Get.back(result: selectedHobbies.toList());
                  },
                ),
              ),
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text('Select Interest'),
        ),
        body: Obx(() {
          switch (userHobbiesViewModel.rxRequestStatus.value) {
            case Status.LOADING:
              return Center(
                  child: CircularProgressIndicator(
                color: primaryDark,
              ));
            case Status.ERROR:
              if (userHobbiesViewModel.error.value == 'No internet') {
                return InterNetExceptionWidget(
                  onPress: () {
                    userHobbiesViewModel.refreshApi();
                  },
                );
              } else {
                return GeneralExceptionWidget(onPress: () {
                  userHobbiesViewModel.refreshApi();
                });
              }
            case Status.COMPLETED:
              return GridView.builder(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  itemCount: userHobbiesViewModel
                      .HobbesList.value.profileHobbie!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 40,
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 10),
                  itemBuilder: (context, index) {
                    if ((apiGetHobbies != null &&
                        apiGetHobbies!.contains(userHobbiesViewModel
                            .HobbesList.value.profileHobbie![index].hobbieName
                            .toString()))) {
                      print(index);
                    }
                    if (widget.fromEditScreen == true) {
                      if (apiGetHobbies != null &&
                          apiGetHobbies!.contains(userHobbiesViewModel
                              .HobbesList.value.profileHobbie![index].hobbieName
                              .toString())) {
                        return GestureDetector(
                          onTap: () {
                            _changeColorApi(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: primaryDark),
                              borderRadius: BorderRadius.circular(15),
                              color: containerColorsApi[index],
                            ),
                            child: Center(
                              child: TextClass(
                                title: userHobbiesViewModel.HobbesList.value
                                    .profileHobbie![index].hobbieName
                                    .toString(),
                                fontColor: fontColorsApi[index],
                                fontWeight: FontWeight.w400,
                                size: 14,
                                align: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            _changeColor(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: primaryDark),
                              borderRadius: BorderRadius.circular(15),
                              color: containerColors[index],
                            ),
                            child: Center(
                              child: TextClass(
                                title: userHobbiesViewModel.HobbesList.value
                                    .profileHobbie![index].hobbieName
                                    .toString(),
                                fontColor: fontColors[index],
                                fontWeight: FontWeight.w400,
                                size: 14,
                                align: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }
                    } else {
                      //  not from edit screen
                      if (globalHobbies.isNotEmpty &&
                          globalHobbies.contains(userHobbiesViewModel
                              .HobbesList.value.profileHobbie![index].hobbieName
                              .toString())) {
                        return GestureDetector(
                          onTap: () {
                            _changeColorApi(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: primaryDark),
                              borderRadius: BorderRadius.circular(15),
                              color: containerColorsApi[index],
                            ),
                            child: Center(
                              child: TextClass(
                                title: userHobbiesViewModel.HobbesList.value
                                    .profileHobbie![index].hobbieName
                                    .toString(),
                                fontColor: fontColorsApi[index],
                                fontWeight: FontWeight.w400,
                                size: 14,
                                align: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            _changeColor(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: primaryDark),
                              borderRadius: BorderRadius.circular(15),
                              color: containerColors[index],
                            ),
                            child: Center(
                              child: TextClass(
                                title: userHobbiesViewModel.HobbesList.value
                                    .profileHobbie![index].hobbieName
                                    .toString(),
                                fontColor: fontColors[index],
                                fontWeight: FontWeight.w400,
                                size: 14,
                                align: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }
                    }
                  });
          }
        }));
  }
}
