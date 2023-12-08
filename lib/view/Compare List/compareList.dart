import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/components/internet_exceptions_widget.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/data/response/status.dart';
import 'package:nauman/view_models/controller/personalityQ/personalityQ_view_model.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';

import '../../UI Components/components/general_exception.dart';

class CompareList extends StatefulWidget {
  var otherPhoto;
  var otherName;
  var otherRating;
  var otherAnswers;
  var otherProfession;
  CompareList(
      {required this.otherPhoto,
      required this.otherName,
      required this.otherRating,
      required this.otherAnswers,
      required this.otherProfession});
  @override
  State<CompareList> createState() => _CompareListState();
}

class _CompareListState extends State<CompareList> {
  var questionsViewModal = Get.put(PersonalityQGetViewModel());
  var myProfileView_vm = Get.put(UserProfileView_ViewModel());
  
  @override
  void initState() {
    questionsViewModal.HobbiesApi();
    myProfileView_vm.UserProfileViewApi();

    // TODO: implement initState
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
    
    final width = Get.width;
    final height = Get.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextClass(
            size: 20,
            fontWeight: FontWeight.w600,
            title: 'Compare List',
            fontColor: Colors.black),
      ),
      body: Obx(() {
        final myProfileStatus = myProfileView_vm.rxRequestStatus.value;

        final questionsStatus = questionsViewModal.rxRequestStatus.value;
        if (myProfileStatus == Status.ERROR ||
            questionsStatus == Status.ERROR) {
          if (questionsViewModal.error.value == 'No internet' ||
              myProfileView_vm.error.value == 'No internet') {
            return InterNetExceptionWidget(
              onPress: () {
                questionsViewModal.refreshApi();
                myProfileView_vm.refreshApi();
              },
            );
          } else {
            return GeneralExceptionWidget(onPress: () {
              questionsViewModal.refreshApi();
              myProfileView_vm.refreshApi();
            });
          }
        } else if (myProfileStatus == Status.LOADING ||
            questionsStatus == Status.LOADING) {
          return Center(
              child: CircularProgressIndicator(
            color: primaryDark,
          ));
        } else {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: width * .41,
                            height: height * .23,
                            child: CachedNetworkImage(
                              imageUrl: myProfileView_vm
                                  .UserDataList.value.userData!.proImgUrl
                                  .toString(),
                              progressIndicatorBuilder:
                                  (context, url, progress) => Center(
                                      child: CircularProgressIndicator(
                                color: primaryDark,
                              )),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(height: height * .01),
                        TextClass(
                            size: 14,
                            fontWeight: FontWeight.w600,
                            title: myProfileView_vm
                                .UserDataList.value.userData!.userName
                                .toString(),
                            fontColor: primaryDark),
                        TextClass(
                            size: 11,
                            fontWeight: FontWeight.w400,
                            title: myProfileView_vm.UserDataList.value.userData!
                                .userDetails!.profession!,
                            fontColor: Colors.black),
                        SizedBox(height: height * .0005),
                        RatingBar.builder(
                          initialRating: double.parse(myProfileView_vm.UserDataList.value.userData!.userDetails!.average_rating!.toString()),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          ignoreGestures: true,
                          itemCount: 5,
                          itemSize: 15,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: width * .41,
                            height: height * .23,
                            child: CachedNetworkImage(
                              imageUrl: widget.otherPhoto,
                              progressIndicatorBuilder:
                                  (context, url, progress) => Center(
                                      child: CircularProgressIndicator(
                                color: primaryDark,
                              )),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )),
                        // Container(
                        //   width: width * .41,
                        //   height: height * .2,
                        //   decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10),
                        //       image: DecorationImage(
                        //         fit: BoxFit.cover,
                        //         image: AssetImage(
                        //           'assets/images/homePhoto2.png',
                        //         ),
                        //       )),
                        // ),
                        SizedBox(height: height * .01),
                        TextClass(
                            size: 14,
                            fontWeight: FontWeight.w600,
                            title: widget.otherName,
                            fontColor: primaryDark),
                        TextClass(
                            size: 11,
                            fontWeight: FontWeight.w400,
                            title: widget.otherProfession,
                            fontColor: Colors.black),
                        SizedBox(height: height * .0005),
                      

                        RatingBar.builder(
                          initialRating: widget.otherRating ?? 0,
                          direction: Axis.horizontal,
                          ignoreGestures: true,
                          itemCount: 5,
                          itemSize: 15,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: height * .02,
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return CustonQuestionDesign(
                        question:
                            "${index + 1}. ${questionsViewModal.PersonalityQList.value.personalityQuesstions![index].question!}",
                        othersPreference: widget.otherAnswers[index].answer,
                        ourPreference: myProfileView_vm
                            .UserDataList
                            .value
                            .userData!
                            .userDetails!
                            .personalityQuestions![index]
                            .answer!,
                      );
                    },
                  ),
                )
              ],
            ),
          );
        }
      }),
    );
  }
}

class CustonQuestionDesign extends StatelessWidget {
  String question;
  String ourPreference;
  String othersPreference;
  CustonQuestionDesign(
      {required this.question,
      required this.othersPreference,
      required this.ourPreference});
  @override
  Widget build(BuildContext context) {
    final height = Get.height;
    final width = Get.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextClass(
          size: 14,
          fontWeight: FontWeight.w500,
          title: question,
          fontColor: primaryDark,
          align: TextAlign.start,
        ),
        SizedBox(
          height: height * .01,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextClass(
                    align: TextAlign.start,
                    size: 14,
                    fontWeight: FontWeight.w500,
                    title: ourPreference,
                    fontColor: Colors.black),
              ),
              SizedBox(
                width: width * .3,
              ),
              Expanded(
                child: TextClass(
                    size: 14,
                    fontWeight: FontWeight.w500,
                    title: othersPreference,
                    fontColor: Colors.black),
              ),
            ],
          ),
        ),
        Divider(
          color: Color(0xffCDD1D0),
        ),
        SizedBox(
          height: height * .04,
        )
      ],
    );
  }
}
