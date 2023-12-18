import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/components/general_exception.dart';
import 'package:nauman/UI%20Components/components/internet_exceptions_widget.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/UI%20Components/video_player.dart';
import 'package:nauman/data/response/status.dart';
import 'package:nauman/demo.dart';
import 'package:nauman/global_variables.dart';

import 'package:nauman/utils/utils.dart';
import 'package:nauman/view/Chat%20GPT/chat_gpt.dart';
import 'package:nauman/view/Chat%20Screens/chatwithPersonScreen.dart';
import 'package:nauman/view/Compare%20List/compareList.dart';

import 'package:nauman/view_models/controller/blockUnblock/blockUnblock_controller.dart';
import 'package:nauman/view_models/controller/chat%20searching/chat_searching_get_controller.dart';
import 'package:nauman/view_models/controller/chatGPT/chatGPT_train_cont.dart';
import 'package:nauman/view_models/controller/like/like_controller.dart';
import 'package:nauman/view_models/controller/other_profile_view/other_profile_view_viewModel.dart';
import 'package:nauman/view_models/controller/rating/rating_controller.dart';
import 'package:nauman/view_models/controller/request_send/request_send_controller.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';
import 'package:share_plus/share_plus.dart';

class OtherProfile extends StatefulWidget {
  bool fromLink;
  OtherProfile({
    required this.fromLink
  });
  @override
  State<OtherProfile> createState() => OtherProfileState();
}

class OtherProfileState extends State<OtherProfile> {
  var chatPersonAddVM = Get.put(ChatPersonAddViewModel());
  var otherProfileViewModel = Get.put(OtherProfileView_ViewModel());
  var likeViewModel = Get.put(LikeViewModel());
  var requestSendViewModel = Get.put(RequestSendViewModel());
  var ratingViewModal = Get.put(RatingViewModel());
  var blockUnblockViewModal = Get.put(BlockUnblockViewModel());
  var ownProfileVM = Get.put(UserProfileView_ViewModel());

  var chatGPT_trainVM = Get.put(ChatGPT_trainViewModal());
  RxBool likeTap = false.obs;
  RxBool requestTap = false.obs;
  RxBool noVideo = false.obs;
  String? url;
  double? apiUserRating;
  RxString? ratingChanged;
  RxBool blockStatus = false.obs;

  @override
  void initState() {
   
    // TODO: implement initState
    super.initState();

    otherProfileViewModel.OtherProfileViewApi();
  }
  
 

//  BranchLinkProperties lp = BranchLinkProperties();
// BranchContentMetaData metadata = BranchContentMetaData();
  void generateLink(BuildContext context, BranchUniversalObject buo,
      BranchLinkProperties lp) async {
    BranchResponse response =
        await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);



    if (response.success) {
      if (context.mounted) {
        // Share the generated link via a share sheet
        print("yay link generated ------==========> ${response.result}");
        shareGeneratedLink(response.result);
      }
    } else {
      Utils.toastMessageCenter(
          "Error : ${response.errorCode} - ${response.errorMessage}", true);
    }
  }

  Future<void> shareGeneratedLink(String linkToShare) async {
    // Show a share sheet with multiple app options
    await Share.share(linkToShare);
  
  }

     Future<void> createOrJoinChatRoom(bool blockVal ) async {
       var _firestore = FirebaseFirestore.instance;
    DocumentReference roomRef =
        _firestore.collection(ownProfileVM.UserDataList.value.userData!.userDetails!.userId.toString()).doc(otherProfileViewModel.UserDataList.value.candidateList!.roomId.toString());

    // Check if room exists
    DocumentSnapshot roomSnapshot = await roomRef.get();

    if (!roomSnapshot.exists) {
      await roomRef.set({
        'createdAt': FieldValue.serverTimestamp(),
        'userId': otherProfileViewModel.UserDataList.value.candidateList!.userDetails!.userId.toString(),
        'userName':  otherProfileViewModel.UserDataList.value.candidateList!.userName,
        'roomId':  otherProfileViewModel.UserDataList.value.candidateList!.roomId.toString(),
        'profilePhoto':  otherProfileViewModel.UserDataList.value.candidateList!.proImgUrl.toString(),
        'newMsg': false,
        'onScreen': false,
        "noOfUnread": 0,
        'block': false,
        'ownBlock': blockVal
        // Add other room metadata if needed
      });
    } else {
      await roomRef
          .update({'ownBlock': blockVal});
    }

  
   

  }
   Future<void> createOrJoinChatRoomOther(bool blockVal) async {
      var _firestore = FirebaseFirestore.instance;
    DocumentReference roomRef = _firestore.collection(otherProfileViewModel.UserDataList.value.candidateList!.userDetails!.userId.toString()).doc(otherProfileViewModel.UserDataList.value.candidateList!.roomId.toString());

    // Check if room exists
    DocumentSnapshot roomSnapshot = await roomRef.get();

    if (!roomSnapshot.exists) {
      await roomRef.set({
        'createdAt': FieldValue.serverTimestamp(),
        'userId': ownProfileVM.UserDataList.value.userData!.userDetails!.userId.toString(),
        'userName':ownProfileVM.UserDataList.value.userData!.userName ,
        'roomId': otherProfileViewModel.UserDataList.value.candidateList!.roomId.toString(),
        'profilePhoto': ownProfileVM.UserDataList.value.userData!.proImgUrl,
        'newMsg': false,
        'onScreen': true,
        
        "noOfUnread": 0,
        'block':blockVal,
        'ownBlock':false,
        // Add other room metadata if needed
      });
    } else {
      await roomRef.update({'block': blockVal});
    }}

  @override
  Widget build(BuildContext context) {
     
    print(Chat_GPT_Modal_Train_Sentence);
    final width = Get.width;
    final height = Get.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() {
          switch (otherProfileViewModel.rxRequestStatus.value) {
            case Status.LOADING:
              return Center(
                  child: CircularProgressIndicator(
                color: primaryDark,
              ));
            case Status.ERROR:
              if (otherProfileViewModel.error.value == 'No internet') {
                return InterNetExceptionWidget(
                  onPress: () {
                    otherProfileViewModel.refreshApi();
                  },
                );
              } else {
                return GeneralExceptionWidget(onPress: () {
                  otherProfileViewModel.refreshApi();
                });
              }
            case Status.COMPLETED:
              //
              if (otherProfileViewModel
                      .UserDataList.value.candidateList?.likeStatus ==
                  1) {
                likeTap.value = true;
              } else {
                likeTap.value = false;
              }

              url = otherProfileViewModel.UserDataList.value.candidateList
                  ?.userDetails?.userVideoUrl?.userVideo;
              if (url == null) {
                noVideo = true.obs;
              } else {
                noVideo.value = false;
              }

              if (otherProfileViewModel
                      .UserDataList.value.candidateList?.blockStatus ==
                  1) {
                blockStatus = true.obs;
              } else {
                blockStatus = false.obs;
              }

              if (otherProfileViewModel
                      .UserDataList.value.candidateList?.requestStatus !=
                  0) {
                requestTap.value = true;
              } else {
                requestTap.value = false;
              }
              print(
                  "Like Value ${otherProfileViewModel.UserDataList.value.candidateList?.likeStatus}");
              return SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async {
                    otherProfileViewModel.refreshApi();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(alignment: Alignment.bottomCenter, children: [
                            Container(
                              width: width,
                              height: height * .5,
                              child: CachedNetworkImage(
                                imageUrl: otherProfileViewModel.UserDataList
                                    .value.candidateList!.proImgUrl!
                                    .toString(),
                                progressIndicatorBuilder:
                                    (context, url, progress) => Center(
                                        child: CircularProgressIndicator(
                                  color: primaryDark,
                                )),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                Get.back(result: false);
                                              },
                                              icon: Icon(
                                                Icons.arrow_back_outlined,
                                                size: 35,
                                                color: primaryDark,
                                              )),
                                          IconButton(
                                              onPressed: () {
                                                ShowDialog(
                                                    context,
                                                    blockStatus,
                                                    blockUnblockViewModal,
                                                    otherProfileViewModel
                                                        .UserDataList
                                                        .value
                                                        .candidateList!
                                                        .userDetails!
                                                        .userId!
                                                        .toString()
                                                        .obs);
                                              },
                                              icon: Icon(
                                                Icons.more_vert,
                                                size: 30,
                                                color: primaryDark,
                                              )),
                                        ]),
                                  ),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25))),
                              width: width,
                              height: height * .05,
                            ),
                            Obx(
                              () => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      likeTap.value = !likeTap.value;
                                      likeViewModel.like_to =
                                          otherProfileViewModel
                                              .UserDataList
                                              .value
                                              .candidateList!
                                              .userDetails!
                                              .userId!
                                              .toString()
                                              .obs;
                                      if (likeTap.value == true) {
                                        likeViewModel.fav_sataus = "1".obs;
                                      } else {
                                        likeViewModel.fav_sataus = "0".obs;
                                      }
                                      likeViewModel.likeApi();
                                      print(likeViewModel.like_to);
                                      print(likeViewModel.fav_sataus);
                                    },
                                    child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: likeTap.value == true
                                            // otherProfileViewModel.UserDataList.value.candidateList!.likeStatus == 1
                                            ? Color(0xff3F5F4A)
                                            : Colors.grey.shade200,
                                        child: Center(
                                          child: Icon(
                                            Icons.favorite,
                                            color: likeTap.value == true
                                                //  otherProfileViewModel.UserDataList.value.candidateList!.likeStatus == 1
                                                ? Colors.white
                                                : primaryDark,
                                            size: 35,
                                          ),
                                        )),
                                  ),
                                  SizedBox(
                                    width: width * .1,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (requestTap.value == true) {
                                        if (otherProfileViewModel
                                                .UserDataList
                                                .value
                                                .candidateList!
                                                .requestStatus! ==
                                            1) {
                                          Utils.toastMessageCenter(
                                              "You have already sent a connection request to ${otherProfileViewModel.UserDataList.value.candidateList!.userName}.",
                                              true);
                                        } else if (otherProfileViewModel
                                                .UserDataList
                                                .value
                                                .candidateList!
                                                .requestStatus! ==
                                            2) {
                                          Utils.toastMessageCenter(
                                              "You have already received connection request from ${otherProfileViewModel.UserDataList.value.candidateList!.userName}.",
                                              false);
                                        } else if (otherProfileViewModel
                                                .UserDataList
                                                .value
                                                .candidateList!
                                                .requestStatus! ==
                                            0) {
                                          Utils.toastMessageCenter(
                                              "You have already sent a connection request to ${otherProfileViewModel.UserDataList.value.candidateList!.userName}.",
                                              true);
                                        } else {
                                          Utils.toastMessageCenter(
                                              "You both are connected.", false);
                                        }
                                      } else {
                                        requestTap.value = !requestTap.value;
                                        requestSendViewModel.request_to =
                                            otherProfileViewModel
                                                .UserDataList
                                                .value
                                                .candidateList!
                                                .userDetails!
                                                .userId!
                                                .toString()
                                                .obs;
                                        // if (requestTap.value == true) {
                                        //   likeViewModel.fav_sataus = "1".obs;
                                        // } else {
                                        //   likeViewModel.fav_sataus = "0".obs;
                                        // }
                                        print(requestSendViewModel.request_to);
                                        requestSendViewModel.requestSendApi();
                                      }
                                    },
                                    child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: requestTap.value
                                            ? Color(0xff3F5F4A)
                                            : Colors.grey.shade200,
                                        child: Center(
                                            child: requestTap.value
                                                ? SvgPicture.asset(
                                                    'assets/images/requestIconWhite.svg')
                                                : SvgPicture.asset(
                                                    'assets/images/requestIconGreen.svg'))),
                                  ),
                                ],
                              ),
                            )
                          ]),
                          ListTile(
                            title: TextClass(
                              fontColor: Colors.black,
                              fontWeight: FontWeight.w600,
                              size: 24,
                              title: otherProfileViewModel
                                  .UserDataList.value.candidateList!.userName!,
                            ),
                            trailing: Container(
                              width: width * .3,
                              height: height * .05,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,  
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  otherProfileViewModel.UserDataList.value
                                              .candidateList!.requestStatus! ==
                                          3
                                      ? CircleAvatar(
                                        
                                          backgroundColor: primaryDark,
                                          child: IconButton(
                                            iconSize: 20,
                                              onPressed: () {
                                                print("tapped");
                                                chatPersonAddVM.other_user_id!.value  = otherProfileViewModel.UserDataList.value.candidateList!.userDetails!.userId!.toString();
                                                chatPersonAddVM.other_user_name!.value = otherProfileViewModel.UserDataList.value.candidateList!.userName!;
                                                chatPersonAddVM.room_id!.value = otherProfileViewModel.UserDataList.value.candidateList!.roomId!.toString();

                                                chatPersonAddVM.ChatPersonAddApi();
                                                print('tapping it on the chat');
                                                Get.to(() => ChatScreen(
                                                  blockStatusGet: otherProfileViewModel.UserDataList.value.candidateList!.blockStatus == 1 ? true : false,
                                                  deviceToken: otherProfileViewModel.UserDataList.value.candidateList!.device_token!,
                                                      ownPhoto: ownProfileVM
                                                          .UserDataList
                                                          .value
                                                          .userData!
                                                          .proImgUrl
                                                          .toString(),
                                                      ownUserId: ownProfileVM
                                                          .UserDataList
                                                          .value
                                                          .userData!
                                                          .userDetails!
                                                          .userId
                                                          .toString(),
                                                      collectionName:
                                                          ownProfileVM
                                                              .UserDataList
                                                              .value
                                                              .userData!
                                                              .userName
                                                              .toString(),
                                                      roomId:
                                                          otherProfileViewModel
                                                              .UserDataList
                                                              .value
                                                              .candidateList!
                                                              .roomId!
                                                              .toString(),
                                                      userId:
                                                          otherProfileViewModel
                                                              .UserDataList
                                                              .value
                                                              .candidateList!
                                                              .userDetails!
                                                              .userId!
                                                              .toString(),
                                                      name:
                                                          otherProfileViewModel
                                                              .UserDataList
                                                              .value
                                                              .candidateList!
                                                              .userName!,
                                                      photoUrl:
                                                          otherProfileViewModel
                                                              .UserDataList
                                                              .value
                                                              .candidateList!
                                                              .proImgUrl!,
                                                    ));
                                              },
                                              icon: Icon(
                                                Icons.chat_bubble_outlined,
                                                color: Colors.white,
                                              )),
                                        )
                                      : SizedBox(),
                                  InkWell(
                                      onTap: () {
                                        print("Generatig deep link");
                                        // Get.to(() => demo());
                                        generateLink(
                                            context,
                                            BranchUniversalObject(
                                                canonicalIdentifier:
                                                    'flutter/branch',
                                                // canonicalUrl:
                                                //     'https://flutter.dev',
                                                title: '${ otherProfileViewModel.UserDataList.value.candidateList!.userName}',
                                                imageUrl:
                                                    '${otherProfileViewModel.UserDataList.value.candidateList!.proImgUrl}',
                                                contentDescription:
                                                    'Click to view profile',
                                                contentMetadata:
                                                    BranchContentMetaData()
                                                        ..addCustomMetadata(
                                                            "user_id",
                                                           otherProfileViewModel.UserDataList.value.candidateList!.userDetails!.userId),
                                                keywords: [
                                                  'Plugin',
                                                  'Branch',
                                                  'Flutter'
                                                ],
                                                publiclyIndex: true,
                                                locallyIndex: true,
                                                expirationDateInMilliSec:
                                                    DateTime.now()
                                                        .add(const Duration(
                                                            days: 365))
                                                        .millisecondsSinceEpoch),
                                            BranchLinkProperties(
                                                channel: 'social',
                                                feature: 'sharing',
                                                stage: 'new share',
                                                campaign: 'campaign',
                                                tags: ['one', 'two', 'three'])
                                                );
                                      },
                                      child: Image.asset(
                                          'assets/images/btnSend.png')),
                                ],
                              ),
                            ),
                            subtitle: TextClass(
                                size: 14,
                                fontWeight: FontWeight.w400,
                                title: otherProfileViewModel.UserDataList.value
                                    .candidateList!.userDetails!.profession!,
                                fontColor: Color.fromRGBO(0, 0, 0, 0.7)),
                          ),
                          SizedBox(
                            height: height * .03,
                          ),
                          ListTile(
                            title: TextClass(
                              fontColor: Colors.black,
                              fontWeight: FontWeight.w700,
                              size: 16,
                              title: 'Location',
                            ),
                            subtitle: TextClass(
                                size: 14,
                                fontWeight: FontWeight.w400,
                                title: otherProfileViewModel.UserDataList.value
                                    .candidateList!.userDetails!.location!,
                                fontColor: Color.fromRGBO(0, 0, 0, 0.7)),
                            trailing: Container(
                              width: width * .5,
                              height: height * .05,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: height * .05,
                                    width: width * .3,
                                    decoration: BoxDecoration(
                                        color: primaryDark.withOpacity(.1),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: primaryDark,
                                        ),
                                        TextClass(
                                            size: 12,
                                            fontWeight: FontWeight.w700,
                                            title:
                                                '${otherProfileViewModel.UserDataList.value.candidateList!.distance!} in Miles',
                                            fontColor: primaryDark)
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * .02,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => ChatGPT(
                                            profile_id: otherProfileViewModel
                                                .UserDataList
                                                .value
                                                .candidateList!
                                                .userDetails!
                                                .userId!
                                                .toInt(),
                                            user_id: ownProfileVM
                                                .UserDataList
                                                .value
                                                .userData!
                                                .userDetails!
                                                .userId!
                                                .toInt(),
                                          ));
                                    },
                                    child: Image.asset(
                                      'assets/images/chatGptIcon.png',
                                      height: height * .05,
                                      width: width * .09,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          ListTile(
                            title: TextClass(
                              fontColor: Colors.black,
                              fontWeight: FontWeight.w700,
                              size: 16,
                              title: 'About',
                            ),
                            subtitle: TextClass(
                                size: 14,
                                fontWeight: FontWeight.w400,
                                title: otherProfileViewModel.UserDataList.value
                                    .candidateList!.userDetails!.about!,
                                align: TextAlign.start,
                                fontColor: Color.fromRGBO(0, 0, 0, 0.7)),
                          ),
                          SizedBox(
                            height: height * .02,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: TextClass(
                                size: 16,
                                fontWeight: FontWeight.w700,
                                title: 'Interests',
                                fontColor: Colors.black),
                          ),
                          SizedBox(
                            height: height * .02,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: otherProfileViewModel
                                  .UserDataList
                                  .value
                                  .candidateList!
                                  .userDetails!
                                  .hobbies!
                                  .length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisExtent: 50,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10),
                              itemBuilder: (context, index) {
                                return Container(
                                  // padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border:
                                          Border.all(color: Color(0xffE8E6EA))),
                                  child: Center(
                                    child: TextClass(
                                        size: 14,
                                        fontWeight: FontWeight.w400,
                                        title: otherProfileViewModel
                                            .UserDataList
                                            .value
                                            .candidateList!
                                            .userDetails!
                                            .hobbies![index],
                                        fontColor: Colors.black),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: height * .04,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                    backgroundColor:
                                        MaterialStatePropertyAll(primaryDark)),
                                onPressed: () {
                                  Get.to(() => CompareList(
                                      otherPhoto: otherProfileViewModel
                                          .UserDataList
                                          .value
                                          .candidateList!
                                          .proImgUrl
                                          .toString(),
                                      otherName: otherProfileViewModel
                                          .UserDataList
                                          .value
                                          .candidateList!
                                          .userName,
                                      otherProfession: otherProfileViewModel
                                          .UserDataList
                                          .value
                                          .candidateList!
                                          .userDetails!
                                          .profession!,
                                      otherAnswers: otherProfileViewModel
                                          .UserDataList
                                          .value
                                          .candidateList!
                                          .userDetails!
                                          .personalityQuestions!,
                                      otherRating: double.parse(otherProfileViewModel
                                          .UserDataList
                                          .value
                                          .candidateList!
                                          .userDetails!
                                          .average_rating
                                          .toString())));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextClass(
                                      size: 16,
                                      fontWeight: FontWeight.w600,
                                      title: 'Compare With Me',
                                      fontColor: Colors.white),
                                )),
                          ),
                          SizedBox(
                            height: height * .04,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: TextClass(
                                size: 16,
                                fontWeight: FontWeight.w700,
                                title: 'Star Rating',
                                fontColor: Colors.black),
                          ),
                          SizedBox(
                            height: height * .01,
                          ),
                          // apiUserRating != null
                          //     ?
                          RatingBar.builder(
                            onRatingUpdate: (value) {
                              ratingChanged = value.toInt().toString().obs;
                              ratingViewModal.rating_no = ratingChanged;
                              ratingViewModal.rating_to = otherProfileViewModel
                                  .UserDataList
                                  .value
                                  .candidateList!
                                  .userDetails!
                                  .userId!
                                  .toString()
                                  .obs;
                              ratingViewModal.ratingApi();
                              print(
                                  "Rating ==========> ${ratingViewModal.rating_no}");
                            },
                            initialRating: double.parse(otherProfileViewModel
                                .UserDataList
                                .value
                                .candidateList!
                                .userDetails!
                                .average_rating
                                .toString()),
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),

                          // : RatingBar.builder(
                          //     onRatingUpdate: (value) {
                          //       ratingChanged = value.toInt().toString().obs;
                          //       ratingViewModal.rating_no = ratingChanged;
                          //       ratingViewModal.rating_to =
                          //           otherProfileViewModel.UserDataList.value
                          //               .candidateList!.userDetails!.userId!
                          //               .toString()
                          //               .obs;
                          //       ratingViewModal.ratingApi();
                          //     },
                          //     initialRating: 0.0,
                          //     minRating: 0,
                          //     direction: Axis.horizontal,
                          //     allowHalfRating: true,
                          //     itemCount: 5,
                          //     itemPadding:
                          //         EdgeInsets.symmetric(horizontal: 4.0),
                          //     itemBuilder: (context, _) => Icon(
                          //       Icons.star,
                          //       color: Colors.amber,
                          //     ),
                          //   ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 10.0),
                          //   child: RatingBar.builder(
                          //     initialRating: 3,
                          //     minRating: 0,
                          //     direction: Axis.horizontal,
                          //     allowHalfRating: true,
                          //     itemCount: 5,
                          //     itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          //     itemBuilder: (context, _) => Icon(
                          //       Icons.star,
                          //       color: Colors.amber,
                          //     ),
                          //     onRatingUpdate: (rating) {},
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TextClass(
                                size: 16,
                                fontWeight: FontWeight.w700,
                                title: 'Gallery',
                                fontColor: Colors.black),
                          ),
                          SizedBox(
                            height: height * .01,
                          ),
                          otherProfileViewModel
                                      .UserDataList
                                      .value
                                      .candidateList!
                                      .userDetails!
                                      .galleryImagesUrl!
                                      .length >=
                                  2
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CachedNetworkImage(
                                        width: width * .47,
                                        height: height * .3,
                                        fit: BoxFit.cover,
                                        imageUrl: otherProfileViewModel
                                            .UserDataList
                                            .value
                                            .candidateList!
                                            .userDetails!
                                            .galleryImagesUrl![0]
                                            .galleryImages!,
                                        progressIndicatorBuilder:
                                            (context, url, progress) => Center(
                                                child:
                                                    CircularProgressIndicator(
                                          color: primaryDark,
                                        )),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      CachedNetworkImage(
                                        width: width * .47,
                                        height: height * .3,
                                        fit: BoxFit.cover,
                                        imageUrl: otherProfileViewModel
                                            .UserDataList
                                            .value
                                            .candidateList!
                                            .userDetails!
                                            .galleryImagesUrl![1]
                                            .galleryImages!,
                                        progressIndicatorBuilder:
                                            (context, url, progress) => Center(
                                                child:
                                                    CircularProgressIndicator(
                                          color: primaryDark,
                                        )),
                                      ),
                                    ],
                                  ),
                                )
                              : Center(
                                  child: TextClass(
                                      size: 14,
                                      fontWeight: FontWeight.w700,
                                      title:
                                          "${otherProfileViewModel.UserDataList.value.candidateList!.userName!} hasn't uploaded any post! ",
                                      fontColor: primaryDark),
                                ),
                          otherProfileViewModel
                                      .UserDataList
                                      .value
                                      .candidateList!
                                      .userDetails!
                                      .galleryImagesUrl!
                                      .length >=
                                  2
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
                                  child: GridView.builder(
                                    addSemanticIndexes: true,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: otherProfileViewModel
                                            .UserDataList
                                            .value
                                            .candidateList!
                                            .userDetails!
                                            .galleryImagesUrl!
                                            .length -
                                        2,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            mainAxisExtent: 200,
                                            mainAxisSpacing: 5,
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 5),
                                    itemBuilder: (context, index) {
                                      return CachedNetworkImage(
                                        imageUrl: otherProfileViewModel
                                            .UserDataList
                                            .value
                                            .candidateList!
                                            .userDetails!
                                            .galleryImagesUrl![index + 2]
                                            .galleryImages!,
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder:
                                            (context, url, progress) => Center(
                                                child:
                                                    CircularProgressIndicator(
                                          color: primaryDark,
                                        )),
                                      );
                                    },
                                  ),
                                )
                              : SizedBox(
                                  height: height * .04,
                                ),

                          SizedBox(
                            height: height * .01,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TextClass(
                                size: 16,
                                fontWeight: FontWeight.w700,
                                title: 'Video',
                                fontColor: Colors.black),
                          ),
                          noVideo == true
                              ? Center(
                                  child: TextClass(
                                      size: 14,
                                      fontWeight: FontWeight.w700,
                                      title:
                                          "${otherProfileViewModel.UserDataList.value.candidateList!.userName!} hasn't uploaded any video! ",
                                      fontColor: primaryDark),
                                )
                              : Container(
                                  margin: EdgeInsets.all(10),
                                  width: width,
                                  height: height * .25,
                                  child: IconButton(
                                      onPressed: () {
                                        print(url);
                                        Get.to(() => VideoPlayerClass(
                                              videoUrl: url!,
                                            ));
                                      },
                                      icon: Icon(
                                        Icons.play_arrow_rounded,
                                        color: primaryDark,
                                        size: 100,
                                      )),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: primaryDark.withOpacity(.3)),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          opacity: .4,
                                          image: AssetImage(
                                              'assets/images/demoVideoPhoto.jpg')),
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                          SizedBox(
                            height: height * .02,
                          ),
                        ]),
                  ),
                ),
              );
          }
        }));
  }
}

void ShowDialog(BuildContext context, RxBool blockStatus,
    BlockUnblockViewModel blockUnblockViewModal, RxString userId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        alignment: Alignment.center,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
            child: Column(
              children: [
                Obx(
                  () => InkWell(
                    onTap: () {
                      // blockUnblockViewModal.blocked_user_id = userId;
                      // blockUnblockViewModal.blockUnblockApi();
                      // blockStatus.value = !blockStatus.value;
                      ConfirmDialog(
                          context, blockStatus, blockUnblockViewModal, userId);
                      //  Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.block),
                        TextClass(
                            size: 14,
                            fontWeight: FontWeight.w600,
                            title: blockStatus.value ? ' Unblock' : '  Block',
                            fontColor: Colors.black)
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.outlined_flag),
                      TextClass(
                          size: 14,
                          fontWeight: FontWeight.w600,
                          title: '  Report',
                          fontColor: Colors.black)
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

void ConfirmDialog(BuildContext context, RxBool blockStatus,
    BlockUnblockViewModel blockUnblockViewModal, RxString userId) {
  String status = blockStatus.value ? "Unblock" : "Block";
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        alignment: Alignment.center,
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: Column(
              children: [
                TextClass(
                    size: 14,
                    fontWeight: FontWeight.w600,
                    title: "Are you sure you want to ${status}",
                    fontColor: Colors.black),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close)),
                    SizedBox(
                      width: 30,
                    ),
                    InkWell(
                        onTap: () {
                          blockUnblockViewModal.blocked_user_id = userId;
                          blockUnblockViewModal.blockUnblockApi();
                          blockUnblockViewModal.fromChat.value = false;
                          blockStatus.value = !blockStatus.value;
                       
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.done)),
                  ],
                )
              ],
            ),
          )
        ],
      );
    },
  );
}


  