import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/view/Other%20Profile/otherProfile.dart';
import 'package:nauman/view_models/controller/notification_get_controller.dart/notification_get.dart';
import 'package:nauman/view_models/controller/notification_seen_control/notification_seen_controller.dart';
import 'package:nauman/view_models/controller/other_profile_view/other_profile_view_viewModel.dart';

class NotificationCard extends StatefulWidget {
  String time;
  String heading;
  String content;
  String isRead;
  int otherUserId;
  NotificationCard({
    required this.otherUserId,
    required this.time,
    required this.heading,
    required this.content,
    required this.isRead,
  });
  @override
  State<NotificationCard> createState() => NotificationCardState();
}

class NotificationCardState extends State<NotificationCard> {
  var otherProfileVM = Get.put(OtherProfileView_ViewModel());
  var notificationSeenVM = Get.put(NotificationSeenViewModel());
   var   notificationGetVM = Get.put(NotificationGetController());
  @override
  Widget build(BuildContext context) {
   
    return InkWell(
      onTap: () {
       notificationSeenVM.othere_user_id!.value = widget.otherUserId.toString();
       notificationSeenVM.about!.value = widget.heading.toString();
       notificationSeenVM.notificationSeenApi();
       otherProfileVM.user_id.value = widget.otherUserId.toString();

       Get.to(()=>OtherProfile(fromLink: false));
         notificationGetVM.NotificationGetAPI();
       
      },
      child: Container(
        decoration: BoxDecoration(
            color: widget.isRead == "success" ? Colors.white : Colors.grey.shade100,
            border: Border(bottom: BorderSide(color: Colors.brown.shade100))),
        child: Padding(
          padding: widget.isRead == "success"
              ? EdgeInsets.all(20)
              : EdgeInsets.only(left: 25, top: 20, bottom: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  widget.isRead == "success" ? NormalContainer() : StackedContainer()
                ],
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextClass(
                        size: 12,
                        fontWeight: FontWeight.w400,
                        title: widget.time,
                        fontColor: C6B6B6B),
                    SizedBox(
                      height: 10,
                    ),
                    TextClass(
                      size: 16,
                      fontWeight: FontWeight.w700,
                      title: widget.heading,
                      fontColor: Colors.black,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextClass(
                        size: 14,
                        fontWeight: FontWeight.w400,
                        title: widget.content,
                        fontColor: C6B6B6B,
                        align: TextAlign.start)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget NormalContainer() {
    return Container(
      // width: MediaQuery.of(context).size.width * .05,
      // height: MediaQuery.of(context).size.height * .05,
      width: 37,
      height: 37,
      decoration:
          BoxDecoration(color: E7E7E7, borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget StackedContainer() {
    return Stack(alignment: Alignment.topRight, children: [
      Container(
        // width: MediaQuery.of(context).size.width * .05,
        // height: MediaQuery.of(context).size.height * .05,
        width: 28,
        height: 28,
        decoration: BoxDecoration(
            color: AFC2B5, borderRadius: BorderRadius.circular(7)),
      ),
      CircleAvatar(
        backgroundColor: primaryDark,
        radius: 7,
      )
    ]);
  }

  // NotificationBottomSheet() async {
  //   return await showModalBottomSheet(
  //       isScrollControlled: true,
  //       useSafeArea: true,
  //       backgroundColor: Colors.white,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.vertical(
  //           top: Radius.circular(40.0),
  //         ),
  //       ),
  //       context: context,
  //       builder: (context) => Column(
  //             children: [
  //               // Top Vertical Line
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 20.0),
  //                 child: Container(
  //                   width: 200,
  //                   height: 8,
  //                   decoration: BoxDecoration(
  //                       color: AFC2B5, borderRadius: BorderRadius.circular(5)),
  //                 ),
  //               ),
  //               // Sizedbox between top design and Notification content
  //               SizedBox(
  //                 height: MediaQuery.of(context).size.width * .05,
  //               ),
  //               //  Notification Content  somewhat similar to Notifications list
  //               Container(
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                 ),
  //                 child: Padding(
  //                   padding:
  //                       // widget.isRead
  //                       //     ?
  //                       EdgeInsets.all(20),

  //                   // : EdgeInsets.only(
  //                   //     left: 25, top: 20, bottom: 20, right: 20),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Column(
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         children: [
  //                           SizedBox(
  //                             height: 10,
  //                           ),
  //                           widget.isRead
  //                               ? NormalContainer()
  //                               : StackedContainer()
  //                         ],
  //                       ),
  //                       SizedBox(width: 20),
  //                       Flexible(
  //                         child: Column(
  //                           mainAxisSize: MainAxisSize.min,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             TextClass(
  //                                 size: 12,
  //                                 fontWeight: FontWeight.w400,
  //                                 title: widget.time,
  //                                 fontColor: C6B6B6B),
  //                             SizedBox(
  //                               height: 10,
  //                             ),
  //                             TextClass(
  //                               size: 16,
  //                               fontWeight: FontWeight.w700,
  //                               title: widget.heading,
  //                               fontColor: Colors.black,
  //                             ),
  //                             SizedBox(
  //                               height: 10,
  //                             ),
  //                             TextClass(
  //                                 size: 12,
  //                                 fontWeight: FontWeight.w300,
  //                                 title:
  //                                     "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. ",
  //                                 fontColor: C6B6B6B,
  //                                 align: TextAlign.start)
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ));
  // }
}
