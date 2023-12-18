import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/components/general_exception.dart';
import 'package:nauman/UI%20Components/components/internet_exceptions_widget.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/data/response/status.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/view/Other%20Profile/otherProfile.dart';
import 'package:nauman/view_models/controller/blockList/blockList_controller.dart';
import 'package:nauman/view_models/controller/blockUnblock/blockUnblock_controller.dart';
import 'package:nauman/view_models/controller/other_profile_view/other_profile_view_viewModel.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';

class BlockedAccountsScreen extends StatefulWidget {
  @override
  State<BlockedAccountsScreen> createState() => BlockedAccountsScreenState();
}

class BlockedAccountsScreenState extends State<BlockedAccountsScreen> {
  var blockList_viewModal = Get.put(BlockListViewModel());
  var otherProfileViewModel = Get.put(OtherProfileView_ViewModel());
  var unblock_viewModal = Get.put(BlockUnblockViewModel());
  var ownProfileVM = Get.put(UserProfileView_ViewModel());
  ScrollController blockController = ScrollController();
  @override
  void initState() {
    blockList_viewModal.BlockListApi(false);
    ownProfileVM.UserProfileViewApi();
    blockController.addListener(() {
      if (blockController.position.maxScrollExtent == blockController.offset) {
        fetchData();
      }
    });
    // TODO: implement initState
    super.initState();
  }

  fetchData() {
    if (callBlockPagination.value == true) {
      print('callin');
      blockList_viewModal.page_no.value = pageBlock.toString();
      blockList_viewModal.BlockListApi(true);
      callBlockPagination.value = false;
    } else {
      print('not calling');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                pageBlock.value = 1;
                callBlockPagination.value = true;
                Get.back();
              },
              icon: Icon(Icons.keyboard_backspace_rounded)),
          title: Text('Blocked Accounts'),
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
        ),
        body: Obx(() {
          switch (blockList_viewModal.rxRequestStatus.value) {
            case Status.LOADING:
              return Center(
                  child: Lottie.asset('assets/images/loadingAni.json',
                      fit: BoxFit.cover, height: Get.height, width: Get.width));
            case Status.ERROR:
              if (blockList_viewModal.error.value == 'No internet') {
                return InterNetExceptionWidget(
                  onPress: () {
                    blockList_viewModal.refreshApi();
                  },
                );
              } else {
                return GeneralExceptionWidget(onPress: () {
                  callBlockPagination.value = true;
                  pageBlock.value = 1;
                  blockList_viewModal.page_no.value = '1';
                  blockList_viewModal.refreshApi();
                });
              }
            case Status.COMPLETED:
              return BlockDataList.isEmpty
                  ? RefreshIndicator(
                      color: primaryDark,
                      onRefresh: () async {
                        callBlockPagination.value = true;
                        pageBlock.value = 1;
                        blockList_viewModal.page_no.value = '1';
                        blockList_viewModal.BlockListApi(false);
                      },
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: Get.height * .1,
                              ),
                              Lottie.network(
                                  'https://lottie.host/a13ba45f-ba4e-42d1-9d62-40ae0320d206/S8R05BGVbW.json'),
                              SizedBox(
                                height: Get.height * .04,
                              ),
                              Container(
                                height: Get.height * .4,
                                width: Get.width,
                                child: TextClass(
                                    size: 16,
                                    fontWeight: FontWeight.w600,
                                    align: TextAlign.center,
                                    title: "You didn't block any account.",
                                    fontColor: primaryDark),
                              )
                            ]),
                      ),
                    )
                  : RefreshIndicator(
                      color: primaryDark,
                      onRefresh: () async {
                        callBlockPagination.value = true;
                        pageBlock.value = 1;
                        blockList_viewModal.page_no.value = '1';
                        blockList_viewModal.BlockListApi(false);
                      },
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: blockController,
                        itemCount: BlockDataList.length + 1,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            otherProfileViewModel.user_id.value =
                                BlockDataList[index]
                                    .userDetails!
                                    .userId
                                    .toString();
                            Get.to(() => OtherProfile(
                                  fromLink: false,
                                ));
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: Get.height * .03,
                              ),
                              index == BlockDataList.length
                                  ? callBlockPagination.value == true
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: primaryDark,
                                          ),
                                        )
                                      : Center(
                                          child: Chip(
                                            label: TextClass(
                                                size: 14,
                                                fontWeight: FontWeight.w600,
                                                title: 'No more profiles!',
                                                fontColor: primaryDark),
                                          ),
                                        )
                                  : ListTile(
                                      leading: CachedNetworkImage(
                                        imageUrl: BlockDataList[index]
                                            .proImgUrl
                                            .toString(),
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: 55.0,
                                          height: 55.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
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
                                          size: 14,
                                          fontWeight: FontWeight.w600,
                                          title: BlockDataList[index].userName!,
                                          fontColor: primaryDark),
                                      subtitle: TextClass(
                                          size: 11,
                                          fontWeight: FontWeight.w400,
                                          title: BlockDataList[index]
                                              .userDetails!
                                              .profession!,
                                          fontColor: Colors.black),
                                      trailing: ElevatedButton(
                                          onPressed: () {
                                            ConfirmDialog(index);
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      primaryDark),
                                              shape: MaterialStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))))),
                                          child: TextClass(
                                              size: 8,
                                              fontWeight: FontWeight.w400,
                                              title: 'Unblock',
                                              fontColor: Colors.white))),
                            ],
                          ),
                        ),
                      ),
                    );
          }
        }));
  }

  void ConfirmDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          alignment: Alignment.center,
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextClass(
                            size: 14,
                            fontWeight: FontWeight.w600,
                            title: "Are you sure you want to Un-Block this Id.",
                            fontColor: Colors.black),
                      )
                    ],
                  ),
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
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                          )),
                      SizedBox(
                        width: 30,
                      ),
                      InkWell(
                          onTap: () {
                            int id = BlockDataList[index].userDetails!.userId!;

                            unblock_viewModal.blocked_user_id =
                                id.toString().obs;
                            unblock_viewModal.fromBlock.value = true;
                            if( blockList_viewModal
                                .UserDataList
                                .value
                                .userBlockedList![index]
                                .room_id != null){
                                  unblock_viewModal.rid?.value = blockList_viewModal
                                .UserDataList
                                .value
                                .userBlockedList![index]
                                .room_id
                                .toString();
                                }
                            
                            unblock_viewModal.fromChat.value = false;
                            unblock_viewModal.collection?.value = 
                            ownProfileVM
                                .UserDataList
                                .value
                                .userData!
                                .userDetails!
                                .userId
                                .toString();

                            unblock_viewModal.collectionOth?.value =
                              blockList_viewModal
                                .UserDataList
                                .value
                                .userBlockedList![index].userDetails!.userId.toString();

                            unblock_viewModal.blockUnblockApi();

                            BlockDataList.removeAt(index);
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.done,
                            color: Colors.green,
                          )),
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
}
