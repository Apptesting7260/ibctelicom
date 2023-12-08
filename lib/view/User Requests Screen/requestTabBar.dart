import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/textDesign.dart';

import 'package:nauman/view/User%20Requests%20Screen/incomingRequest.dart';
import 'package:nauman/view/User%20Requests%20Screen/outgoingRequest.dart';
import 'package:nauman/view_models/controller/request_list/request_list_controller.dart';

class RequestTabBar extends StatefulWidget {
  @override
  State<RequestTabBar> createState() => RequestTabBarState();
}

class RequestTabBarState extends State<RequestTabBar>
    with SingleTickerProviderStateMixin {
  var requestList = Get.put(RequestListViewModel());
  @override
  void initState() {
    // TODO: implement initState
    // requestList.RequestListApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final widht = Get.width;
    final height = Get.height;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            title: TextClass(
                size: 20,
                fontWeight: FontWeight.w600,
                title: "Requests",
                fontColor: Colors.black),
            bottom: TabBar(
              
              padding: EdgeInsets.symmetric(horizontal: 20),
            indicatorSize: TabBarIndicatorSize.tab,
              onTap: (value) {
                print('Hello $value');
              },
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
                Tab(child: Text('Incoming')),
                Tab(child: Text('Outgoing')),
              ],
            ),
          ),
          body: TabBarView(
            // controller: _tabController,
            children: [
              IncomingRequest(incomingRequestList: requestList),
              OutgoingRequest(
                outgoingRequestList: requestList,
              ),
            ],
          ),
        ));
  }
}
