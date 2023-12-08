import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/components/general_exception.dart';
import 'package:nauman/UI%20Components/components/internet_exceptions_widget.dart';
import 'package:nauman/UI%20Components/notificationCard.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/data/response/status.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/view_models/controller/notification_get_controller.dart/notification_get.dart';

class NotificationsList extends StatefulWidget {
  @override
  State<NotificationsList> createState() => NotificationsListState();
}

class NotificationsListState extends State<NotificationsList> {
  String time = '5h ago';
  String heading = 'Verify your email';
  String content =
      'If you verify your email you will get proper updates on regular basis.';
   var   notificationGetVM = Get.put(NotificationGetController());
   @override
  void initState() {
    notificationGetVM.NotificationGetAPI();
      
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   
    final width = Get.width;
    final height = Get.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: TextClass(
            size: 20,
            fontWeight: FontWeight.w600,
            title: 'Notifications',
            fontColor: Colors.black),
        // actions: [
        //   Icon(Icons.more_vert),
        //   SizedBox(
        //     width: width * .02,
        //   )
        // ],
      ),
      body: 
        Obx(() {
                 
                    switch (notificationGetVM.rxRequestStatus.value) {
                      case Status.LOADING:
                        return Center(
                            child:
                                CircularProgressIndicator(color: primaryDark,));
                      case Status.ERROR:
                        if (notificationGetVM.error.value == 'No internet') {
                          return InterNetExceptionWidget(
                            onPress: () {
                            
                              notificationGetVM.refreshApi();
                            },
                          );
                        } else {
                          return GeneralExceptionWidget(onPress: () {
                           
                            notificationGetVM.refreshApi();
                          });
                        }
                      case Status.COMPLETED:
                      
                  
                return      ListView.builder(
                  itemCount: notificationGetVM.NotificationList.value.notificationList!.length,
                  itemBuilder: (context, index) {
                  return  NotificationCard(
                  content: notificationGetVM.NotificationList.value.notificationList![index].content.toString(), heading: notificationGetVM.NotificationList.value.notificationList![index].about.toString(), isRead:
                   notificationGetVM.NotificationList.value.notificationList![index].seenStatus.toString() , time: DateFormat('h:mm a').format(
                                              DateTime.parse(notificationGetVM.NotificationList.value.notificationList![index].timeStamp!
                                                  )),
                   otherUserId: notificationGetVM.NotificationList.value.notificationList![index].otherUserId! ,
                   
                   );
                  },
        //      
        );
   
                    }})
      
    );
  }
}
