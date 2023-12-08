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
import 'package:nauman/view_models/controller/other_profile_view/other_profile_view_viewModel.dart';
import 'package:nauman/view_models/controller/request_list/request_list_controller.dart';
import 'package:nauman/view_models/controller/request_remove/request_remove_controller.dart';

class OutgoingRequest extends StatefulWidget {
  RequestListViewModel outgoingRequestList;
  OutgoingRequest({required this.outgoingRequestList});
  @override
  State<OutgoingRequest> createState() => OutgoingRequestState();
}

class OutgoingRequestState extends State<OutgoingRequest> {
  var requestRemove_viewModal = Get.put(RequestRemoveViewModel());
  var otherProfile_viewModal = Get.put(OtherProfileView_ViewModel());
  ScrollController outgoingController = ScrollController();
  @override
  void initState() {
    outgoingController.addListener(() { 
     if(outgoingController.position.maxScrollExtent == outgoingController.offset){
      fetch();
     }

    });
    super.initState();
  }
  fetch(){
    if(callOutgoingPagination.value == true){
      print('calling out');
      widget.outgoingRequestList.page_no.value = pageOutgoing.toString();
      widget.outgoingRequestList.RequestListApi(true);
      callOutgoingPagination.value = false;
    }
    else{
      print('not callin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() {
          switch (widget.outgoingRequestList.rxRequestStatus.value) {
            case Status.LOADING:
              return Center(
                  child: CircularProgressIndicator(
                color: primaryDark,
              ));
            case Status.ERROR:
              if (widget.outgoingRequestList.error.value == 'No internet') {
                return InterNetExceptionWidget(
                  onPress: () {
                     pageOutgoing.value = 1;
                        pageIncoming.value = 1;
                        callOutgoingPagination.value = true;
                        callIncomingPagination.value = true;
                        widget.outgoingRequestList.page_no.value = '1';
                    widget.outgoingRequestList.refreshApi();
                  },
                );
              } else {
                return GeneralExceptionWidget(onPress: () {
                   pageOutgoing.value = 1;
                        pageIncoming.value = 1;
                        callOutgoingPagination.value = true;
                        callIncomingPagination.value = true;
                        widget.outgoingRequestList.page_no.value = '1';
                  widget.outgoingRequestList.refreshApi();
                });
              }
            case Status.COMPLETED:
              return
              //  widget.outgoingRequestList.UserDataList.value
              //             .outgoingRequests ==
              //         null
              OutgoingDataList.isEmpty
                  ? RefreshIndicator(
                      backgroundColor: Colors.white,
                      color: primaryDark,
                      onRefresh: () async {
                        pageOutgoing.value = 1;
                        pageIncoming.value = 1;
                        callOutgoingPagination.value = true;
                        callIncomingPagination.value = true;
                        widget.outgoingRequestList.page_no.value = '1';
                         widget.outgoingRequestList.RequestListApi(false);
                      },
                      child: SingleChildScrollView(
                      
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              Lottie.network(
                'https://lottie.host/d268bd36-eeba-4171-9bab-15f597337e76/CHQVV1yRcE.json'),
                              Container(
                                  height: Get.height * .4,
                            width: Get.width,
                                child: TextClass(
                                          size: 16,
                                          fontWeight: FontWeight.w600,
                                          align: TextAlign.center,
                                          title:
                                              "You don't have any outgoing request.",
                                          fontColor: primaryDark),
                              )
                                    ] ),
                      ),
                    )
                  : RefreshIndicator(
                      backgroundColor: Colors.white,
                      color: primaryDark,
                      onRefresh: () async {
                         pageOutgoing.value = 1;
                        pageIncoming.value = 1;
                        callOutgoingPagination.value = true;
                        callIncomingPagination.value = true;
                        widget.outgoingRequestList.page_no.value = '1';
                         widget.outgoingRequestList.RequestListApi(false);
                      },
                      child: ListView.builder(
                         physics: AlwaysScrollableScrollPhysics(),
                       
                        controller: outgoingController,
                        itemCount:
                      
                        OutgoingDataList.length+1,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            otherProfile_viewModal.user_id = 
                           OutgoingDataList[index]
                                .userDetails!
                                .userId!
                                .toString()
                                .obs;
                            Get.to(()=>OtherProfile(fromLink: false,));
                          },
                          child:
                          
                          
                           Column(
                            children: [
                              SizedBox(
                                height: Get.height * .03,
                              ),
                              index == OutgoingDataList.length  ?
                              
                              callOutgoingPagination.value == true ? 
                              Center(child: CircularProgressIndicator(color: primaryDark),)
                               :
                              Chip(label: TextClass(size: 14, fontWeight: FontWeight.w600, title: 'No more profiles!', fontColor: primaryDark))
                               :
                              ListTile(
                                  leading: CachedNetworkImage(
                                    imageUrl: OutgoingDataList[index]
                                        .proImgUrl
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
                                      title:OutgoingDataList[index]
                                          .userName!,
                                      fontColor: primaryDark),
                                  subtitle: TextClass(
                                      size: 11,
                                      fontWeight: FontWeight.w400,
                                      title: OutgoingDataList[index]
                                          .userDetails!
                                          .profession!,
                                      fontColor: Colors.black),
                                  trailing: ElevatedButton(
                                      onPressed: () {
                                        // int id = widget
                                        //     .outgoingRequestList
                                        //     .UserDataList
                                        //     .value
                                        //     .outgoingRequests![index]
                                        //     .userDetails!
                                        //     .userId!;

                                        // requestRemove_viewModal
                                        //         .request_from_id =
                                        //     id.toString().obs;
                                        // print(requestRemove_viewModal
                                        //     .request_from_id);
                                        // requestRemove_viewModal
                                        //     .requestRemoveApi();

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
                                          title: 'Revoke Request',
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
                            title: "Are you sure you want to revoke request.",
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
                            int id = OutgoingDataList[index]
                                            .userDetails!
                                            .userId!;

                                        requestRemove_viewModal
                                                .request_from_id =
                                            id.toString().obs;
                                        print(requestRemove_viewModal
                                            .request_from_id);
                                            OutgoingDataList.removeAt(index);
                                        requestRemove_viewModal
                                            .requestRemoveApi();
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
