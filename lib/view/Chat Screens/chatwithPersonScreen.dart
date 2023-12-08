import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
import 'package:nauman/UI%20Components/color.dart';

import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/loadingScreen.dart';
import 'package:nauman/models/chatGPT/chatGPT_responseModal.dart';

import 'package:nauman/view/Chat%20Screens/audioCallScreen.dart';
import 'package:nauman/view/Chat%20Screens/chatListScreen.dart';
import 'package:nauman/view/Chat%20Screens/videoCallScreen.dart';
import 'package:nauman/view_models/controller/agora%20token/agora_controller.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final String photoUrl;
  final String name;
  final String userId;
  final String collectionName;
  final String ownPhoto;
  final String ownUserId;
  final String deviceToken;
  ChatScreen(
      {required this.ownPhoto,
      required this.ownUserId,
      required this.deviceToken,
      required this.userId,
      required this.name,
      required this.photoUrl,
      required this.roomId,
      required this.collectionName});
  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
 
  @override
  void initState() {
     screenStatus = true.obs;
      print("&&&&&&&&&&&&&&&&&&&&&&&&&&&");
      print(screenStatus.value);
      print("&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    fucn();
    WidgetsBinding.instance.addObserver(this);
    // TODO: implement initState
    super.initState();
  }

  bool messageExist = false;
 
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
     print("&&&&&&&&&&&&&&&&&&&&&&&&&&&");
      print(screenStatus.value);
      print("&&&&&&&&&&&&&&&&&&&&&&&&&&&");
      setStatus('online');
      if(currentRouteName == '/ChatScreen'){
        setonline();
        print(currentRouteName);
        print("********************************************************************************%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
      }
      else{
        print("!!!!!^^^^^^^^^^^^^^^^^^^^&&&&&&&&&&&&&&&&&&&&&");
      }
     
    } else {
      setStatus('offline');
     
     
      setOffline();
      
       screenStatus = false.obs;
      print("&&&&&&&&&&&&&&&&&&&&&&&&&&&");
      print(screenStatus.value);
      print("&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    }
  }

  setOffline() async {
    DocumentReference roomRef =
        _firestore.collection(widget.userId).doc(widget.roomId);
    await roomRef.update({"onScreen": false});
  }

  setonline() async {
    DocumentReference roomRef =
        _firestore.collection(widget.userId).doc(widget.roomId);
    await roomRef.update({"onScreen": true});
  }

  setStatus(String status) async {
    DocumentReference roomRef =
        _firestore.collection(widget.ownUserId).doc('Status');
    await roomRef.update({'status': status});
  }


  sendNotification(String body) async {
      var gettingDeviceTokenSnapshot = await _firestore.collection(widget.userId).doc('Device Token').get();
                                        var gettingDeviceToken = gettingDeviceTokenSnapshot.data();
                                        print(gettingDeviceToken!['device token']);
    var notificationContent = {
      'to': gettingDeviceToken['device token'],
     
      'notification': {
        'title': '${widget.collectionName}',
        'body': '${body}',
        "image": "${widget.ownPhoto}"
      },
      'data':{
        
        'what': 'chat',
       
      }
    };
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(notificationContent),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAAYVChC60:APA91bFM8uA66qxVhQ4iOIlbEtjqHYytrxrN2ydBChrX-gHbq1kR3RdQxQh763nWtLH2t0w2BXuY92ta-RNtUMN8OSZiT6DIh_CJ6Q_afwBeu0tKiRxOuJ3s9YYnx8nyGVDNz8DalR8q'
        }).then((value) {
      if (kDebugMode) {
        print(value.body.toString());
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
    });
  }

  updateValues(index) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var collectionRef = firestore
        .collection(widget.userId)
        .doc(widget.roomId)
        .collection('messages');
    collectionRef.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((DocumentSnapshot doc) {
        // print('Document ID: ${doc.id}');
        // You can also access the document data using doc.data()
        var fieldName = (doc.data() as Map<dynamic, dynamic>)['isRead'];
        if (fieldName == false) {
          _firestore
              .collection(widget.userId)
              .doc(widget.roomId)
              .collection('messages')
              .doc(doc.id)
              .update({"isRead": true});
        }
      });
    }).catchError((error) {
      print('Error getting documents: $error');
    });

    await _firestore
        .collection(widget.ownUserId)
        .doc(widget.roomId)
        .update({'newMsg': false});
  }

  String? photoDownloadUrl;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrJoinChatRoom(String roomId) async {
    DocumentReference roomRef =
        _firestore.collection(widget.ownUserId).doc(roomId);

    // Check if room exists
    DocumentSnapshot roomSnapshot = await roomRef.get();

    if (!roomSnapshot.exists) {
      await roomRef.set({
        'createdAt': FieldValue.serverTimestamp(),
        'userId': widget.userId,
        'userName': widget.name,
        'roomId': widget.roomId,
        'profilePhoto': widget.photoUrl,
        'newMsg': false,
        'onScreen': false,
        "noOfUnread": 0
        // Add other room metadata if needed
      });
    } else {
      await roomRef
          .update({'newMsg': false});
    }

    var newRef = _firestore.collection(widget.ownUserId).doc('Status');

    await newRef.set({'status': 'online'});

    var unreadRef = _firestore.collection(widget.ownUserId).doc('UnRead');
    var unreadRefsnapshot = await unreadRef.get();
    if (!unreadRefsnapshot.exists) {
      await unreadRef.set({'unRead': 0});
    } else {
      clearUnRead();
    }
    var deviceTokenRef = _firestore.collection(widget.ownUserId).doc('Device Token');
    var deviceTokenRefsnapshot = await deviceTokenRef.get();
    if (!deviceTokenRefsnapshot.exists) {
      await deviceTokenRef.set({'device token': fcmToken});
    } else {
      await deviceTokenRef.update({'device token': fcmToken});
    }
  
  }

  clearUnRead() async {
    // Values update
    // Getting UnRead value first
    DocumentSnapshot docSnapshotUnReadGetting =
        await _firestore.collection(widget.ownUserId).doc('UnRead').get();
    var UnReadGettingValue =
        docSnapshotUnReadGetting.data() as Map<String, dynamic>;
    var UnReadValue = UnReadGettingValue['unRead'];
    print("Unread current Value = ${UnReadValue}");
    // Getting no of unread value
    DocumentSnapshot docSnapshotNoOfUnreadGetting = await _firestore
        .collection(widget.ownUserId)
        .doc(widget.roomId)
        .get();
    var noOfUnreadGettingValue =
        docSnapshotNoOfUnreadGetting.data() as Map<String, dynamic>;
    var noOfUnreadValue = noOfUnreadGettingValue['noOfUnread'];
    print("No of unread current Value = ${noOfUnreadValue}");
    // Setting UnRead value
    var unreadUpDate =
        _firestore.collection(widget.ownUserId).doc('UnRead');
    unreadUpDate.update({"unRead": (UnReadValue - noOfUnreadValue)});

    // Setting NoOfUnead value
    var noOFUnreadUpdate =
        _firestore.collection(widget.ownUserId).doc(widget.roomId);
    noOFUnreadUpdate.update({"noOfUnread": 0});
    // Values update
  }

  // creating a chatroom of other user
  Future<void> createOrJoinChatRoomOther(String roomId) async {
    DocumentReference roomRef = _firestore.collection(widget.userId).doc(roomId);

    // Check if room exists
    DocumentSnapshot roomSnapshot = await roomRef.get();

    if (!roomSnapshot.exists) {
      await roomRef.set({
        'createdAt': FieldValue.serverTimestamp(),
        'userId': widget.ownUserId,
        'userName': widget.collectionName,
        'roomId': widget.roomId,
        'profilePhoto': widget.ownPhoto,
        'newMsg': false,
        'onScreen': true,
        
        "noOfUnread": 0
        // Add other room metadata if needed
      });
    } else {
      await roomRef.update({'onScreen': true});
    }
    var newRef = _firestore.collection(widget.userId).doc('Status');
    var roomsnap = await newRef.get();
    if (!roomsnap.exists) {
      await newRef.set({'status': 'offline'});
    }
    var unreadRef = _firestore.collection(widget.userId).doc('UnRead');
    var unreadRefsnapshot = await unreadRef.get();
    if (!unreadRefsnapshot.exists) {
      await unreadRef.set({'unRead': 0});
    }
    var deviceTokenRef = _firestore.collection(widget.userId).doc('Device Token');
    var deviceTokenRefsnapshot = await deviceTokenRef.get();
    if (!deviceTokenRefsnapshot.exists) {
      await deviceTokenRef.set({'device token': widget.deviceToken});
    }
    else{
      await deviceTokenRef.update({"device token": widget.deviceToken});
    }
  
  }

  Future<void> sendMessage(String roomId, String messageContent, String userId,
      String name, String sendBy) async {
    DocumentReference roomRef =
        _firestore.collection(widget.ownUserId).doc(roomId);
    CollectionReference messagesRef = roomRef.collection('messages');
    DateTime now = DateTime.now();

    // Convert the timestamp to a Firebase Timestamp object.
    Timestamp timestamp = Timestamp.fromDate(now);
    await messagesRef.add({
      'content': messageContent,
      'userId': userId,
      'userName': name,
      'timestamp': timestamp,
      'sendBy': sendBy,
      'text': 'true',
      'isRead': false
      // Add other message metadata if needed
    });

    await roomRef.update({
      'timestamp': timestamp,

      // Add other room metadata if needed
    });
  }

  Future<void> sendMessageOther(String roomId, String? messageContent,
      String ownUserId, String ownName, String sendTo) async {
    DocumentReference roomRef = _firestore.collection(widget.userId).doc(roomId);
    CollectionReference messagesRef = roomRef.collection('messages');
    DateTime now = DateTime.now();

    // Convert the timestamp to a Firebase Timestamp object.
    Timestamp timestamp = Timestamp.fromDate(now);
    await messagesRef.add({
      'content': messageContent,
      'userId': ownUserId,
      'userName': ownName,
      'timestamp': timestamp,
      'sendBy': sendTo,
      'text': 'true',
      'isRead': false
      // Add other message metadata if needed
    });

    await roomRef.update({
      'timestamp': timestamp,
      'newMsg': true

      // Add other room metadata if needed
    });
  }

  Future<void> sendPhoto(String roomId, String userId, String name,
      String sendBy, String photoUrl) async {
    DocumentReference roomRef =
        _firestore.collection(widget.ownUserId).doc(roomId);
    CollectionReference messagesRef = roomRef.collection('messages');
    DateTime now = DateTime.now();

    // Convert the timestamp to a Firebase Timestamp object.
    Timestamp timestamp = Timestamp.fromDate(now);
    await messagesRef.add({
      'userId': userId,
      'userName': name,
      'timestamp': timestamp,
      'sendBy': sendBy,
      'photo': photoUrl,
      'text': "false",
      'isRead': false
      // Add other message metadata if needed
    });

    await roomRef.update({
      'timestamp': timestamp,

      // Add other room metadata if needed
    });
  }

  Future<void> sendPhotoOther(String roomId, String ownUserId, String ownName,
      String sendTo, String? photoUrl) async {
    DocumentReference roomRef = _firestore.collection(widget.userId).doc(roomId);
    CollectionReference messagesRef = roomRef.collection('messages');
    DateTime now = DateTime.now();

    // Convert the timestamp to a Firebase Timestamp object.
    Timestamp timestamp = Timestamp.fromDate(now);
    await messagesRef.add({
      'userId': ownUserId,
      'userName': ownName,
      'timestamp': timestamp,
      'sendBy': sendTo,
      'photo': photoUrl,
      'text': "false",
      'isRead': false
      // Add other message metadata if needed
    });

    await roomRef.update({
      'timestamp': timestamp,
      'newMsg': true
      // Add other room metadata if needed
    });
  }

  Stream<QuerySnapshot> getMessagesStream(String roomId) {
    return _firestore
        .collection(widget.ownUserId)
        .doc(roomId)
        .collection(
          'messages',
        )
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getReadStream(String roomId) {
    return _firestore
        .collection(widget.userId)
        .doc(roomId)
        .collection(
          'messages',
        )
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  fucn() async {
    await createOrJoinChatRoom(widget.roomId);
    await createOrJoinChatRoomOther(widget.roomId);
  }

  bool isOnline = true;
  TextEditingController chatTextController = TextEditingController();

  bool showImoji = false;

  Future<String> uploadImageToFirebase(String imagePath) async {
    // Get a reference to Firebase Storage.
    FirebaseStorage storage = FirebaseStorage.instance;

    // Create a reference to the file you want to upload.
    Reference ref = storage.ref().child('images/${imagePath.split('/').last}');

    // Upload the file.
    UploadTask task = ref.putFile(File(imagePath));

    // Wait for the upload to complete.
    await task.whenComplete(() {});

    // Get the download URL for the uploaded file.
    String downloadUrl = await ref.getDownloadURL();

    return downloadUrl;
  }

  Future<String> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    String dUrl = '';

    if (pickedImage != null) {
      var compressedImageData = await FlutterImageCompress.compressWithFile(
        pickedImage.path,
        quality: 70, // Adjust the quality as needed (0 to 100)
      );

      File compressedImage = File(pickedImage.path)
        ..writeAsBytesSync(compressedImageData!);

      dUrl = await uploadImageToFirebase(compressedImage.path);

      sendPhoto(
          widget.roomId, widget.userId, widget.name, widget.ownUserId, dUrl);

      sendPhotoOther(widget.roomId, widget.ownUserId, widget.collectionName,
          widget.ownUserId, dUrl);
    }
    return dUrl;
  }

  Future<bool> isOnScreen() async {
    bool? value;
    DocumentSnapshot docSnapshot = await _firestore
        .collection(widget.ownUserId)
        .doc(widget.roomId)
        .get();
    if (docSnapshot.exists) {
      var data = docSnapshot.data()
          as Map<String, dynamic>; // Use a cast to specify the type
      // Now, you can access fields within the document
      var fieldValue = data['onScreen'];
      print('Field Value: $fieldValue');
      sendNotification(chatTextController.text);
    } else {
      print('Document does not exist');
    }
    return value!;
  }
 gettingSettingUnRead() async{
   DocumentSnapshot
                                          docSnapshotUnReadGetting =
                                          await _firestore
                                              .collection(widget.userId)
                                              .doc('UnRead')
                                              .get();

                                      if (docSnapshotUnReadGetting.exists) {
                                        var UnReadGettingValue =
                                            docSnapshotUnReadGetting.data()
                                                as Map<String, dynamic>;

                                        var UnReadValue =
                                            UnReadGettingValue['unRead'];
                                        print(
                                            "Unread current Value = ${UnReadValue}");
                                        // Setting UnRead value
                                        var unreadUpDate = _firestore
                                            .collection(widget.userId)
                                            .doc('UnRead');
                                        unreadUpDate.update(
                                            {"unRead": (UnReadValue + 1)});
                                      }
 }
                                     gettingSettingNoOfUnread()async{
                                         DocumentSnapshot
                                          docSnapshotNoOfUnreadGetting =
                                          await _firestore
                                              .collection(widget.userId)
                                              .doc(widget.roomId)
                                              .get();
                                      if (docSnapshotNoOfUnreadGetting.exists) {
                                        var noOfUnreadGettingValue =
                                            docSnapshotNoOfUnreadGetting.data()
                                                as Map<String, dynamic>;
                                        var noOfUnreadValue =
                                            noOfUnreadGettingValue[
                                                'noOfUnread'];
                                        print(
                                            "No of unread current Value = ${noOfUnreadValue}");
                                        // Setting NoOfUnead value
                                        var noOFUnreadUpdate = _firestore
                                            .collection(widget.userId)
                                            .doc(widget.roomId);
                                        noOFUnreadUpdate.update({
                                          "noOfUnread": (noOfUnreadValue + 1)
                                        });
                                      }

                                     }
  @override
  Widget build(BuildContext context) {
      print("Collection Name");
    print(widget.ownUserId);
    print(widget.userId);
      currentRouteName = ModalRoute.of(context)!.settings.name;
    print("%^^^^^^^^^^^^^^^^^^^^^");
    print(screenStatus.value);
    print(currentRouteName);
    print("%^^^^^^^^^^^^^^^^^^^^^");

    final height = Get.height;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          otherUserId: widget.userId,
          colName: widget.userId,
          roomId: widget.roomId,
          profilePhotoUrl: widget.photoUrl,
          username: widget.name,
          isOnline: isOnline,
          photoUrl: widget.photoUrl,
        ),
        bottomSheet: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextFormField(
                  controller: chatTextController,
                  cursorColor: Color(0xff596E79),
                  maxLines: 10,
                  minLines: 1,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35),
                          borderSide: BorderSide(color: Color(0xffC4C4C4))),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                      suffixIcon: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                              onTap: () {
                                ShowDialog(context);
                              },
                              child: Icon(
                                Icons.image_rounded,
                                size: 30,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 4, right: 4, bottom: 4),
                            child: InkWell(
                              onTap: () async {
                                if (chatTextController.value.text.isNotEmpty) {
                                  sendMessage(
                                      widget.roomId,
                                      chatTextController.text,
                                      widget.userId,
                                      widget.name,
                                      widget.ownUserId);

                                  sendMessageOther(
                                      widget.roomId,
                                      chatTextController.text,
                                      widget.ownUserId,
                                      widget.collectionName,
                                      widget.ownUserId);

                                  DocumentSnapshot docSnapshot =
                                      await _firestore
                                          .collection(widget.ownUserId)
                                          .doc(widget.roomId)
                                          .get();
                                  if (docSnapshot.exists) {
                                    var data = docSnapshot.data() as Map<String,
                                        dynamic>; // Use a cast to specify the type
                                    // Now, you can access fields within the document
                                    var fieldValue = data['onScreen'];
                                    print('Field Value: $fieldValue');
                                    if (fieldValue == false) {
                                     gettingSettingUnRead();
                                     gettingSettingNoOfUnread();
                                      // Getting UnRead value first
                                      // DocumentSnapshot
                                      //     docSnapshotUnReadGetting =
                                      //     await _firestore
                                      //         .collection(widget.name)
                                      //         .doc('UnRead')
                                      //         .get();

                                      // if (docSnapshotUnReadGetting.exists) {
                                      //   var UnReadGettingValue =
                                      //       docSnapshotUnReadGetting.data()
                                      //           as Map<String, dynamic>;

                                      //   var UnReadValue =
                                      //       UnReadGettingValue['unRead'];
                                      //   print(
                                      //       "Unread current Value = ${UnReadValue}");
                                      //   // Setting UnRead value
                                      //   var unreadUpDate = _firestore
                                      //       .collection(widget.name)
                                      //       .doc('UnRead');
                                      //   unreadUpDate.update(
                                      //       {"unRead": (UnReadValue + 1)});
                                      // }

                                      // Getting NoOfUnread value
                                      // DocumentSnapshot
                                      //     docSnapshotNoOfUnreadGetting =
                                      //     await _firestore
                                      //         .collection(widget.name)
                                      //         .doc(widget.roomId)
                                      //         .get();
                                      // if (docSnapshotNoOfUnreadGetting.exists) {
                                      //   var noOfUnreadGettingValue =
                                      //       docSnapshotNoOfUnreadGetting.data()
                                      //           as Map<String, dynamic>;
                                      //   var noOfUnreadValue =
                                      //       noOfUnreadGettingValue[
                                      //           'noOfUnread'];
                                      //   print(
                                      //       "No of unread current Value = ${noOfUnreadValue}");
                                      //   // Setting NoOfUnead value
                                      //   var noOFUnreadUpdate = _firestore
                                      //       .collection(widget.name)
                                      //       .doc(widget.roomId);
                                      //   noOFUnreadUpdate.update({
                                      //     "noOfUnread": (noOfUnreadValue + 1)
                                      //   });
                                      // }

                                      // Sending Notification
                                      sendNotification(chatTextController.text);
                                    }
                                  } else {
                                    print('Document does not exist');
                                  }
                                }

                                chatTextController.clear();
                              },
                              child: Icon(
                                Icons.arrow_circle_right_sharp,
                                size: 60,
                                color: Color(0xff596E79),
                              ),
                            ),
                          ),
                        ],
                      ),
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffB0B0B0)),
                      hintText: 'Type Message...'),
                ),
              ],
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: getMessagesStream(widget.roomId),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(
                    color: primaryDark,
                  ),
                );

              default:
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      if (data['sendBy'] != widget.ownUserId) {
                        print('not sent by me');

                        print(index);

                        updateValues(index);
                        // _firestore
                        //     .collection(widget.collectionName)
                        //     .doc(widget.roomId)
                        //     .collection('messages')
                        //     .doc(data.id)
                        //     .update({"isRead": 'true'});
                      }
                      // _firestore
                      //     .collection(widget.collectionName)
                      //     .doc(widget.roomId)
                      //     .update({'newMsg': false});
                      return data['sendBy'] == widget.ownUserId
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  data['text'] == 'false'
                                      ? InkWell(
                                          onTap: () {
                                            ChatListState().ShowPhotoDialog(
                                                context, data['photo']);
                                          },
                                          child: Container(
                                            width: Get.width * .5,
                                            child: CachedNetworkImage(
                                              imageUrl: data['photo'],
                                              fit: BoxFit.contain,
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(
                                                color: primaryDark,
                                                strokeWidth: 2,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          padding: EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                              color: Color(0xff50555C),
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(25),
                                                  bottomRight:
                                                      Radius.circular(25),
                                                  topLeft:
                                                      Radius.circular(25))),
                                          child: TextClass(
                                              size: 16,
                                              fontWeight: FontWeight.w400,
                                              title: data['content'],
                                              fontColor: Colors.white),
                                        ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          child: data['isRead'] == false
                                              ? Icon(
                                                  Icons.done_all_rounded,
                                                  size: 18,
                                                )
                                              : Icon(
                                                  Icons.done_all_rounded,
                                                  size: 18,
                                                  color: Colors.blue,
                                                )),

                                      // StreamBuilder(
                                      //   stream: getReadStream(widget.roomId),
                                      //   builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
                                      //     var data = snapshot.data?.docs[index];

                                      //      if(snapshot.connectionState == ConnectionState.waiting){
                                      //       return Container();
                                      //     }
                                      //   else   if (snapshot.connectionState ==
                                      //         ConnectionState.active) {
                                      //       return Container(
                                      //           child: data?['isRead'] ==
                                      //                   'false'
                                      //               ? Icon(
                                      //                   Icons.done_all_rounded,
                                      //                   size: 18,
                                      //                 )
                                      //               : Icon(
                                      //                   Icons.done_all_rounded,
                                      //                   size: 18,
                                      //                   color: Colors.blue,
                                      //                 ));
                                      //     }
                                      //     else {
                                      //       return CircularProgressIndicator();
                                      //     }
                                      //   },
                                      // ),
                                      SizedBox(
                                        width: Get.width * .025,
                                      ),
                                      TextClass(
                                          size: 12,
                                          fontWeight: FontWeight.w400,
                                          title: DateFormat('h:mm a').format(
                                              DateTime.parse(data['timestamp']
                                                  .toDate()
                                                  .toString())),
                                          fontColor: Color(0xff969696)),
                                    ],
                                  ),
                                  0 == index
                                      ? SizedBox(
                                          height: height * .11,
                                        )
                                      : SizedBox()
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  data['text'] == 'false'
                                      ? InkWell(
                                          onTap: () {
                                            ChatListState().ShowPhotoDialog(
                                                context, data['photo']);
                                          },
                                          child: Container(
                                            width: Get.width * .5,
                                            child: CachedNetworkImage(
                                              imageUrl: data['photo'],
                                              fit: BoxFit.contain,
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(
                                                color: primaryDark,
                                                strokeWidth: 2,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          padding: EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                              color: primaryDark,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(25),
                                                  bottomRight:
                                                      Radius.circular(25),
                                                  topRight:
                                                      Radius.circular(25))),
                                          child: TextClass(
                                              size: 16,
                                              fontWeight: FontWeight.w400,
                                              title: data['content'],
                                              fontColor: Colors.white),
                                        ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextClass(
                                      size: 12,
                                      fontWeight: FontWeight.w400,
                                      title: DateFormat('h:mm a').format(
                                          DateTime.parse(data['timestamp']
                                              .toDate()
                                              .toString())),
                                      fontColor: Color(0xff969696)),
                                  0 == index
                                      ? SizedBox(
                                          height: height * .11,
                                        )
                                      : SizedBox()
                                ],
                              ),
                            );
                    });
            }
          },
        ));
  }

  void ShowDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primaryDark,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          alignment: Alignment.center,
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      _pickImage(ImageSource.gallery);
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.image,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        TextClass(
                            size: 14,
                            fontWeight: FontWeight.w600,
                            title: 'Choose from Gallery',
                            fontColor: Colors.white)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      _pickImage(ImageSource.camera);
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        TextClass(
                            size: 14,
                            fontWeight: FontWeight.w600,
                            title: 'Click a Photo',
                            fontColor: Colors.white)
                      ],
                    ),
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

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String profilePhotoUrl;
  final String username;
  final bool isOnline;
  final String photoUrl;
  final String colName;
  final String roomId;
  final String otherUserId;
  @override
  Size get preferredSize => Size(Get.width, Get.height * .1);
  CustomAppBar(
      {
        required this.otherUserId,
        required this.photoUrl,
      required this.profilePhotoUrl,
      required this.colName,
      required this.roomId,
      required this.username,
      required this.isOnline});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    funct();
  }

  funct() async {}
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStatusStream() {
    return _firestore.collection(widget.colName).doc('Status').snapshots();
  }

  onScreenOffline() async {
    print(
        "calling it --------------------------------------------------------");
    print(widget.colName);
    print(widget.roomId);
    print(
        "calling it --------------------------------------------------------");

    DocumentReference roomRef =
        _firestore.collection(widget.colName).doc(widget.roomId);
    await roomRef.update({"onScreen": false});
  }

  Future<bool> backDemo() async {
    return true;
  }
var  agoraController = Get.put(AgoraTokenViewModal()); 
  @override
  Widget build(BuildContext context) {
    getStatusStream();
    final width = Get.width;
    final height = Get.height;
    return WillPopScope(
      onWillPop: () {
        currentRouteName = 'ddd';
        onScreenOffline();
        return backDemo();
      },
      child: SafeArea(
        child: Container(
          height: height * .08,
          width: width,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  onScreenOffline();
                  currentRouteName = "ddd";
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back_outlined,
                  size: 33,
                ),
              ),
              SizedBox(
                width: width * .04,
              ),
              GestureDetector(
                onTap: () {
                  ChatListState().ShowPhotoDialog(context, widget.photoUrl);
                },
                child: CachedNetworkImage(
                  imageUrl: widget.profilePhotoUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 55.0,
                    height: 55.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(
                    color: primaryDark,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(
                width: width * .04,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextClass(
                        fontColor: Colors.black,
                        fontWeight: FontWeight.w700,
                        size: 18,
                        title: widget.username),
                    StreamBuilder(
                      stream: getStatusStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          var data = snapshot.data?.data();
                          return TextClass(
                              fontColor: Colors.black,
                              fontWeight: FontWeight.w300,
                              size: 14,
                              title: data?['status'] ?? 'offline');
                        } else {
                          return Container(
                              width: 2,
                              height: 2,
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  // Get.to(() => AudioCall());
                   Get.to(()=>LoadingScreen());        
                  agoraController.calling_type.value = 'audio';
                  agoraController.room_id.value = widget.roomId.toString();
                  agoraController.other_user_id.value = widget.otherUserId.toString();
                  agoraController.AgoraTokenApi();
                },
                child: Icon(
                  Icons.phone_rounded,
                  size: 25,
                ),
              ),
              SizedBox(
                width: width * .03,
              ),
              InkWell(
                onTap: () {
                  // Get.to(() => VideoCall());
                  Get.to(()=>LoadingScreen());        
                  agoraController.calling_type.value = 'video';
                  agoraController.room_id.value = widget.roomId.toString();
                  agoraController.other_user_id.value = widget.otherUserId.toString();
                  agoraController.AgoraTokenApi();
                },
                child: Icon(
                  Icons.videocam_rounded,
                  size: 25,
                ),
              ),
              SizedBox(
                width: width * .02,
              ),
              InkWell(
                onTap: () {
                  ChatListState().ShowDialog(context);
                },
                child: Icon(
                  Icons.more_vert,
                  size: 25,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
