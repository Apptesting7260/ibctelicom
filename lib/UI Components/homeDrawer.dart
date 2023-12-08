import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:nauman/Chat%20Screens/chatListScreen.dart';
// import 'package:nauman/Favourite%20List/favouriteList.dart';
// import 'package:nauman/My%20Profile/myProfile.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/view/Account%20Settings/account_settings.dart';
import 'package:nauman/view/Chat%20Screens/chatListScreen.dart';
import 'package:nauman/view/Favourite%20List/favouriteList.dart';
import 'package:nauman/view/Home%20Drawer%20Screens/aboutUs.dart';
import 'package:nauman/view/Home%20Drawer%20Screens/contactUs.dart';
import 'package:nauman/view/Home%20Drawer%20Screens/help.dart';
import 'package:nauman/view/Home%20Drawer%20Screens/settings.dart';
import 'package:nauman/view/Home%20Drawer%20Screens/terms_condations.dart';
import 'package:nauman/view/My%20Profile/myProfile.dart';
import 'package:nauman/view/My%20Profile/myProfile_view.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final height = Get.height;

    return SafeArea(
      child: Drawer(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  Menu Title
              TextClass(
                  size: 16,
                  fontWeight: FontWeight.w700,
                  title: 'Menu',
                  fontColor: Colors.black),
              SizedBox(
                height: height * .03,
              ),
              InkWell(
                  onTap: () {
                    Get.to(() => MyProfileView());
                  },
                  child: CustomRow('assets/images/Profile.svg', 'My Profile')),
              SizedBox(
                height: height * .03,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => AboutUs());
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: Get.width * .035,
                    ),
                    TextClass(
                        size: 16,
                        fontWeight: FontWeight.w400,
                        title: 'About',
                        fontColor: Colors.black),
                  ],
                ),
              ),
              SizedBox(
                height: height * .03,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => TermsAndConditions());
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_document,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: Get.width * .035,
                    ),
                    TextClass(
                        size: 16,
                        fontWeight: FontWeight.w400,
                        title: 'Terms and Conditions',
                        fontColor: Colors.black),
                  ],
                ),
              ),
              // SizedBox(
              //   height: height * .03,
              // ),
              // InkWell(
              //   onTap: () {
              //     Get.to(() => Help());
              //   },
              //   child: Row(
              //     children: [
              //       Icon(
              //         Icons.info_outline_rounded,
              //         color: Colors.black,
              //       ),
              //       SizedBox(
              //         width: Get.width * .035,
              //       ),
              //       TextClass(
              //           size: 16,
              //           fontWeight: FontWeight.w400,
              //           title: 'Help',
              //           fontColor: Colors.black),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: height * .03,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => ContactUs());
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.headset_mic_rounded,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: Get.width * .035,
                    ),
                    TextClass(
                        size: 16,
                        fontWeight: FontWeight.w400,
                        title: 'Contact Us',
                        fontColor: Colors.black),
                  ],
                ),
              ),
              SizedBox(
                height: height * .03,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => AccountSettings());
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: Get.width * .035,
                    ),
                    TextClass(
                        size: 16,
                        fontWeight: FontWeight.w400,
                        title: 'Settings',
                        fontColor: Colors.black),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget CustomRow(String path, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Row(
        children: [
          SvgPicture.asset(path),
          SizedBox(
            width: Get.width * .04,
          ),
          TextClass(
              size: 16,
              fontWeight: FontWeight.w400,
              title: title,
              fontColor: Colors.black),
        ],
      ),
    );
  }
}
