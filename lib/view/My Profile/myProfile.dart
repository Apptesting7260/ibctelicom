import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/components/general_exception.dart';
import 'package:nauman/UI%20Components/components/internet_exceptions_widget.dart';
// import 'package:nauman/Bottom%20Navigation%20Bar/bottomNavigationBar.dart';
// import 'package:nauman/HomeScreens/homePage.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/data/response/status.dart';
import 'package:nauman/demo.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/view/Account%20Settings/account_settings.dart';
import 'package:nauman/view/Authentication%20Screens/splashScreen.dart';
import 'package:nauman/view/Chat%20Screens/chatListScreen.dart';
import 'package:nauman/view/My%20Profile/myProfile_view.dart';
import 'package:nauman/view/User%20Requests%20Screen/requestBack.dart';
import 'package:nauman/view_models/controller/logout/logout.dart';
import 'package:nauman/view_models/controller/other_profile_view/other_profile_view_viewModel.dart';
import 'package:nauman/view_models/controller/user_preference/user_prefrence_view_model.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';
import 'package:signin_with_linkedin/signin_with_linkedin.dart';

class MyProfile extends StatefulWidget {
  @override
  State<MyProfile> createState() => MyProfileState();
}

class MyProfileState extends State<MyProfile> {
  var userProfileView_vm = Get.put(UserProfileView_ViewModel());
 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // persnalityQGet_viewModel.HobbiesApi();
  }
var logoutVM = Get.put(LogoutViewModel());
  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final height = Get.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        // foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,

        title: TextClass(
            size: 20,
            fontWeight: FontWeight.w600,
            title: 'My Profile',
            fontColor: Colors.black),
      ),
      body: Obx(() {
        final status = userProfileView_vm.rxRequestStatus.value;
        final userData = userProfileView_vm.UserDataList.value;
        return status == Status.ERROR
            ? userProfileView_vm.error.value == 'No internet'
                ? InterNetExceptionWidget(
                    onPress: () {
                      userProfileView_vm.refreshApi();
                    },
                  )
                : GeneralExceptionWidget(onPress: () {
                    userProfileView_vm.refreshApi();
                  })
            : Column(
                children: [
                  status == Status.LOADING
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            color: primaryDark,
                          ),
                        )
                      : ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: userProfileView_vm
                                .UserDataList.value.userData!.proImgUrl!
                                .toString(),
                            imageBuilder: (context, imageProvider) => Container(
                              width: 55.0,
                              height: 55.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(
                              color: primaryDark,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          title: TextClass(
                            title: userProfileView_vm
                                .UserDataList.value.userData!.userName!,
                            fontColor: Colors.black,
                            fontWeight: FontWeight.w700,
                            size: 16,
                          ),
                          subtitle: TextClass(
                            title: 'online',
                            fontColor: primaryDark,
                            fontWeight: FontWeight.w400,
                            size: 10,
                          ),
                        ),
                  ListTile(
                    onTap: () {
                      Get.to(() => MyProfileView());
                    },
                    leading: SvgPicture.asset(
                      'assets/images/myPView.svg',
                    ),
                    title: TextClass(
                        size: 16,
                        fontWeight: FontWeight.w400,
                        title: 'View Profile',
                        fontColor: Colors.black),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => RequestTabBarBack());
                    },
                    leading: SvgPicture.asset(
                      'assets/images/myPReq.svg',
                    ),
                    title: TextClass(
                        size: 16,
                        fontWeight: FontWeight.w400,
                        title: 'Requests',
                        fontColor: Colors.black),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => ChatList(
                    
                            ownPhoto: userProfileView_vm
                                .UserDataList.value.userData!.proImgUrl
                                .toString(),
                            ownUserId: userProfileView_vm.UserDataList.value
                                .userData!.userDetails!.userId
                                .toString(),
                            collectionName: userProfileView_vm
                                .UserDataList.value.userData!.userName
                                .toString(),
                          ));
                    },
                    leading: SvgPicture.asset(
                      'assets/images/myPMsg.svg',
                    ),
                    title: TextClass(
                        size: 16,
                        fontWeight: FontWeight.w400,
                        title: 'Message',
                        fontColor: Colors.black),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => AccountSettings());

                    },
                    leading: SvgPicture.asset(
                      'assets/images/myPSettings.svg',
                    ),
                    title: TextClass(
                        size: 16,
                        fontWeight: FontWeight.w400,
                        title: 'Account Settings',
                        fontColor: Colors.black),
                  ),
                  InkWell(
                    onTap: () async {
                       second.value = 0;
      minute.value = 0;
                      logoutVM.logoutApi();
                          
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: primaryDark.withOpacity(.6),
                      ),
                      title: TextClass(
                          size: 16,
                          fontWeight: FontWeight.w400,
                          title: 'Logout',
                          fontColor: Colors.black),
                    ),
                  ),
                ],
              );
      }),
    );
  }
}
