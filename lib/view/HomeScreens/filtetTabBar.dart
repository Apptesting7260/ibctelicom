import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:nauman/HomeScreens/filterPersonality.dart';
// import 'package:nauman/HomeScreens/filterPhysical.dart';
// import 'package:nauman/HomeScreens/homePage.dart';
import 'package:nauman/UI%20Components/button.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/view/Bottom%20Navigation%20Bar/bottomNavigationBar.dart';
import 'package:nauman/view/HomeScreens/filterPersonality.dart';
import 'package:nauman/view/HomeScreens/filterPhysical.dart';
import 'package:nauman/view/HomeScreens/homePage.dart';
import 'package:nauman/view_models/controller/homeScreen/homeScreen_view_model.dart';
import 'package:nauman/view_models/controller/personality_traits_options.dart/personaltity_traits_options_controller.dart';

import '../../view_models/controller/user_profile_view/user_profile_view_controller.dart';

class FilterTabBar extends StatefulWidget {
  @override
  State<FilterTabBar> createState() => FilterTabBarState();
}

class FilterTabBarState extends State<FilterTabBar>
    with SingleTickerProviderStateMixin {
  final homeVM = Get.put(HomeViewModel());
  var userProfileView = Get.put(UserProfileView_ViewModel());
  final personalityTratisOptions = Get.put(PersonalityTraitsOptionsViewModel());
  var _tabController;
  @override
  void initState() {
     personalityTratisOptions.PersonalityTraitsOptionsApi();
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final height = Get.height;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Padding(
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
          child: Button(
            textColor: Colors.white,
            bgcolor: primaryDark,
            title: 'Continue',
            onTap: () {
              if (_tabController.index == 1) {
                print(optionList);
                HomeDataList.clear();
                homeVM.page_no = '1'.obs;
                page.value = 1;
                noDataHome.value = false;
                callHomePagination.value = true;
                if (optionList.isNotEmpty) {
                  homeVM.personality_traits = optionList.obs;
              
                }
                if(homeVM.gender.value.isEmpty){
                  print('in if');
                 userProfileView.UserDataList.value.userData!.userDetails!.gender! == 'Male' ?
                 homeVM.gender.value = 'Female'
                 : homeVM.gender.value = 'Male';
                }
                print("yooooooo ->>> ${homeVM.gender.value}");
                homeVM.HomeApi(false);
              
                fromFilterScr.value = true;
                Get.back(result: homeVM);
              } else {
                _tabController.animateTo((_tabController.index + 1));
          

              }
            },
          ),
        ),
        appBar: AppBar(
          toolbarHeight: height * .01,
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            controller: _tabController,
            padding: EdgeInsets.symmetric(horizontal: 20),
            labelStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                fontFamily: 'Poppins'),
            labelColor: Colors.white,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: primaryDark,
            ),
            indicatorColor: primaryDark,
            unselectedLabelColor: Color(0xff9D9D9D),
            unselectedLabelStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w500),
            tabs: [
              Tab(child: Text('Physical Traits')),
              Tab(child: Text('Personality Traits')),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            PhysicalTraits(homeVm: homeVM),
            PersonalityTraits(homeVm: homeVM,personalityTratisOptions: personalityTratisOptions),
          ],
        ),
      ),
    );
  }
}
