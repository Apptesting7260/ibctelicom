import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
// import 'package:nauman/Chat%20Screens/audioCallScreen.dart';
// import 'package:nauman/Chat%20Screens/chatwithPersonScreen.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/components/internet_exceptions_widget.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/data/response/status.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/view/Chat%20Screens/chatwithPersonScreen.dart';
import 'package:nauman/view_models/controller/chat%20searching/chat_searching_controller.dart';
import 'package:nauman/view_models/controller/user_profile_view/user_profile_view_controller.dart';

class ChatList extends StatefulWidget {
  String collectionName;
  String ownPhoto;
  String ownUserId;

  ChatList(
      {required this.ownPhoto,
      required this.ownUserId,
      required this.collectionName});
  @override
  State<ChatList> createState() => ChatListState();
}

class ChatListState extends State<ChatList> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMessagesStream() {
    return firestore
        .collection(widget.ownUserId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // String time = '12:20 AM  |  12.08.2023';
  String chatProfileUrl = 'assets/images/messagePerson.png';
  String profileUsername = 'Ruby Ramon';
  // 3 vetical dot icon
  static const IconData ellipsis = IconData(0xf46a);
  RxBool show = false.obs;
  RxBool showChatterList = false.obs;
  var chatPersonGetVM = Get.put(ChatPersonGetViewModel());
  var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print("Collection Name");
    print(widget.ownUserId);
    final width = Get.width;
    final height = Get.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                if (show.value == false) {
                  Get.back();
                } else {
                  searchController.clear();
                  show.value = !show.value;
                  showChatterList.value = false;
                }
              },
              icon: Icon(Icons.arrow_back)),
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          title: Obx(
            () => show == false.obs
                ? TextClass(
                    size: 20,
                    fontWeight: FontWeight.w600,
                    title: 'Message',
                    fontColor: Colors.black)
                : TextFormField(
                    controller: searchController,
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (value) {
                      showChatterList.value = true;
                      chatPersonGetVM.other_user_name.value =
                          searchController.value.text;
                      chatPersonGetVM.ChatPersonGetApi();
                      print("rrerererere");
                    },
                    decoration: InputDecoration(hintText: 'Search...')),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  if (show.value == false) {
                    show.value = !show.value;
                  } else {
                    print("yarrrrrrrrrrrrrr");
                    chatPersonGetVM.other_user_name.value =
                        searchController.value.text;
                    chatPersonGetVM.ChatPersonGetApi();
                    showChatterList.value = true;
                  }
                },
                icon: Icon(Icons.search))
          ],
        ),
        // backgroundColor: Colors.,
        body: Obx(() {
          return showChatterList == true.obs
              ? chatPersonGetVM.rxRequestStatus == Status.LOADING
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : chatPersonGetVM.UserDataList.value.userList!.isEmpty
                      ? Center(
                          child: Container(
                            child: Text('No Profiles Found'),
                          ),
                        )
                      : ListView.builder(
                          itemCount: chatPersonGetVM
                              .UserDataList.value.userList!.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(10),
                                    leading: GestureDetector(
                                      onTap: () {
                                        // ShowPhotoDialog(
                                        //     context, data.get('profilePhoto'));
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: chatPersonGetVM.UserDataList
                                            .value.userList![index].proImgUrl
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
                                    ),
                                    title: GestureDetector(
                                      onTap: () async {
                                        // Values update
                                        // Getting UnRead value first
                                        // DocumentSnapshot docSnapshotUnReadGetting =
                                        //     await firestore
                                        //         .collection(widget.collectionName)
                                        //         .doc('UnRead')
                                        //         .get();
                                        // var UnReadGettingValue =
                                        //     docSnapshotUnReadGetting.data()
                                        //         as Map<String, dynamic>;
                                        // var UnReadValue = UnReadGettingValue['unRead'];
                                        // print("Unread current Value = ${UnReadValue}");

                                        // // Setting UnRead value
                                        // var unreadUpDate = firestore
                                        //     .collection(widget.collectionName)
                                        //     .doc('UnRead');
                                        // unreadUpDate.update({
                                        //   "unRead": (UnReadValue - data['noOfUnread'])
                                        // });

                                        // Setting NoOfUnead value
                                        // var noOFUnreadUpdate = firestore
                                        //     .collection(widget.collectionName)
                                        //     .doc(data.get('roomId'));
                                        // noOFUnreadUpdate.update({"noOfUnread": 0});
                                        // Values update
                                        // Get.to(() => ChatScreen(
                                        //       deviceToken: data.get('deviceToken'),
                                        //       ownPhoto: widget.ownPhoto,
                                        //       ownUserId: widget.ownUserId,
                                        //       collectionName: widget.collectionName,
                                        //       userId: data.get('userId'),
                                        //       roomId: data.get('roomId'),
                                        //       name: data.get('userName'),
                                        //       photoUrl: data.get('profilePhoto'),
                                        //     ));
                                        Get.to(() => ChatScreen(
                                            ownPhoto: widget.ownPhoto,
                                            ownUserId: widget.ownUserId,
                                            deviceToken: chatPersonGetVM
                                                .UserDataList
                                                .value
                                                .userList![index]
                                                .deviceToken
                                                .toString(),
                                            userId: chatPersonGetVM
                                                .UserDataList
                                                .value
                                                .userList![index]
                                                .userDetails!
                                                .userId
                                                .toString(),
                                            name: chatPersonGetVM.UserDataList.value.userList![index].userName
                                                .toString(),
                                            photoUrl: chatPersonGetVM
                                                .UserDataList
                                                .value
                                                .userList![index]
                                                .proImgUrl
                                                .toString(),
                                            roomId: chatPersonGetVM.UserDataList
                                                .value.userList![index].roomId
                                                .toString(),
                                            collectionName: widget.collectionName));
                                      },
                                      child: TextClass(
                                          fontColor: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          size: 16,
                                          title: chatPersonGetVM.UserDataList
                                              .value.userList![index].userName
                                              .toString()),
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        ShowDialog(context);
                                      },
                                      child: Icon(
                                        Icons.more_vert,
                                        color: D3D2D8,
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  color: Colors.black,
                                )
                              ],
                            );
                          },
                        )
              : StreamBuilder(
                  stream: getMessagesStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      return snapshot.data!.docs.isEmpty == false
                          ? ListView.builder(
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (context, index) {
                                var data = snapshot.data?.docs[index];
                                // .snapshots();
                                if (data!['newMsg'] == true) {
                                  unReadValue.value = unReadValue.value + 1;
                                  print("coming here");
                                }
                                print(
                                    "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                                print(unReadValue.value);
                                print(
                                    "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");

                                return Container(
                                  color: data['newMsg'] == true
                                      ? Colors.green.shade100
                                      : Colors.white,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(10),
                                    leading: GestureDetector(
                                      onTap: () {
                                        ShowPhotoDialog(
                                            context, data.get('profilePhoto'));
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: data.get('profilePhoto'),
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
                                    ),
                                    title: GestureDetector(
                                      onTap: () async {
                                        // Values update
                                        // Getting UnRead value first
                                        DocumentSnapshot
                                            docSnapshotUnReadGetting =
                                            await firestore
                                                .collection(
                                                    widget.ownUserId)
                                                .doc('UnRead')
                                                .get();
                                        var UnReadGettingValue =
                                            docSnapshotUnReadGetting.data()
                                                as Map<String, dynamic>;
                                        var UnReadValue =
                                            UnReadGettingValue['unRead'];
                                        print(
                                            "Unread current Value = ${UnReadValue}");

                                        // Setting UnRead value
                                        var unreadUpDate = firestore
                                            .collection(widget.ownUserId)
                                            .doc('UnRead');
                                        unreadUpDate.update({
                                          "unRead":
                                              (UnReadValue - data['noOfUnread'])
                                        });

                                        // Setting NoOfUnead value
                                        var noOFUnreadUpdate = firestore
                                            .collection(widget.ownUserId)
                                            .doc(data.get('roomId'));
                                        noOFUnreadUpdate
                                            .update({"noOfUnread": 0});
                                        // Values update
                                        print("***********************Start************************");
                                        print(data.get('userName'));
                                        var gettingDeviceTokenSnapshot = await firestore.collection(data.get('userId')).doc('Device Token').get();
                                        var gettingDeviceToken = gettingDeviceTokenSnapshot.data();
                                        print(gettingDeviceToken!['device token']);
                                        print("***********************End************************");
                                        Get.to(() => ChatScreen(
                                              deviceToken: gettingDeviceToken!['device token'],
                                                 
                                              ownPhoto: widget.ownPhoto,
                                              ownUserId: widget.ownUserId,
                                              collectionName:
                                                  widget.collectionName,
                                              userId: data.get('userId'),
                                              roomId: data.get('roomId'),
                                              name: data.get('userName'),
                                              photoUrl:
                                                  data.get('profilePhoto'),
                                            ));
                                      },
                                      child: TextClass(
                                          fontColor: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          size: 16,
                                          title: data.get('userName')),
                                    ),
                                    subtitle: GestureDetector(
                                      
                                      onTap: () async{
                                          print("***********************Start************************");
                                        print(data.get('userName'));
                                        var gettingDeviceTokenSnapshot = await firestore.collection(data.get('userId')).doc('Device Token').get();
                                        var gettingDeviceToken = gettingDeviceTokenSnapshot.data();
                                        print(gettingDeviceToken!['device token']);
                                        print("***********************End************************");
                                        Get.to(() => ChatScreen(
                                              deviceToken:
                                                 gettingDeviceToken!['device token'],
                                              ownPhoto: widget.ownPhoto,
                                              ownUserId: widget.ownUserId,
                                              collectionName:
                                                  widget.collectionName,
                                              userId: data.get('userId'),
                                              roomId: data.get('roomId'),
                                              name: data.get('userName'),
                                              photoUrl:
                                                  data.get('profilePhoto'),
                                            ));
                                      },
                                      child: TextClass(
                                          size: 12,
                                          fontWeight: FontWeight.w500,
                                          title:
                                              "${DateFormat('h:mm a').format(DateTime.parse(data['timestamp'].toDate().toString()))} | ${DateFormat('MM-dd-yyyy').format(DateTime.parse(data['timestamp'].toDate().toString()))}",
                                          fontColor: C888888),
                                    ),
                                    trailing: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        data['newMsg'] == true
                                            ? CircleAvatar(
                                                radius: Get.height*.013,
                                                backgroundColor: primaryDark,
                                                child: Text(data['noOfUnread']
                                                    .toString(),style: TextStyle(color: Colors.white),),
                                              )
                                            : Container(),
                                        GestureDetector(
                                          onTap: () {
                                            ShowDialog(context);
                                          },
                                          child: Icon(
                                            Icons.more_vert,
                                            color: D3D2D8,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Lottie.network(
                                  'https://lottie.host/d268bd36-eeba-4171-9bab-15f597337e76/CHQVV1yRcE.json'),
                            );
                    } else {
                      return Center(
                          child: CircularProgressIndicator(
                        color: primaryDark,
                      ));
                    }
                  },
                );
        }));
  }

  void ShowDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          alignment: Alignment.center,
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.block),
                      TextClass(
                          size: 14,
                          fontWeight: FontWeight.w600,
                          title: '  Block',
                          fontColor: Colors.black)
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Icon(Icons.outlined_flag),
                      TextClass(
                          size: 14,
                          fontWeight: FontWeight.w600,
                          title: '  Report',
                          fontColor: Colors.black)
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

  void ShowPhotoDialog(BuildContext context, String photoUrl) {
    showDialog(
      context: context,
      // bbc
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          content: CachedNetworkImage(
            imageUrl: photoUrl,
            fit: BoxFit.contain,
            placeholder: (context, url) => CircularProgressIndicator(
              color: primaryDark,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        );
      },
    );
  }
}
