import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/components/general_exception.dart';
import 'package:nauman/UI%20Components/components/internet_exceptions_widget.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/UI%20Components/video_player.dart';
import 'package:nauman/data/response/status.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/view/Authentication%20Screens/aboutYouScreen.dart';
import 'package:nauman/view/Authentication%20Screens/inviteFriends.dart';
import 'package:nauman/view/My%20Connections/my_connections.dart';
import 'package:nauman/view/My%20Profile/myProfile_edit.dart';
import 'package:nauman/view_models/controller/photo_delete/photo_delete_view_model.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:blur/blur.dart';

import '../../utils/utils.dart';

class MyProfileView extends StatefulWidget {
  @override
  State<MyProfileView> createState() => MyProfileViewState();
}

class MyProfileViewState extends State<MyProfileView> {
  var userProfileView_vm = Get.put(UserProfileView_ViewModel());

  bool noVideo = false;
  String? url;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // userProfileView_vm.UserProfileViewApi();
    print(
        "My likes -> ${userProfileView_vm.UserDataList.value.userData!.ownLikes!}");
    url = userProfileView_vm
        .UserDataList.value.userData?.userDetails?.userVideoUrl?.userVideo;
    if (url == null) {
      noVideo = true;
    }
  }
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

  @override
  Widget build(BuildContext context) {
    // if(userProfileView_vm
    //     .UserDataList.value.userData?.userDetails?.userVideoUrl?.userVideo == null && noVideo == true){
    //           noVideo = false;
    //     }
        print('kfdkfsjfkdlfjskfjdklfjsdklfjdklfsdkf');
    final height = Get.height;
    final width = Get.width;
    if (userProfileView_vm
            .UserDataList.value.userData?.userDetails?.userVideoUrl ==
        null) {
      print("yes it is null");
    }
    if (userProfileView_vm
            .UserDataList.value.userData?.userDetails?.userVideoUrl !=
        null) {
      print("yes it not null");
    }
    return Container(
        color: Colors.white,
        child: SafeArea(
            child: Scaffold(
                backgroundColor: Colors.white,
                body: Obx(() {
                  switch (userProfileView_vm.rxRequestStatus.value) {
                    case Status.LOADING:
                      return Center(
                          child: CircularProgressIndicator(
                        color: primaryDark,
                      ));
                    case Status.ERROR:
                      if (userProfileView_vm.error.value == 'No internet') {
                        return InterNetExceptionWidget(
                          onPress: () {
                            userProfileView_vm.refreshApi();
                          },
                        );
                      } else {
                        return GeneralExceptionWidget(onPress: () {
                          userProfileView_vm.refreshApi();
                        });
                      }
                    case Status.COMPLETED:
                      return RefreshIndicator(
                        onRefresh: () async {
                          userProfileView_vm.refreshApi();
                        },
                        child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Container(
                                        width: width,
                                        height: height * .5,
                                        child: CachedNetworkImage(
                                          imageUrl: userProfileView_vm
                                              .UserDataList
                                              .value
                                              .userData!
                                              .proImgUrl!
                                              .toString(),
                                          progressIndicatorBuilder: (context,
                                                  url, progress) =>
                                              Center(
                                                  child:
                                                      CircularProgressIndicator(
                                            color: primaryDark,
                                          )),
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: IconButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  icon: Icon(
                                                    Icons.arrow_back,
                                                    color: primaryDark,
                                                  )),
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {},
                                            child: CircleAvatar(
                                              backgroundColor: primaryDark,
                                              radius: 30,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(userProfileView_vm
                                                      .UserDataList
                                                      .value
                                                      .userData!
                                                      .ownLikes!
                                                      .toString(),style:TextStyle(color: Colors.white)),
                                                  Center(
                                                    child: Icon(
                                                      Icons.favorite_rounded,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * .1,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Get.to(MyConnections());
                                            },
                                            child: CircleAvatar(
                                                radius: 30,
                                                backgroundColor:
                                                    Color(0xff3F5F4A),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(userProfileView_vm
                                                        .UserDataList
                                                        .value
                                                        .userData!
                                                        .ownConnection
                                                        .toString(),style: TextStyle(color: Colors.white)),
                                                    SvgPicture.asset(
                                                      'assets/images/requestIconWhite.svg',
                                                      width: width * .045,
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ],
                                      ),
                                    ]),
                                ListTile(
                                  title: TextClass(
                                      size: 24,
                                      fontWeight: FontWeight.w600,
                                      title: userProfileView_vm.UserDataList
                                          .value.userData!.userName!,
                                      fontColor: Colors.black),
                                  subtitle: TextClass(
                                      size: 14,
                                      fontWeight: FontWeight.w400,
                                      title:
                                          // 'Professional Model',
                                          userProfileView_vm
                                              .UserDataList
                                              .value
                                              .userData!
                                              .userDetails!
                                              .profession!,
                                      fontColor: Color.fromRGBO(0, 0, 0, 0.7)),
                                  trailing: InkWell(
                                    onTap: () {
                                      Get.to(() => MyProfileEdit());
                                    },
                                    child: Container(
                                      child: Icon(
                                        Icons.edit,
                                        color: primaryDark,
                                      ),
                                      width: width * .15,
                                      height: height * .075,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              color: Color(0xffE8E6EA))),
                                    ),
                                  ),
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
                                      title:
                                          // 'Jaipur',
                                          userProfileView_vm.UserDataList.value
                                              .userData!.userDetails!.location!,
                                      fontColor: Color.fromRGBO(0, 0, 0, 0.7)),
                                  // trailing: Container(
                                  //   width: width * .5,
                                  //   height: height * .05,
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.end,
                                  //     children: [
                                  //       Container(
                                  //         height: height * .05,
                                  //         width: width * .3,
                                  //         decoration: BoxDecoration(
                                  //             color:
                                  //                 primaryDark.withOpacity(.1),
                                  //             borderRadius:
                                  //                 BorderRadius.circular(10)),
                                  //         child: Row(
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.center,
                                  //           children: [
                                  //             Icon(
                                  //               Icons.location_on_outlined,
                                  //               color: primaryDark,
                                  //             ),
                                  //             TextClass(
                                  //                 size: 12,
                                  //                 fontWeight: FontWeight.w700,
                                  //                 title: '1 in Miles',
                                  //                 fontColor: primaryDark)
                                  //           ],
                                  //         ),
                                  //       ),
                                  //       SizedBox(
                                  //         width: width * .02,
                                  //       ),
                                  //       InkWell(
                                  //         onTap: () {},
                                  //         child: Image.asset(
                                  //           'assets/images/chatGptIcon.png',
                                  //           height: height * .05,
                                  //           width: width * .09,
                                  //         ),
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
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
                                      title:
                                          // 'My name is Jessica Parker and I enjoy meeting new people and finding ways to help them have an uplifting experience. I enjoy reading..',
                                          userProfileView_vm.UserDataList.value
                                              .userData!.userDetails!.about!,
                                      align: TextAlign.start,
                                      fontColor: Color.fromRGBO(0, 0, 0, 0.7)),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(left: 15.0),
                                //   child: TextClass(
                                //     fontColor: primaryDark,
                                //     fontWeight: FontWeight.w700,
                                //     size: 14,
                                //     title: 'Read more',
                                //   ),
                                // ),
                                SizedBox(
                                  height: height * .05,
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
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: userProfileView_vm
                                        .UserDataList
                                        .value
                                        .userData!
                                        .userDetails!
                                        .hobbies!
                                        .length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            mainAxisExtent: 50,
                                            mainAxisSpacing: 10,
                                            crossAxisSpacing: 5),
                                    itemBuilder: (context, index) {
                                      print(//  interests[index],
                                          userProfileView_vm
                                              .UserDataList
                                              .value
                                              .userData!
                                              .userDetails!
                                              .hobbies![index]);
                                      return Container(
                                        // padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border:
                                                Border.all(color: primaryDark)),
                                        child: Center(
                                          child: TextClass(
                                              align: TextAlign.start,
                                              size: 14,
                                              fontWeight: FontWeight.w700,
                                              title:
                                                  //  interests[index],
                                                  userProfileView_vm
                                                      .UserDataList
                                                      .value
                                                      .userData!
                                                      .userDetails!
                                                      .hobbies![index],
                                              fontColor: primaryDark),
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
                                                      BorderRadius.circular(
                                                          15))),
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  primaryDark)),
                                      onPressed: () {

                                        // Get.to(() => InviteFriendsClass());
                                        print("Generatig deep link");
                                        // Get.to(() => demo());
                                        generateLink(
                                            context,
                                            BranchUniversalObject(
                                                canonicalIdentifier:
                                                'flutter/branch',
                                                // canonicalUrl:
                                                //     'https://flutter.dev',
                                                title: '${ userProfileView_vm.UserDataList.value.userData!.userName}',
                                                imageUrl:
                                                '${userProfileView_vm.UserDataList.value.userData!.proImgUrl}',
                                                contentDescription:
                                                'Click to view profile',
                                                contentMetadata:
                                                BranchContentMetaData()
                                                  ..addCustomMetadata(
                                                      "user_id",
                                                      userProfileView_vm.UserDataList.value.userData!.userDetails!.userId),
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
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                            left: 20,
                                            right: 20),
                                        child: TextClass(
                                            size: 16,
                                            fontWeight: FontWeight.w600,
                                            title: 'Invite Friends',
                                            fontColor: Colors.white),
                                      )),
                                ),
                                SizedBox(
                                  height: height * .02,
                                ),
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
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Row(
                                //     mainAxisAlignment:
                                //         MainAxisAlignment.spaceBetween,
                                //     children: [
                                //       Image(
                                //         image: NetworkImage(userProfileView_vm
                                //             .UserDataList
                                //             .value
                                //             .userData!
                                //             .userDetails!
                                //             .galleryImagesUrl![0]
                                //             .galleryImages!),
                                //         width: width * .46,
                                //         height: height * .3,
                                //         fit: BoxFit.cover,
                                //         loadingBuilder: (BuildContext context,
                                //             Widget child,
                                //             ImageChunkEvent? loadingProgress) {
                                //           if (loadingProgress == null) {
                                //             // Image loaded successfully
                                //             return child;
                                //           } else if (loadingProgress
                                //                   .cumulativeBytesLoaded ==
                                //               loadingProgress
                                //                   .expectedTotalBytes) {
                                //             // Image fully loaded, but there was an error before displaying it
                                //             return Center(
                                //               child: Text("Error loading image"),
                                //             );
                                //           } else {
                                //             // Image is still loading, show a loading indicator
                                //             return CircularProgressIndicator(
                                //               color: primaryDark,
                                //             );
                                //           }
                                //         },
                                //         errorBuilder: (BuildContext context,
                                //             Object error,
                                //             StackTrace? stackTrace) {
                                //           // Handle the error gracefully
                                //           return Center(
                                //             child: Text("Error loading image"),
                                //           );
                                //         },
                                //       ),
                                //       Image(
                                //         image: NetworkImage(userProfileView_vm
                                //             .UserDataList
                                //             .value
                                //             .userData!
                                //             .userDetails!
                                //             .galleryImagesUrl![1]
                                //             .galleryImages!),
                                //         width: width * .46,
                                //         height: height * .3,
                                //         fit: BoxFit.cover,
                                //         loadingBuilder: (BuildContext context,
                                //             Widget child,
                                //             ImageChunkEvent? loadingProgress) {
                                //           if (loadingProgress == null) {
                                //             // Image loaded successfully
                                //             return child;
                                //           } else if (loadingProgress
                                //                   .cumulativeBytesLoaded ==
                                //               loadingProgress
                                //                   .expectedTotalBytes) {
                                //             // Image fully loaded, but there was an error before displaying it
                                //             return Center(
                                //               child: Text("Error loading image"),
                                //             );
                                //           } else {
                                //             // Image is still loading, show a loading indicator
                                //             return CircularProgressIndicator(
                                //               color: primaryDark,
                                //             );
                                //           }
                                //         },
                                //         errorBuilder: (BuildContext context,
                                //             Object error,
                                //             StackTrace? stackTrace) {
                                //           // Handle the error gracefully
                                //           return Center(
                                //             child: Text("Error loading image"),
                                //           );
                                //         },
                                //       )
                                //     ],
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
                                  child: GridView.builder(
                                    addSemanticIndexes: true,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        //  galleryPhotosUrl.length - 2
                                        userProfileView_vm
                                            .UserDataList
                                            .value
                                            .userData!
                                            .userDetails!
                                            .galleryImagesUrl!
                                            .length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            mainAxisExtent: 200,
                                            mainAxisSpacing: 5,
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 5),
                                    itemBuilder: (context, index) {
                                      return CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: userProfileView_vm
                                            .UserDataList
                                            .value
                                            .userData!
                                            .userDetails!
                                            .galleryImagesUrl![index]
                                            .galleryImages!,
                                        progressIndicatorBuilder:
                                            (context, url, progress) => Center(
                                                child:
                                                    CircularProgressIndicator(
                                          color: primaryDark,
                                        )),
                                      );
                                      //     Image.network(

                                      //   fit: BoxFit.cover,
                                      // );
                                    },
                                  ),
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
                                                "You haven't uploaded video! ",
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
                                                color: primaryDark
                                                    .withOpacity(.3)),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                opacity: .4,
                                                image: AssetImage(
                                                    'assets/images/demoVideoPhoto.jpg')),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                      ),

                                SizedBox(
                                  height: height * .02,
                                ),
                              ]),
                        ),
                      );
                  }
                }))));
  }
}
