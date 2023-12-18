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
import 'package:nauman/view_models/controller/my_connections/my_connections_controller.dart';
import 'package:nauman/view_models/controller/other_profile_view/other_profile_view_viewModel.dart';

import 'package:nauman/view_models/controller/request_remove/request_remove_controller.dart';

class MyConnections extends StatefulWidget {
  @override
  State<MyConnections> createState() => MyConnectionsState();
}

class MyConnectionsState extends State<MyConnections> {
  var myConnections_viewModal = Get.put(MyConnectionsViewModel());
  var otherProfileViewModel = Get.put(OtherProfileView_ViewModel());
  var requestRemove_viewModal = Get.put(RequestRemoveViewModel());
  ScrollController connectionController = ScrollController();
  @override
  void initState() {
    myConnections_viewModal.MyConnectionsApi(false);
    connectionController.addListener(() {
      if(  connectionController.position.maxScrollExtent  == connectionController.offset){
        fetch();
      }
     });
    // TODO: implement initState
    super.initState();
  }
 
  fetch(){
    if(callConnectionPagination.value == true){
      myConnections_viewModal.page_no.value = pageConnection.toString();
      myConnections_viewModal.MyConnectionsApi(true);
      callConnectionPagination.value = false;
    }
    else{
      print('not calling');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(onPressed: () {
            pageConnection.value = 1;
            callConnectionPagination.value = true;
            myConnections_viewModal.page_no.value = '1';
            Get.back();

          }, icon: Icon(Icons.arrow_back_outlined)),
          title: Text('My Connections'),
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
        ),
        body: Obx(() {
          switch (myConnections_viewModal.rxRequestStatus.value) {
            case Status.LOADING:
              return Center(
                  child: Lottie.asset('assets/images/loadingAni.json'));
            case Status.ERROR:
              if (myConnections_viewModal.error.value == 'No internet') {
                return InterNetExceptionWidget(
                  onPress: () {
                    myConnections_viewModal.refreshApi();
                  },
                );
              } else {
                return GeneralExceptionWidget(onPress: () {
                  myConnections_viewModal.refreshApi();
                });
              }
            case Status.COMPLETED:
              return 
              // myConnections_viewModal
              //         .UserDataList.value.userConnection!.isEmpty
              ConnectionDataList.isEmpty
                  ? 
                 RefreshIndicator(
                 color: primaryDark,
                    onRefresh: () async{
                      pageConnection.value = 1;
                      callConnectionPagination.value = true;
                      ConnectionDataList.clear();
                      myConnections_viewModal.page_no = '1'.obs;
                      myConnections_viewModal.refreshApi();
                    },
                   child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                     child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  Lottie.network(
                                 'https://lottie.host/a496b982-58c1-49ca-98ee-ced17be677d3/qzJ1v73WFx.json'),
                                  Container(
                                      height: Get.height * .4,
                                width: Get.width,
                                    child: TextClass(
                                              size: 16,
                                              fontWeight: FontWeight.w600,
                                              align: TextAlign.center,
                                              title:
                                                  "You don't have any connections right now.",
                                              fontColor: primaryDark),
                                  )
                                        ] ),
                   ),
                 )
                  : RefreshIndicator(
                    color: primaryDark,
                    onRefresh: () async{
                      pageConnection.value = 1;
                      callConnectionPagination.value = true;
                      ConnectionDataList.clear();
                      myConnections_viewModal.page_no = '1'.obs;
                      myConnections_viewModal.refreshApi();
                    },
                    child: ListView.builder(
                       physics: AlwaysScrollableScrollPhysics(),
                      controller: connectionController,
                        itemCount: 
                       ConnectionDataList.length,
                        itemBuilder: (context, index) {
                          print(ConnectionDataList[index].block_status);
                           return InkWell(
                          onTap: () {
                          
                            ConnectionDataList[index].block_status == 0 ?
                            (
                            otherProfileViewModel.user_id.value =
                              ConnectionDataList[index].userDetails!.userId
                                    .toString(),
                             Get.to(()=>OtherProfile(fromLink: false,))
                            ) :
                            (showDialog(context: context, builder: (context) => AlertDialog(title: TextClass(size: 15, fontWeight: FontWeight.w500, title: 'You are blocked by ${ConnectionDataList[index].userName}', fontColor: Colors.red),),));
                          },
                          child:
                          
                           Container(
                            width: Get.width,
                            color:   ConnectionDataList[index].block_status == 0 ? Colors.transparent:Colors.grey.shade400,
                             child: Column(
                              children: [
                                SizedBox(
                                  height: Get.height * .03,
                                ),
                                index == ConnectionDataList.length ? 
                              callConnectionPagination.value == true ?
                                  CircularProgressIndicator(color: primaryDark,)
                              :
                              Center(child: Chip(label: TextClass(size: 14, fontWeight: FontWeight.w600, title: 'No more profiles!', fontColor: primaryDark)),)
                                :
                                ListTile(
                                    leading: CachedNetworkImage(
                                      imageUrl: ConnectionDataList[index].proImgUrl
                                          .toString(),
                                      imageBuilder: (context, imageProvider) =>
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
                                        title:ConnectionDataList[index].userName!,
                                        fontColor: primaryDark),
                                    subtitle: TextClass(
                                        size: 11,
                                        fontWeight: FontWeight.w400,
                                        title: ConnectionDataList[index].userDetails!.profession!
                                           
                             ,
                                        fontColor: Colors.black),
                                    trailing: ElevatedButton(
                                        onPressed: () {
                                      
                                          ConfirmDialog(index);
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    Colors.red),
                                            shape: MaterialStatePropertyAll(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(20))))),
                                        child: TextClass(
                                            size: 8,
                                            fontWeight: FontWeight.w400,
                                            title: 'Remove',
                                            fontColor: Colors.white))),
                              ],
                                                       ),
                           ),
                        );}
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
                            title: "Are you sure you want to remove connection.",
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
                          child: Icon(Icons.close)),
                      SizedBox(
                        width: 30,
                      ),
                      InkWell(
                          onTap: () {
                            int id = 
                            ConnectionDataList[index].userDetails!.userId!;

                            requestRemove_viewModal.request_from_id =
                                id.toString().obs;
                            print(requestRemove_viewModal.request_from_id);
                            requestRemove_viewModal.requestRemoveApi();
                            ConnectionDataList.removeAt(index);
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
}
