import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/button.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/components/general_exception.dart';
import 'package:nauman/UI%20Components/components/internet_exceptions_widget.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/data/response/status.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/view_models/controller/profession/profession_controller.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';

class ProfessionSelection extends StatefulWidget {
  bool fromEditScreen;
  ProfessionSelection({required this.fromEditScreen});
  @override
  State<ProfessionSelection> createState() => ProfessionSelectionState();
}

class ProfessionSelectionState extends State<ProfessionSelection> {
  final professionViewModel = Get.put(ProfessionViewModel());
  var userProfileView_vm = Get.put(UserProfileView_ViewModel());
  RxString? selectedProfession;

  void printSelectedDegree() {
    print("Selected Profession : $selectedProfession");
  }

  bool showButton = false;
  int selectedIndex = -1;
  String apiProfession = '';
  void changeColor(int index) {
    selectedIndex = index;
    selectedProfession = (professionViewModel
            .ProfessionList.value.profileProfession![index].professionName!)
        .obs;
    print(selectedProfession);
    showButton = true;
    setState(() {});
  }

  void changeColorApi(int index) {
    selectedIndex = index;
    selectedProfession = (professionViewModel
            .ProfessionList.value.profileProfession![index].professionName!)
        .obs;
    print(selectedProfession);
    showButton = true;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    professionViewModel.ProfessionApi();
    if (widget.fromEditScreen == true) {
      apiProfession = userProfileView_vm
          .UserDataList.value.userData!.userDetails!.profession
          .toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Hey I am a $globalProfession");

    return Scaffold(
        bottomNavigationBar: showButton == false
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
                    globalProfession = selectedProfession.toString();
                    Get.back(result: selectedProfession);
                  },
                ),
              ),
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text('Select Profession'),
        ),
        body: Obx(() {
          switch (professionViewModel.rxRequestStatus.value) {
            case Status.LOADING:
              return Center(
                  child: CircularProgressIndicator(
                color: primaryDark,
              ));
            case Status.ERROR:
              if (professionViewModel.error.value == 'No internet') {
                return InterNetExceptionWidget(
                  onPress: () {
                    professionViewModel.refreshApi();
                  },
                );
              } else {
                return GeneralExceptionWidget(onPress: () {
                  professionViewModel.refreshApi();
                });
              }
            case Status.COMPLETED:
              return GridView.builder(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  itemCount: professionViewModel
                      .ProfessionList.value.profileProfession!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 40,
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 10),
                  itemBuilder: (context, index) {
                    if (widget.fromEditScreen == true) {
                      if (apiProfession.isNotEmpty &&
                          apiProfession ==
                              professionViewModel.ProfessionList.value
                                  .profileProfession![index].professionName
                                  .toString()) {
                        return GestureDetector(
                          onTap: () {
                            changeColor(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: primaryDark),
                                borderRadius: BorderRadius.circular(15),
                                color: selectedIndex == index
                                    ? primaryDark
                                    : primaryGrey),
                            child: Center(
                              child: TextClass(
                                title: professionViewModel.ProfessionList.value
                                    .profileProfession![index].professionName
                                    .toString(),
                                fontColor: selectedIndex == index
                                    ? Colors.white
                                    : Colors.white,
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
                            changeColor(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: primaryDark),
                                borderRadius: BorderRadius.circular(15),
                                color: selectedIndex == index
                                    ? primaryDark
                                    : Colors.white),
                            child: Center(
                              child: TextClass(
                                title: professionViewModel.ProfessionList.value
                                    .profileProfession![index].professionName
                                    .toString(),
                                fontColor: selectedIndex == index
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w400,
                                size: 14,
                                align: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }
                    } else {
                      if (globalProfession.isNotEmpty &&
                          globalProfession ==
                              professionViewModel.ProfessionList.value
                                  .profileProfession![index].professionName
                                  .toString()) {
                        print('yes');
                        return GestureDetector(
                          onTap: () {
                            changeColor(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: primaryDark),
                                borderRadius: BorderRadius.circular(15),
                                color: selectedIndex == index
                                    ? primaryDark
                                    : primaryGrey),
                            child: Center(
                              child: TextClass(
                                title: professionViewModel.ProfessionList.value
                                    .profileProfession![index].professionName
                                    .toString(),
                                fontColor: selectedIndex == index
                                    ? Colors.white
                                    : Colors.white,
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
                            changeColor(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: primaryDark),
                                borderRadius: BorderRadius.circular(15),
                                color: selectedIndex == index
                                    ? primaryDark
                                    : Colors.white),
                            child: Center(
                              child: TextClass(
                                title: professionViewModel.ProfessionList.value
                                    .profileProfession![index].professionName
                                    .toString(),
                                fontColor: selectedIndex == index
                                    ? Colors.white
                                    : Colors.black,
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
