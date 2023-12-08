import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:get/get.dart';
// import 'package:nauman/Chat%20Screens/chatListBack.dart';
// import 'package:nauman/Chat%20Screens/chatListScreen.dart';
// import 'package:nauman/Favourite%20List/favouriteList.dart';
// import 'package:nauman/HomeScreens/homePage.dart';
// import 'package:nauman/My%20Profile/myProfile.dart';
// import 'package:nauman/My%20Profile/myProfileNav.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/audioDisp.dart';
import 'package:nauman/demo.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/utils/utils.dart';
import 'package:nauman/view/Chat%20Screens/audioCallScreen.dart';
import 'package:nauman/view/Chat%20Screens/videoCallScreen.dart';


import 'package:nauman/view/Favourite%20List/favouriteList.dart';
import 'package:nauman/view/HomeScreens/homePage.dart';
import 'package:nauman/view/My%20Profile/myProfile.dart';
import 'package:nauman/view/My%20Profile/myProfile_edit.dart';
import 'package:nauman/view/Other%20Profile/otherProfile.dart';
import 'package:nauman/view/User%20Requests%20Screen/requestTabBar.dart';
import 'package:nauman/view_models/controller/favouriteList/favouriteList_controller.dart';
import 'package:nauman/view_models/controller/homeScreen/homeScreen_view_model.dart';
import 'package:nauman/view_models/controller/other_profile_view/other_profile_view_viewModel.dart';
import 'package:nauman/view_models/controller/request_list/request_list_controller.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
class BottomNavigation extends StatefulWidget {
  int passedIndex = 0;
  bool fromClear;
  BottomNavigation({required this.passedIndex, required this.fromClear});
  @override
  State<BottomNavigation> createState() => BottomNavigationState();
}

class BottomNavigationState extends State<BottomNavigation>  {
  var homeScreen_viewModel = Get.put(HomeViewModel());
  var requestList = Get.put(RequestListViewModel());
  var userProfileView = Get.put(UserProfileView_ViewModel());
  var favouriteList = Get.put(FavouriteListViewModal());
 var otherProfileData = Get.put(OtherProfileView_ViewModel());  


  StreamSubscription<Map>? streamSubscription;
 
  @override
  void initState() {
    
   
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("yayayayayayayayayayayayayayayayayayayayayayayayayayayayayyayayay");
      print("%%%%%%%%%%%%%%%%%%%%%%%%");
      notificationBell.value = true;
      print(notificationBell.value);
      print("%%%%%%%%%%%%%%%%%%%%%%%%");
      if(message.data['what'] != null && message.data['what'] == 'video'){
       print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      print(message.data['token']);
      // Utils.snackBar(message.notification!.title!,message.notification!.body!, false);
      // Get.snackbar('Incoming Video call from ${message.notification!.title!}','d',backgroundColor: Colors.grey.shade300);
      
      Get.to(()=>Demo(

                channelName:message.data['channelName'] ,
        name: message.notification!.title!,
        photoUrl: message.data['img'],
        token: message.data['token'],
        uid: message.data['uid'],
      ));
      }
      
      else if(message.data['what'] != null && message.data['what'] == 'audio'){
          Get.to(()=> AudioDisp(
             channelName:message.data['channelName'] ,
        name: message.notification!.title!,
        photoUrl: message.data['img'],
        token: message.data['token'],
        uid: message.data['uid'],
          ));
      }
      Utils.snackBar(message.notification!.title!,message.notification!.body!, false);
     
     
    });

    // Handle messages when the app is terminated
   

    // Handle messages when the app is in the background
   
    listenDynamicLinks();
    
    homeScreen_viewModel.HomeApi(false);
    requestList.RequestListApi(false);
    userProfileView.UserProfileViewApi();
    favouriteList.FavouriteListApi(false);

    // TODO: implement initState
    super.initState();
  }

  void goToPage(int index) {
    setState(() {
      widget.passedIndex = index;
    });
  }
  void listenDynamicLinks() async {
    streamSubscription = FlutterBranchSdk.initSession().listen((data) {
      print(
          "---------------------------------------------------------------------- Calling this---------------------------");
      if (data.containsKey("+clicked_branch_link") &&
          data["+clicked_branch_link"] == true) {

       print('data data data dtat tatata at ');
        
        if (data['user_id'] != null) {
          print("dfgdgkdjfgkljldksfjdklfjdslkfjsdfklj sklfjdsklfjsdklfjd kljsklfjdlkf jsdklfjdskl dsklfjd");
          otherProfileData.user_id.value = data['user_id'];
        // Get.to(()=>OtherProfile(fromLink: true,));
        otherProfileData.OtherProfileViewApi();
         
        }
       
      }
      else{
        print("not from link");
      }
    }, onError: (error) {
      print('InitSesseion error: ${error.toString()}');
    });
  }
  // int currentIndex = passedIndex;
  List pages = [
    HomePageScreen(),
    FavouriteList(),
    RequestTabBar(),
    MyProfile()
    // MyProfileEdit()
  ];
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      body: pages[widget.passedIndex],
      bottomNavigationBar: CurvedNavigationBar(
          buttonBackgroundColor: Colors.white,
          color: Colors.white,
          height: Get.height * 0.07,
          backgroundColor: primaryDark,
          animationCurve: Curves.decelerate,
          onTap: (index) {
            goToPage(index);
          },
          items: [
            widget.passedIndex == 0
                ? SvgPicture.asset(
                    'assets/images/Home.svg',
                    height: Get.height * 0.02,
                    width: Get.width * .01,
                  )
                : SvgPicture.asset(
                    'assets/images/HomeBlack.svg',
                  ),
            widget.passedIndex == 1
                ? SvgPicture.asset(
                    'assets/images/HeartGreen.svg',
                    height: Get.height * 0.02,
                    width: Get.width * .01,
                  )
                : SvgPicture.asset('assets/images/Heart.svg'),
            widget.passedIndex == 2
                ? SvgPicture.asset(
                    'assets/images/requestIconGreen.svg',
                    height: Get.height * 0.02,
                    width: Get.width * .01,
                  )
                : SvgPicture.asset(
                    'assets/images/requestIconblack.svg',
                    height: Get.height * .025,
                    width: Get.width * .013,
                  ),
            widget.passedIndex == 3
                ? SvgPicture.asset(
                    'assets/images/ProfileGreen.svg',
                    height: Get.height * 0.02,
                    width: Get.width * .02,
                  )
                : SvgPicture.asset('assets/images/Profile.svg'),
          ]),
    );
  }
}
