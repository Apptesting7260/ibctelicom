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
import 'package:nauman/view_models/controller/request%20confirm/request_confim_controller.dart';
import 'package:nauman/view_models/controller/request_list/request_list_controller.dart';
import 'package:nauman/view_models/controller/request_remove/request_remove_controller.dart';

class IncomingRequest extends StatefulWidget {
  RequestListViewModel incomingRequestList;
  IncomingRequest({required this.incomingRequestList});
  @override
  State<IncomingRequest> createState() => IncomingRequestState();
}

class IncomingRequestState extends State<IncomingRequest> {
  var requestRemove_viewModal = Get.put(RequestRemoveViewModel());
  var requestConfirm_viewModal = Get.put(RequestConfirmViewModel());
  var otherProfile_viewModal = Get.put(OtherProfileView_ViewModel());
  ScrollController incomingController = ScrollController();
  @override
  void initState() {
    incomingController.addListener(() {
      if(incomingController.position.maxScrollExtent == incomingController.offset){
        fetch();
      }
     });
    // incomingRequestList.RequestListApi();
    // TODO: implement initState
    widget.incomingRequestList;
    super.initState();
  }
  fetch(){
    if(callIncomingPagination.value == true){
      print('calling in');
      widget.incomingRequestList.page_no.value = pageIncoming.toString();
      widget.incomingRequestList.RequestListApi(true);
      callIncomingPagination.value = false;
    }
    else{
      print('not calling');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() {
          switch (widget.incomingRequestList.rxRequestStatus.value) {
            case Status.LOADING:
              return Center(
                  child: CircularProgressIndicator(
                color: primaryDark,
              ));
            case Status.ERROR:
              if (widget.incomingRequestList.error.value == 'No internet') {
                return InterNetExceptionWidget(
                  onPress: () {
                       pageOutgoing.value = 1;
                        pageIncoming.value = 1;
                        callOutgoingPagination.value = true;
                        callIncomingPagination.value = true;
                        widget.incomingRequestList.page_no.value = '1';
                    widget.incomingRequestList.refreshApi();
                  },
                );
              } else {
                return GeneralExceptionWidget(onPress: () {
                     pageOutgoing.value = 1;
                        pageIncoming.value = 1;
                        callOutgoingPagination.value = true;
                        callIncomingPagination.value = true;
                        widget.incomingRequestList.page_no.value = '1';
                  widget.incomingRequestList.refreshApi();
                });
              }
            case Status.COMPLETED:
              return IncomingDataList.isEmpty
                  ? RefreshIndicator(
                      backgroundColor: Colors.white,
                      color: primaryDark,
                      onRefresh: () async {
                         pageOutgoing.value = 1;
                        pageIncoming.value = 1;
                        callOutgoingPagination.value = true;
                        callIncomingPagination.value = true;
                        widget.incomingRequestList.page_no.value = '1';
                        return widget.incomingRequestList.RequestListApi(false);
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
                                              "You don't have any incoming request.",
                                          fontColor: primaryDark),
                              )
                                    ] ),
                      ),
                    )
                  :
                   RefreshIndicator(
                      backgroundColor: Colors.white,
                      color: primaryDark,
                      onRefresh: () async {
                            pageOutgoing.value = 1;
                        pageIncoming.value = 1;
                        callOutgoingPagination.value = true;
                        callIncomingPagination.value = true;
                        widget.incomingRequestList.page_no.value = '1';
                         widget.incomingRequestList.RequestListApi(false);
                      },
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                       
                        controller: incomingController,
                        itemCount: 
                        IncomingDataList.length+1 ,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            otherProfile_viewModal.user_id = IncomingDataList[index]
                                .userDetails!
                                .userId!
                                .toString()
                                .obs;
                           Get.to(()=>OtherProfile(fromLink: false,));
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: Get.height * .03,
                              ),
                                index == IncomingDataList.length  ?
                              
                              callIncomingPagination.value == true ? 
                              Center(child: CircularProgressIndicator(color: primaryDark),)
                               :
                              Chip(
                                label: TextClass(size: 14, fontWeight: FontWeight.w600, title: 'No more profiles!', fontColor: primaryDark))
                               :
                              ListTile(
                                leading: CachedNetworkImage(
                                  imageUrl: IncomingDataList[index]
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
                                    title:IncomingDataList[index]
                                        .userName!,
                                    fontColor: primaryDark),
                                subtitle: TextClass(
                                    size: 11,
                                    fontWeight: FontWeight.w400,
                                    title: IncomingDataList[index]
                                        .userDetails!
                                        .profession!,
                                    fontColor: Colors.black),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          int id =IncomingDataList[index]
                                              .userDetails!
                                              .userId!;

                                          requestConfirm_viewModal
                                                  .request_from_id =
                                              id.toString().obs;
                                          print(requestConfirm_viewModal
                                              .request_from_id);
                                              IncomingDataList.removeAt(index);
                                          requestConfirm_viewModal
                                              .requestConfirmApi();
                                        },
                                        icon: Icon(
                                          Icons.done_outline_outlined,
                                          color: primaryDark,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          int id = IncomingDataList[index]
                                              .userDetails!
                                              .userId!;

                                          requestRemove_viewModal
                                                  .request_from_id =
                                              id.toString().obs;
                                          print(requestRemove_viewModal
                                              .request_from_id);
                                                IncomingDataList.removeAt(index);
                                          requestRemove_viewModal
                                              .requestRemoveApi();
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
          }
        }));
  }
}
