import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/components/general_exception.dart';
import 'package:nauman/UI%20Components/components/internet_exceptions_widget.dart';
import 'package:nauman/data/response/status.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/view_models/controller/homeScreen/homeScreen_view_model.dart';
import 'package:nauman/view_models/controller/personality_traits_options.dart/personaltity_traits_options_controller.dart';

class PersonalityTraits extends StatefulWidget {
  bool outgoingValue = false;
  HomeViewModel homeVm;
  PersonalityTraitsOptionsViewModel  personalityTratisOptions;
  PersonalityTraits({required this.homeVm, required this.personalityTratisOptions});
  @override
  State<PersonalityTraits> createState() => PersonalityTraitsState();
}

class PersonalityTraitsState extends State<PersonalityTraits> {
  // var personalityTratisOptions = Get.put(PersonalityTraitsOptionsViewModel());
  bool initial = false;
  @override
  void initState() {
   
    print("Printing option list => ${optionList}");
    // TODO: implement initState
    super.initState();
  }

  void addToList(String val) {
    if (optionList.contains(val)) {
      optionList.remove(val);
    } else {
      optionList.add(val);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final height = Get.height;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Obx(
          () {
            switch (widget.personalityTratisOptions.rxRequestStatus.value) {
              case Status.LOADING:
                return Center(
                  child: CircularProgressIndicator(
                    color: primaryDark,
                  ),
                );
              case Status.ERROR:
                if (widget.personalityTratisOptions.error.value == 'No internet') {
                  return InterNetExceptionWidget(
                    onPress: () {
                      widget.personalityTratisOptions.refreshApi();
                    },
                  );
                } else {
                  return GeneralExceptionWidget(
                    onPress: () {
                      widget.personalityTratisOptions.refreshApi();
                    },
                  );
                }
              case Status.COMPLETED:
                return ListView.builder(
                  itemCount: widget.personalityTratisOptions
                      .optionsList.value.personalityTraitsOptions!.length,
                  itemBuilder: (context, index) {
                    return
                     
                        CheckBoxAndTitle(
                            value: optionList.contains( widget.personalityTratisOptions.optionsList.value
                                .personalityTraitsOptions![index]) ? true: widget.outgoingValue,
                            title: widget.personalityTratisOptions.optionsList.value
                                .personalityTraitsOptions![index]);
                  },
                );
            }
          },
        ));
  }
}

class CheckBoxAndTitle extends StatefulWidget {
  bool value;
  String title;

  CheckBoxAndTitle({
    required this.value,
    required this.title,
  });
  @override
  State<CheckBoxAndTitle> createState() => CheckBoxAndTitleState();
}

class CheckBoxAndTitleState extends State<CheckBoxAndTitle> {
  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    return GestureDetector(
      onTap: () {
        widget.value = !widget.value;
        setState(() {
          PersonalityTraitsState().addToList(widget.title);
        });
      },
      child: Row(
        children: [
          Checkbox(
            side: BorderSide(color: C909090),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            activeColor: primaryDark,
            value: widget.value,
            onChanged: (value) {
              setState(() {
                widget.value = value!;
                PersonalityTraitsState().addToList(widget.title);
              });
            },
          ),
          SizedBox(
            width: width * .01,
          ),
          Expanded(
            child: Text(
              widget.title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ),
          )
        ],
      ),
    );
  }
}
