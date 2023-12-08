import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/components/general_exception.dart';
import 'package:nauman/UI%20Components/components/internet_exceptions_widget.dart';
import 'package:nauman/UI%20Components/homeDrawer.dart';

import 'package:nauman/UI%20Components/textDesign.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:nauman/data/response/status.dart';


import 'package:nauman/global_variables.dart';

import 'package:nauman/view/Chat%20Screens/chatListScreen.dart';
import 'package:nauman/view/HomeScreens/filtetTabBar.dart';
import 'package:nauman/view/Notification%20Screens/notificationList.dart';
import 'package:nauman/view/Other%20Profile/otherProfile.dart';
import 'package:nauman/view_models/controller/chatGPT/chatGPT_train_cont.dart';

import 'package:nauman/view_models/controller/homeScreen/homeScreen_view_model.dart';
import 'package:nauman/view_models/controller/other_profile_view/other_profile_view_viewModel.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';

class HomePageScreen extends StatefulWidget {
  @override
  State<HomePageScreen> createState() => HomePageScreenState();
}

class HomePageScreenState extends State<HomePageScreen> {
  var homeScreen_viewModel = Get.put(HomeViewModel());
  var otherProfileViewModel = Get.put(OtherProfileView_ViewModel());
  var ownProfileVM = Get.put(UserProfileView_ViewModel());
  var chatGPTVM = Get.put(ChatGPT_trainViewModal());
  RxBool gridEnd = false.obs;
  ScrollController scrollController = ScrollController();

  double? apiUserRating;
  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        fetchData();
      }
    });

    super.initState();
  }

  gpt() async {
    if (ownProfileVM.rxRequestStatus == Status.LOADING) {
      print(
          'loading loading loading loading loading loading loading loading loading loading loading ');
    } else {
      print(
          'compleated compleated  compleated  compleated  compleated  compleated  compleated compleated   ');
      if (hitGPT == true) {
        print(hitGPT);
        var data = ownProfileVM.UserDataList.value.userData;
        Chat_GPT_Modal_Train_Sentence =
            "My name is ${data?.userName.toString()}, I am ${data?.userDetails?.age.toString()} years old, My interests are ${data?.userDetails?.hobbies.toString()}, By profession I am ${data?.userDetails?.profession.toString()}, I have degree in ${data?.userDetails?.education.toString()}, I live at ${data?.userDetails?.location}.";
        chatGPTVM.prompt.value = Chat_GPT_Modal_Train_Sentence;
        chatGPTVM.profile_id = data!.userDetails!.userId!.toInt().obs;
        chatGPTVM.user_id = data.userDetails!.userId!.toInt().obs;
        chatGPTVM.ChatGPT_trainApi();
      } else {
        print('Not train gpt');
        print(hitGPT);
      }
    }
  }

  RxBool noMoreData = false.obs;

  fetchData() async {
    gridEnd.value = true;
    if (callHomePagination.value == true) {
      print('calling it ');
      print('Length ===> ${HomeDataList.length}');
      print("Pageeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee ->>>>>>> ${page}");
      homeScreen_viewModel.page_no = page.toString().obs;
      homeScreen_viewModel.HomeApi(true);
      callHomePagination.value = false;
    } else {
      print('not callin');
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Length of Home Data List ${HomeDataList.length}');
    print('Page Home --> ${page}');
    print("*********************************");
    print(notificationBell.value);
    print("*********************************");
    final height = Get.height;
    final width = Get.width;
    return Container(
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            drawer: Container(
              width: width * .7,
              child: Drawer(
                child: HomeDrawer(),
              ),
            ),
            body: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Column(children: [
                  // Top Row

                  Row(
                    children: [
                      // Sidebar Icon

                      Builder(
                          builder: (context) => InkWell(
                              onTap: () {
                                Scaffold.of(context).openDrawer();
                              },
                              child: Image.asset('assets/images/Sidebar.png'))),
                      SizedBox(
                        width: width * .05,
                      ),
                      // Home Title
                      Expanded(
                          child: TextClass(
                              size: 18,
                              fontWeight: FontWeight.w700,
                              title: 'Home',
                              fontColor: primaryDark)),
                      // Notification Bell Icon
                      Obx(
                        () => IconButton(
                          icon: notificationBell == true.obs
                              ? Icon(Icons.notifications_active)
                              : Icon(Icons.notifications_rounded),
                          iconSize: 28,
                          color: notificationBell == true.obs
                              ? primaryDark
                              : Colors.black,
                          splashColor: primaryDark,
                          onPressed: () {
                           
                            notificationBell.value = false;
                            Get.to(() => NotificationsList());
                          },
                        ),
                      ),
                      SizedBox(
                        width: width * .019,
                      ),
                      // Message Button
                      Obx(() {
                        switch (homeScreen_viewModel.rxRequestStatus.value) {
                          case Status.LOADING:
                            return CircularProgressIndicator(
                              color: primaryDark,
                            );
                          case Status.ERROR:
                            if (homeScreen_viewModel.error.value ==
                                'No internet') {
                              return Container();
                            } else {
                              return Container();
                            }
                          case Status.COMPLETED:
                            return Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: primaryDark,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.message_rounded,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          Get.to(() => ChatList(
                                                ownPhoto: ownProfileVM
                                                        .UserDataList
                                                        .value
                                                        .userData
                                                        ?.proImgUrl
                                                        .toString() ??
                                                    '',
                                                ownUserId: ownProfileVM
                                                        .UserDataList
                                                        .value
                                                        .userData
                                                        ?.userDetails
                                                        ?.userId
                                                        .toString() ??
                                                    '',
                                                collectionName: ownProfileVM
                                                        .UserDataList
                                                        .value
                                                        .userData
                                                        ?.userName
                                                        .toString() ??
                                                    '',
                                              ));
                                        });
                                      },
                                    ),
                                  ),
                                  CircleAvatar(
                                      radius: 8,
                                      backgroundColor: Colors.grey.shade100,
                                      child: StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection(
                                            ownProfileVM
                                                    .UserDataList
                                                    .value
                                                    .userData
                                                    !.userDetails
                                                    !.userId
                                                    .toString()

                                                )
                                            .doc('UnRead')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          var data = snapshot.data?.data();
                                          if (snapshot.connectionState ==
                                              ConnectionState.active) {
                                            return TextClass(
                                              fontColor: primaryDark,
                                              size: 8,
                                              fontWeight: FontWeight.w700,
                                              title:
                                                  data?['unRead'].toString() ??
                                                      '0',
                                            );
                                          } else {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator(color: primaryDark,));
                                          }
                                        },
                                      ))
                                ]);
                        }
                      })
                    ],
                  ),

                  SizedBox(
                    height: height * .025,
                  ),
                  // Candidate Filter Row

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => TextClass(
                          size: 15,
                          fontWeight: FontWeight.w500,
                          title: fromFilterScr.value
                              ? 'Filtered Results'
                              : 'Candidate List',
                          fontColor: Colors.black)),
                      // Filter Button
                      Obx(() {
                        switch (homeScreen_viewModel.rxRequestStatus.value) {
                          case Status.LOADING:
                            return CircularProgressIndicator(
                              color: primaryDark,
                            );
                          case Status.ERROR:
                            if (homeScreen_viewModel.error.value ==
                                'No internet') {
                              return Container();
                            } else {
                              return Container();
                            }
                          case Status.COMPLETED:
                            return InkWell(
                              onTap: () async {
                                homeScreen_viewModel =
                                    await Get.to(() => FilterTabBar());
                                print(homeScreen_viewModel.profession.value);
                              },
                              child: Container(
                                width: width * .25,
                                height: height * .038,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SvgPicture.asset(
                                        'assets/images/filterPhoto.svg'),
                                    TextClass(
                                        size: 15,
                                        fontWeight: FontWeight.w400,
                                        title: 'Filter',
                                        fontColor: Colors.black)
                                  ],
                                ),
                              ),
                            );
                        }
                      })
                    ],
                  ),

                  SizedBox(height: height * 0.03),

                  Obx(() {
                    print("Filter value $fromFilterScr");
                    switch (homeScreen_viewModel.rxRequestStatus.value) {
                      case Status.LOADING:
                        return Expanded(
                            child:
                                Lottie.asset('assets/images/loadingAni.json'));
                      case Status.ERROR:
                        if (homeScreen_viewModel.error.value == 'No internet') {
                          return InterNetExceptionWidget(
                            onPress: () {
                              //  homeScreen_viewModel.HomeApi(false);
                              homeScreen_viewModel.refreshApi();
                            },
                          );
                        } else {
                          return GeneralExceptionWidget(onPress: () {
                            // homeScreen_viewModel.HomeApi(false);
                            homeScreen_viewModel.refreshApi();
                          });
                        }
                      case Status.COMPLETED:
                        print(homeScreen_viewModel.rxRequestStatus.value);

                        gpt();

                        return
                            //  homeScreen_viewModel
                            //         .UserDataList.value.candidateList!.isEmpty
                            HomeDataList.isEmpty
                                ? RefreshIndicator(
                                    backgroundColor: Colors.white,
                                    color: primaryDark,
                                    onRefresh: () async {
                                      HomeDataList.clear();
                                      homeScreen_viewModel.refreshApi();
                                    },
                                    child: SingleChildScrollView(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      child: SizedBox(
                                        width: width,
                                        height: height * .6,
                                        child: Column(
                                          children: [
                                            Lottie.network(
                                                'https://lottie.host/b76ec7f7-686d-4055-9dba-b25a4e5cccec/rVhd7hKU0i.json'),
                                            TextClass(
                                                size: 16,
                                                fontWeight: FontWeight.w600,
                                                align: TextAlign.center,
                                                title:
                                                    "Sorry no results found related to your applied filters.",
                                                fontColor: primaryDark),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: RefreshIndicator(
                                      backgroundColor: Colors.white,
                                      color: primaryDark,
                                      onRefresh: () async {
                                        homeScreen_viewModel.page_no.value =
                                            '1';
                                        page.value = 1;
                                        callHomePagination.value = true;
                                        noDataHome.value = false;
                                        homeScreen_viewModel.HomeApi(false);
                                      },
                                      child: SingleChildScrollView(
                                        controller: scrollController,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GridView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                // controller: scrollController,
                                                itemCount: HomeDataList.length,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  mainAxisSpacing: 10,
                                                  crossAxisSpacing: 15,
                                                  mainAxisExtent: height * .38,
                                                ),
                                                itemBuilder: (context, index) {
                                                  // if (index <=
                                                  //     HomeDataList.length -
                                                  //         1) {
                                                  //   if (
                                                  //       // homeScreen_viewModel
                                                  //       //       .UserDataList
                                                  //       //       .value
                                                  //       //       .candidateList![index]
                                                  //       //       .userAverageRating
                                                  //       HomeDataList[index]
                                                  //               .userAverageRating
                                                  //               ?.averageRating !=
                                                  //           null) {
                                                  //     apiUserRating =
                                                  //         double.parse(
                                                  //             // homeScreen_viewModel
                                                  //             //     .UserDataList
                                                  //             //     .value
                                                  //             //     .candidateList![index]
                                                  //             //     .userAverageRating!
                                                  //             //     .averageRating!
                                                  //             HomeDataList[
                                                  //                     index]
                                                  //                 .userAverageRating!
                                                  //                 .averageRating!);
                                                  //   } else {
                                                  //     apiUserRating = null;
                                                  //   }
                                                  // }

                                                  // if (index ==
                                                  //     HomeDataList.length && callHomePagination
                                                  //           .value ==
                                                  //       true) {
                                                  //   if (callHomePagination
                                                  //           .value ==
                                                  //       true) {
                                                  //     return Center(
                                                  //         child:
                                                  //             CircularProgressIndicator(
                                                  //       color: primaryDark,
                                                  //     ));
                                                  //   }

                                                  // }

                                                  return InkWell(
                                                    onTap: () {
                                                      otherProfileViewModel
                                                              .user_id.value =
                                                          HomeDataList[index]
                                                              .userDetails!
                                                              .userId
                                                              .toString();
                                                      print(HomeDataList[index]
                                                          .userDetails!
                                                          .userId
                                                          .toString());

                                                      Get.to(() => OtherProfile(
                                                            fromLink: false,
                                                          ));
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                            width: width * .41,
                                                            height:
                                                                height * .27,
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  // homeScreen_viewModel
                                                                  //     .UserDataList
                                                                  //     .value
                                                                  //     .candidateList![
                                                                  //         index]
                                                                  //     .proImgUrl
                                                                  //     .toString(),
                                                                  HomeDataList[
                                                                          index]
                                                                      .proImgUrl!,
                                                              progressIndicatorBuilder:
                                                                  (context, url,
                                                                          progress) =>
                                                                      Center(
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                color:
                                                                    primaryDark,
                                                              )),
                                                              imageBuilder:
                                                                  (context,
                                                                          imageProvider) =>
                                                                      Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16),
                                                                  image:
                                                                      DecorationImage(
                                                                    image:
                                                                        imageProvider,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            )),
                                                        SizedBox(
                                                            height:
                                                                height * .01),
                                                        TextClass(
                                                            size: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            title:
                                                                //  homeScreen_viewModel
                                                                //     .UserDataList
                                                                //     .value
                                                                //     .candidateList![index]
                                                                //     .userName!,
                                                                HomeDataList[
                                                                        index]
                                                                    .userName!,
                                                            fontColor:
                                                                primaryDark),
                                                        TextClass(
                                                            size: 11,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            title:
                                                                // homeScreen_viewModel
                                                                //     .UserDataList
                                                                //     .value
                                                                //     .candidateList![index]
                                                                //     .userDetails!
                                                                //     .profession!,
                                                                HomeDataList[
                                                                        index]
                                                                    .userDetails!
                                                                    .profession!,
                                                            fontColor:
                                                                Colors.black),
                                                        SizedBox(
                                                            height:
                                                                height * .0005),
                                                        RatingBar.builder(
                                                          onRatingUpdate:
                                                              (value) => {},
                                                          initialRating:
                                                              // apiUserRating ==
                                                              //         null
                                                              //     ? 0
                                                              //     : apiUserRating!,
                                                              double.parse(HomeDataList[
                                                                      index]
                                                                  .userDetails!
                                                                  .average_rating
                                                                  .toString()),
                                                          ignoreGestures: true,
                                                          itemSize: 14,
                                                          minRating: 0,
                                                          direction:
                                                              Axis.horizontal,
                                                          allowHalfRating:
                                                              false,
                                                          itemCount: 5,
                                                          itemPadding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      1.5),
                                                          itemBuilder:
                                                              (context, _) =>
                                                                  Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                            noDataHome.value == false
                                                ? CircularProgressIndicator(
                                                    color: primaryDark,
                                                  )
                                                : Chip(
                                                    label: TextClass(
                                                        size: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        title:
                                                            ' No more profiles!',
                                                        fontColor:
                                                            primaryDark)),
                                            SizedBox(
                                              height: 5,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                    }
                  })
                ]))),
      ),
    );
  }
}
