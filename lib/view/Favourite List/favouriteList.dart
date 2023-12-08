import 'dart:async';
import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
// import 'package:nauman/Chat%20Screens/chatListScreen.dart';
// import 'package:nauman/Notification%20Screens/notificationList.dart';
// import 'package:nauman/Other%20Profile/otherProfile.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/components/general_exception.dart';
import 'package:nauman/UI%20Components/components/internet_exceptions_widget.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/data/response/status.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/view/Chat%20Screens/chatListScreen.dart';
import 'package:nauman/view/Notification%20Screens/notificationList.dart';
import 'package:nauman/view/Other%20Profile/otherProfile.dart';

import 'package:nauman/view_models/controller/favouriteList/favouriteList_controller.dart';
import 'package:nauman/view_models/controller/other_profile_view/other_profile_view_viewModel.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';

class FavouriteList extends StatefulWidget {
  @override
  State<FavouriteList> createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {
  RxBool hideData = false.obs;
  var favouriteListVM = Get.put(FavouriteListViewModal());
  var otherProfileViewModel = Get.put(OtherProfileView_ViewModel());
  var ownProfileForCollection = Get.put(UserProfileView_ViewModel());

  ScrollController FavscrollController = ScrollController();
  @override
  void initState() {
    FavscrollController.addListener(() {
      if (FavscrollController.position.maxScrollExtent ==
          FavscrollController.offset) {
        fetchData();
      }
    });
    // TODO: implement initState
    super.initState();
  }

  fetchData() {
    if (callFavPagination.value == true) {
      print('calling it');

      favouriteListVM.page_no = pageFav.toString().obs;

      favouriteListVM.FavouriteListApi(true);
      callFavPagination.value = false;
    } else {
      print('not calling');
    }
  }

  @override
  void dispose() {
    FavscrollController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  callNoData() {
    Future.delayed(
      Duration(seconds: 2),
      () {
        hideData.value = true;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(pageFav);
    final width = Get.width;
    final height = Get.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Column(
              children: [
                // Top Row
                Row(
                  children: [
                    // Home Title
                    Expanded(
                        child: TextClass(
                            size: 18,
                            fontWeight: FontWeight.w700,
                            title: 'Favourite list',
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
                    Stack(alignment: AlignmentDirectional.topEnd, children: [
                      CircleAvatar(
                        backgroundColor: primaryDark,
                        child: IconButton(
                          icon: Icon(
                            Icons.message_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Get.to(() => ChatList(
                          
                                  ownPhoto: ownProfileForCollection
                                      .UserDataList.value.userData!.proImgUrl
                                      .toString(),
                                  ownUserId: ownProfileForCollection
                                      .UserDataList
                                      .value
                                      .userData!
                                      .userDetails!
                                      .userId
                                      .toString(),
                                  collectionName: ownProfileForCollection
                                      .UserDataList.value.userData!.userName
                                      .toString(),
                                ));
                          },
                        ),
                      ),
                      CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.grey.shade100,
                          child:
                          StreamBuilder(stream: FirebaseFirestore.instance.collection(ownProfileForCollection.UserDataList.value.userData!.userDetails!.userId!.toString()).doc('UnRead').snapshots() , builder: (context, snapshot) {
                            var data = snapshot.data?.data();
                            if(snapshot.connectionState == ConnectionState.active){
  return     TextClass (
                            fontColor: primaryDark,
                            size: 8,
                            fontWeight: FontWeight.w700,
                            title: data?['unRead'].toString() ?? '0',
                          );
                            }
                           else{
                            return Center(child: CircularProgressIndicator());
                           }
                          },)
                          
                       
                        )
                    ])
                  ],
                ),

                SizedBox(height: height * 0.03),
                Obx(() {
                  switch (favouriteListVM.rxRequestStatus.value) {
                    case Status.LOADING:
                      return Center(
                          child: CircularProgressIndicator(
                        color: primaryDark,
                      ));
                    case Status.ERROR:
                      if (favouriteListVM.error.value == 'No internet') {
                        return InterNetExceptionWidget(
                          onPress: () {
                            favouriteListVM.refreshApi();
                          },
                        );
                      } else {
                        return GeneralExceptionWidget(onPress: () {
                          favouriteListVM.page_no = '1'.obs;
                          pageFav.value = 1;
                          callFavPagination.value = true;
                          FavouriteDataList.clear();
                          favouriteListVM.refreshApi();
                        });
                      }
                    case Status.COMPLETED:
                      return
                          //  favouriteListVM
                          //         .UserDataList.value.userFavouriteList!.isEmpty
                          FavouriteDataList.isEmpty
                              ? RefreshIndicator(
                                  backgroundColor: Colors.white,
                                  color: primaryDark,
                                  onRefresh: () async {
                                    favouriteListVM.refreshApi();
                                  },
                                  child: SingleChildScrollView(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    child: Column(children: [
                                      Lottie.network(
                                          'https://lottie.host/1ab8cd84-2221-4be8-bfdd-e843deb89107/MHQPM4vz06.json'),
                                      TextClass(
                                          size: 16,
                                          fontWeight: FontWeight.w600,
                                          align: TextAlign.center,
                                          title:
                                              "Sorry you don't have any favourite profiles.",
                                          fontColor: primaryDark),
                                    ]),
                                  ),
                                )
                              : Expanded(
                                  child: RefreshIndicator(
                                    backgroundColor: Colors.white,
                                    color: primaryDark,
                                    onRefresh: () async {
                                      pageFav.value = 1;
                                      callFavPagination.value = true;
                                      favouriteListVM.page_no.value = '1';
                                      noDataFav.value = false;
                                      favouriteListVM.FavouriteListApi(false);
                                    },
                                    child: SingleChildScrollView(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      controller: FavscrollController,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GridView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  FavouriteDataList.length,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                mainAxisSpacing: 10,
                                                crossAxisSpacing: 15,
                                                mainAxisExtent: height * .38,
                                              ),
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                        onTap: () {
                                                          otherProfileViewModel
                                                                  .user_id
                                                                  .value =

                                                              // favouriteListVM
                                                              //     .UserDataList
                                                              //     .value
                                                              //     .userFavouriteList![
                                                              //         index]
                                                              //     .userDetails!
                                                              //     .userId
                                                              //     .toString();
                                                              FavouriteDataList[
                                                                      index]
                                                                  .userDetails!
                                                                  .userId!
                                                                  .toString();
                                                          Get.to(() =>
                                                              OtherProfile(fromLink: false,));
                                                          otherProfileViewModel
                                                              .OtherProfileViewApi();
                                                        },
                                                        child: Container(
                                                            width: width * .41,
                                                            height:
                                                                height * .27,
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  //  favouriteListVM
                                                                  //     .UserDataList
                                                                  //     .value
                                                                  //     .userFavouriteList![
                                                                  //         index]
                                                                  //     .proImgUrl
                                                                  //     .toString(),
                                                                  FavouriteDataList[
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
                                                            ))),
                                                    SizedBox(
                                                        height: height * .01),
                                                    TextClass(
                                                        size: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        title:
                                                            //  favouriteListVM
                                                            //     .UserDataList
                                                            //     .value
                                                            //     .userFavouriteList![index]
                                                            //     .userName!,
                                                            FavouriteDataList[
                                                                    index]
                                                                .userName!,
                                                        fontColor: primaryDark),
                                                    TextClass(
                                                        size: 11,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        title:
                                                            //  favouriteListVM
                                                            //     .UserDataList
                                                            //     .value
                                                            //     .userFavouriteList![index]
                                                            //     .userDetails!
                                                            //     .profession!,
                                                            FavouriteDataList[
                                                                    index]
                                                                .userDetails!
                                                                .profession!,
                                                        fontColor:
                                                            Colors.black),
                                                    SizedBox(
                                                        height: height * .0005),
                                                    RatingBar.builder(
                                                      onRatingUpdate: (value) =>
                                                          {},
                                                      initialRating:
                                                          double.parse(
                                                              FavouriteDataList[
                                                                      index]
                                                                  .userDetails!
                                                                  .average_rating
                                                                  .toString()),
                                                      ignoreGestures: true,
                                                      itemSize: 14,
                                                      minRating: 0,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: false,
                                                      itemCount: 5,
                                                      itemPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 1.5),
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                    )
                                                  ],
                                                );
                                              }),
                                          noDataFav.value == false
                                              ? CircularProgressIndicator(
                                                  color: primaryDark,
                                                )
                                              : Chip(
                                                  label: TextClass(
                                                      size: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      title: 'No more profiles!',
                                                      fontColor: primaryDark))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                  }
                })
              ],
            )),
      ),
    );
  }
}
