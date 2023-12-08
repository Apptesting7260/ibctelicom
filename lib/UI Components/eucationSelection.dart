import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/button.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/components/general_exception.dart';
import 'package:nauman/UI%20Components/components/internet_exceptions_widget.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/data/response/status.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/view_models/controller/education/education_view_model.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';
// import 'package:nauman/view_models/controller/Hobbies/hobbie_controller.dart';

class EducationSelection extends StatefulWidget {
  bool fromEditScreen;
  EducationSelection({required this.fromEditScreen});
  @override
  State<EducationSelection> createState() => EducationSelectionState();
}

class EducationSelectionState extends State<EducationSelection> {
  final educationViewModel = Get.put(EducationViewModel());
  var userProfileView_vm = Get.put(UserProfileView_ViewModel());
  List<Color> containerColors = List.generate(
    18,
    (index) => Colors.transparent,
  );
  List<Color> fontColors = List.generate(
    18,
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

  List<int> selectedIndexes = [];
  List<String> selectedDegree = [];
  void _changeColor(int index) {
    setState(() {
      if (containerColors[index] != primaryDark) {
        containerColors[index] = primaryDark;
        fontColors[index] = Colors.white;
        selectedIndexes.add(index);
        selectedDegree.add(educationViewModel
            .EducationDegreeList.value.profileEducation![index].educationName!);
      } else {
        containerColors[index] = Colors.transparent;
        fontColors[index] = Colors.black;
        selectedDegree.remove(educationViewModel
            .EducationDegreeList.value.profileEducation![index].educationName);
        selectedIndexes.remove(index);
      }
    });
    printSelectedDegree();
  }

  void printSelectedDegree() {
    print("Selected Education Degree: $selectedDegree");
  }

  void _changeColorApi(int index) {
    setState(() {
      if (containerColorsApi[index] != primaryDark) {
      
     
        if (selectedIndexes.length < 5) {
          containerColorsApi[index] = primaryDark;
          fontColorsApi[index] = Colors.white;
          selectedIndexes.add(index);
          selectedDegree.add(educationViewModel
              .EducationDegreeList.value.profileEducation![index].educationName
              .toString());
        }
      } else {
        containerColorsApi[index] = primaryGrey;
        fontColorsApi[index] = Colors.white;
        selectedDegree.remove(educationViewModel
            .EducationDegreeList.value.profileEducation![index].educationName);
        selectedIndexes.remove(index);
      }
    });
    printSelectedDegree();
  }

  List<String>? apiGetEducation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    educationViewModel.EducationApi();
    if (widget.fromEditScreen == true) {
      apiGetEducation = userProfileView_vm
          .UserDataList.value.userData!.userDetails!.education;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    globalEducation = selectedDegree;
                    Get.back(result: selectedDegree.toList());
                  },
                ),
              ),
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: Text('Select Education Qualification'),
        ),
        body: Obx(() {
          switch (educationViewModel.rxRequestStatus.value) {
            case Status.LOADING:
              return Center(
                  child: CircularProgressIndicator(
                color: primaryDark,
              ));
            case Status.ERROR:
              if (educationViewModel.error.value == 'No internet') {
                return InterNetExceptionWidget(
                  onPress: () {
                    educationViewModel.refreshApi();
                  },
                );
              } else {
                return GeneralExceptionWidget(onPress: () {
                  educationViewModel.refreshApi();
                });
              }
            case Status.COMPLETED:
              return GridView.builder(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  itemCount: educationViewModel
                      .EducationDegreeList.value.profileEducation!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 60,
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 10),
                  itemBuilder: (context, index) {
                    if (widget.fromEditScreen == true) {
                      if (apiGetEducation != null &&
                          apiGetEducation!.contains(educationViewModel
                              .EducationDegreeList
                              .value
                              .profileEducation![index]
                              .educationName
                              .toString())) {
                        return GestureDetector(
                          onTap: () {
                            _changeColorApi(index);
                          },
                          child: Container(
                           padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: primaryDark),
                              borderRadius: BorderRadius.circular(15),
                              color: containerColorsApi[index],
                            ),
                            child: Center(
                              child: TextClass(
                                title: educationViewModel
                                    .EducationDegreeList
                                    .value
                                    .profileEducation![index]
                                    .educationName
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
                                padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: primaryDark),
                              borderRadius: BorderRadius.circular(15),
                              color: containerColors[index],
                            ),
                            child: Center(
                              child: TextClass(
                                title: educationViewModel
                                    .EducationDegreeList
                                    .value
                                    .profileEducation![index]
                                    .educationName
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
                      if (globalEducation.isNotEmpty &&
                          globalEducation.contains(educationViewModel
                              .EducationDegreeList
                              .value
                              .profileEducation![index]
                              .educationName
                              .toString())) {
                        return GestureDetector(
                          onTap: () {
                            _changeColorApi(index);
                          },
                          child: Container(
                                padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: primaryDark),
                              borderRadius: BorderRadius.circular(15),
                              color: containerColorsApi[index],
                            ),
                            child: Center(
                              child: TextClass(
                                title: educationViewModel
                                    .EducationDegreeList
                                    .value
                                    .profileEducation![index]
                                    .educationName
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
                                padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: primaryDark),
                              borderRadius: BorderRadius.circular(15),
                              color: containerColors[index],
                            ),
                            child: Center(
                              child: TextClass(
                                title: educationViewModel
                                    .EducationDegreeList
                                    .value
                                    .profileEducation![index]
                                    .educationName
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
