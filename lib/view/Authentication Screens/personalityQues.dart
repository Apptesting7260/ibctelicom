import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
// import 'package:nauman/Bottom%20Navigation%20Bar/bottomNavigationBar.dart';
// import 'package:nauman/HomeScreens/homePage.dart';
import 'package:nauman/UI%20Components/button.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/components/general_exception.dart';
import 'package:nauman/UI%20Components/components/internet_exceptions_widget.dart';
import 'package:nauman/UI%20Components/personalityQuesDropDown.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/data/response/status.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/view/Bottom%20Navigation%20Bar/bottomNavigationBar.dart';
import 'package:nauman/view_models/controller/Signup/signup_view_model.dart';
import 'package:nauman/view_models/controller/aboutYou/aboutYou_view_model.dart';
import 'package:nauman/view_models/controller/personalityQ/personalityQ_view_model.dart';
import 'package:nauman/view_models/controller/personalityQuestionPost/personalityQPost_view_model.dart';
// import 'package:nauman/Authentication Screens//signUp.dart';
// import 'package:nauman/UI%20Components/color.dart';

class PersonalityQuesClass extends StatefulWidget {
  @override
  State<PersonalityQuesClass> createState() => PersonalityQuesClassState();
}

class PersonalityQuesClassState extends State<PersonalityQuesClass> {
  PersonalityQuestionPostViewModel pQPVM =
      Get.put(PersonalityQuestionPostViewModel());
  var _formKey = GlobalKey<FormState>();
  final persnalityQGet_viewModel = Get.put(PersonalityQGetViewModel());
 AboutYouViewModel aboutYouVM = Get.put(AboutYouViewModel());
  final signupVM = Get.put(SignupViewModel());
  List<String> slectedListAnswers = [];
  bool showbutton = false;
  void enableCreateAcbutton() {
    if (slectedListAnswers.length ==
        persnalityQGet_viewModel
            .PersonalityQList.value.personalityQuesstions!.length) {
      setState(() {
        showbutton = true;
      });
    }
  }

  List<Map<String, dynamic>> createPersonalityQuestionList() {
    List<Map<String, dynamic>> questionsList = [];
    for (var i = 0; i < slectedListAnswers.length; i++) {
      questionsList.add({
        "id": (i + 1).toString(),
        "answer": slectedListAnswers[i],
      });
    }
    return questionsList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    persnalityQGet_viewModel.HobbiesApi();
  }

  @override
  Widget build(BuildContext context) {
    final height = Get.height;
    final width = Get.width;

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.black,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: TextClass(
              size: 18,
              fontWeight: FontWeight.w700,
              title: 'Personality Questions',
              fontColor: Colors.black)),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(
          () => Button(
              loading: pQPVM.loading.value,
              textColor: showbutton ? Colors.white : primaryGrey,
              bgcolor: showbutton ? primaryDark : Colors.grey.shade200,
              title: 'Create Account',
              onTap: () {
                final isValid = _formKey.currentState!.validate();
                if (!isValid) {
                  print('Not valid');
                  return;
                }

                // print(slectedListAnswers);
                List<Map<String, dynamic>> personalityQuestionsList =
                    createPersonalityQuestionList();
              
                print(personalityQuestionsList);
                print(Chat_GPT_Modal_Train_Sentence);
                pQPVM.personalityQPostApi(personalityQuestionsList);
              }),
        ),
      ),
      body: Obx(() {
        switch (persnalityQGet_viewModel.rxRequestStatus.value) {
          case Status.LOADING:
            return Center(
                child: CircularProgressIndicator(
              color: primaryDark,
            ));
          case Status.ERROR:
            if (persnalityQGet_viewModel.error.value == 'No internet') {
              return InterNetExceptionWidget(
                onPress: () {
                  persnalityQGet_viewModel.refreshApi();
                },
              );
            } else {
              return GeneralExceptionWidget(onPress: () {
                persnalityQGet_viewModel.refreshApi();
              });
            }
          case Status.COMPLETED:
            if (persnalityQGet_viewModel.PersonalityQList.value == null) {
              // Return a loading indicator or an appropriate widget
              return CircularProgressIndicator();
            } else {
              return Form(
                key: _formKey,
                child: ListView.builder(
                  padding: EdgeInsets.all(20),
                  itemCount: persnalityQGet_viewModel
                      .PersonalityQList.value.personalityQuesstions!.length,
                  itemBuilder: (context, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextClass(
                          size: 14,
                          fontWeight: FontWeight.w500,
                          title:
                              '${index + 1}. ${persnalityQGet_viewModel.PersonalityQList.value.personalityQuesstions![index].question}',
                          fontColor: primaryDark),
                      DropdownButtonFormField2<String>(
                        onSaved: (newValue) {
                          setState(() {
                            enableCreateAcbutton();
                          });
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please choose a option.';
                          }
                          return null;
                        },
                        isExpanded: true,
                        isDense: true,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        hint: Text(
                          'Select a option',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                        items: persnalityQGet_viewModel.PersonalityQList.value
                            .personalityQuesstions![index].answer!
                            .map((personalityQ) => DropdownMenuItem<String>(
                                  value: personalityQ,
                                  child: Text(
                                    personalityQ,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        // value: slectedListAnswers[index],
                        onChanged: (String? value) {
                          setState(() {
                            //
                            //
                            //
                            slectedListAnswers.add(value!);
                            enableCreateAcbutton();
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 30,
                          width: Get.width,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                        iconStyleData: IconStyleData(
                            icon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: primaryDark,
                        )),
                      ),
                      SizedBox(
                        height: height * .04,
                      )
                    ],
                  ),
                ),
              );
            }
        }
      }),
    );
  }
}
