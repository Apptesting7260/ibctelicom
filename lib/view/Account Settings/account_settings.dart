import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/data/response/status.dart';
import 'package:nauman/view/Account%20Settings/blocked_ac.dart';
import 'package:nauman/view/Forgot%20Password/resetPassword.dart';
import 'package:nauman/view_models/controller/delete%20Account/delete_controller.dart';
import 'package:nauman/view_models/controller/forgotPassword/passwordChange_view_model.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';

class AccountSettings extends StatefulWidget {
  @override
  State<AccountSettings> createState() => AccountSettingsState();
}

class AccountSettingsState extends State<AccountSettings> {
  var userProfileView_vm = Get.put(UserProfileView_ViewModel());
  var deleteAccVM = Get.put(AccountDeleteController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // persnalityQGet_viewModel.HobbiesApi();
    userProfileView_vm.UserProfileViewApi();
  }
 void  deleteAcDialog(){
  showDialog(context: context, builder:  (BuildContext context){
    return AlertDialog(
    
      actions: [TextClass(size: 14, fontWeight: FontWeight.w300, title: "Are you sure you want to permanently delete your account.", fontColor: Colors.black),
      SizedBox(height: 10,),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          InkWell(
            onTap: () {
              deleteAccVM.accountdeleteFunc();
            },
            child: TextClass(size: 18, fontWeight: FontWeight.w300, title: "YES", fontColor: Colors.red)),
          InkWell(
            onTap: () {
              Get.back();
            },
            child: TextClass(size: 18, fontWeight: FontWeight.w300, title: "NO", fontColor: Colors.green)),
        ],),
      )
      ],
    );
  }
  );
  
 }
  @override
  Widget build(BuildContext context) {
    final height = Get.height;
    final widht = Get.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: TextClass(
            size: 20,
            fontWeight: FontWeight.w600,
            title: 'Account Settings',
            fontColor: Colors.black),
      ),
      body: Obx(() {
        final status = userProfileView_vm.rxRequestStatus.value;
        final userData = userProfileView_vm.UserDataList.value;
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,

            children: [
              TextClass(
                  size: 18,
                  fontWeight: FontWeight.w400,
                  title: 'Account Settings',
                  fontColor: Color(0xffADADAD)),
              SizedBox(
                height: height * .03,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => NewPasswordScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextClass(
                        size: 18,
                        fontWeight: FontWeight.w400,
                        title: 'Change Password',
                        fontColor: Colors.black),
                    Icon(Icons.arrow_forward_ios_rounded)
                  ],
                ),
              ),
              SizedBox(
                height: height * .05,
              ),
              TextClass(
                  size: 14,
                  fontWeight: FontWeight.w500,
                  title: 'Your Email',
                  fontColor: primaryDark),
              SizedBox(
                height: height * .01,
              ),
              status == Status.LOADING || userData == null
                  ? Center(
                      child: CircularProgressIndicator(
                      color: primaryDark,
                    ))
                  : TextClass(
                      size: 16,
                      fontWeight: FontWeight.w400,
                      title: userProfileView_vm
                          .UserDataList.value.userData!.email!,
                      fontColor: Colors.black),
              Divider(
                color: Colors.grey,
              ),
              SizedBox(
                height: height * .03,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => BlockedAccountsScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextClass(
                        size: 18,
                        fontWeight: FontWeight.w400,
                        title: 'Blocked Accounts',
                        fontColor: Colors.black),
                    Icon(Icons.arrow_forward_ios_rounded)
                  ],
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                 print('tapped');
                deleteAcDialog();
                },
                child: Container(width: Get.width,height:Get.height*.07,decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(Get.height*.07)
                
                ),child: Center(child: TextClass(size: 18, fontWeight: FontWeight.bold, title: 'Delete Account', fontColor: Colors.white)),),
              )
            ],
          ),
        );
   
      }),
    );
  }
}
