
import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCall extends StatefulWidget {
 final  String token ;
  final String channelName ;
  final int uid ;
  VideoCall({
required this.channelName,
required this.token,
required this.uid
  });
  @override
  State<VideoCall> createState() => VideoCallState();
}



class VideoCallState extends State<VideoCall> {
  @override
void initState() {
   super.initState();
    setupVideoSDKEngine();
 
}
   String appId = "048672a2bddb40f49ee58938c779e4ae";
  //  String channelName = "106110";

  
  // / uid of the local user
    bool ourJoin = false;
    int? _remoteUid ; // uid of the remote user
    bool _isJoined = false; // Indicates if the local user has joined the channel
    late RtcEngine agoraEngine; 
   Future<void> setupVideoSDKEngine() async {   
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize( RtcEngineContext(       
    appId: appId

    ));

    await agoraEngine.enableVideo();
    join();
    // Register the event handler
    agoraEngine.registerEventHandler(
    RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        showMessage("Local user uid:${connection.localUid} joined the channel");
        setState(() {
            _isJoined = true;
        });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        showMessage("Remote user uid:$remoteUid joined the channel");
        setState(() {
            _remoteUid = remoteUid;
        });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
        showMessage("Remote user uid:$remoteUid left the channel");
        setState(() {
            _remoteUid = null;
        });
        },
    ),
    );
}

    showMessage(String message) {
        Utils.toastMessageCenter(message, false);
    }
  // @override
  // void initState() {
  //   super.initState();
  //   setupVideoSDKEngine();
   
  // }
@override
void dispose() async {
  super.dispose();
    await agoraEngine.leaveChannel();
    agoraEngine.release();

}
  void  join() async {
    await agoraEngine.startPreview();

    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
        token: widget.token,
        // token: "007eJxTYGD4cOnDees0rxifk5MsXXIu3PtkYn1IhunbBwEf2+j6jccVGAxMLMzMjRKNklJSkkwM0kwsU1NNLSyNLZLNzS1TTRJTN1bGpDYEMjLs/V3OysgAgSA+G4OhgZmhoQEDAwDGLyAk",
        
        channelId: widget.channelName,
        options: options,
        uid: 0,
    );
   
}

 void leave() {
    setState(() {
    _isJoined = false;
    _remoteUid = null;
    });
    agoraEngine.leaveChannel();
}
  Widget _localPreview() {
    if (_isJoined) {
    return AgoraVideoView(
        controller: VideoViewController(
        rtcEngine: agoraEngine,
        canvas: VideoCanvas(uid: 0),
        ),
    );
    } else {
    return const Text(
        'Join a channel',
        textAlign: TextAlign.center,
    );
    }
}
bool otherusercutcall = false;
// Display remote user's video
Widget _remoteVideo() {
    if (_remoteUid != null) {
      otherusercutcall = true;
    return AgoraVideoView(
        controller: VideoViewController.remote(
        rtcEngine: agoraEngine,
        canvas: VideoCanvas(uid: _remoteUid),
        connection: RtcConnection(channelId: widget.channelName),
        ),
    );
    } else {
        String msg = '';
        if (_isJoined) msg = 'Calling...';
        if(otherusercutcall == true){
          print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
          print(otherusercutcall);

            _isJoined ? leave() : null;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
          });



        }
        return Text(
        msg,
        textAlign: TextAlign.center,
    );
    }
}


  @override
  Widget build(BuildContext context) {
    print(widget.channelName);
    print(widget.uid);
    print(widget.token);

    final width = Get.width;
    final height = Get.height;
    

    
    return Scaffold(
      body:
     
       SafeArea(
          child: Stack(
        children: [
          // Image.asset(
          //   'assets/images/videoImg.png',
          //   fit: BoxFit.cover,
          //   width: width,
          //   height: height,
          // ),
           Container(
              width: width,
              height: height,
                // decoration: BoxDecoration(border: Border.all()),
                child: Center(child: _remoteVideo()),
            ),
          // back arrow icon button
          // IconButton(
          //     icon: Icon(Icons.arrow_back_outlined),
          //     onPressed: () => Get.back()),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
              child: Container(
                width: width,
                height: height * .085,
                decoration: BoxDecoration(
                    color: primaryDark,
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(

                      // _isJoined ? null : () => {join()},
                      child: Icon(
                        Icons.mic,
                        color: Colors.white,
                      ),
                    ),
                    // Icon(
                    //   Icons.camera_alt_rounded,
                    //   color: Colors.white,
                    // ),
                    SvgPicture.asset('assets/images/videoCamera.svg'),
                   
                    Container(
                      height: height * .05,
                      width: width * .3,
                      decoration: BoxDecoration(
                          color: ED0C0CAD,
                          borderRadius: BorderRadius.circular(20)),
                      child: InkWell(
                        onTap: (){
                          _isJoined ? leave() : null;
  Get.back();
                        },
                          // _isJoined ? () => {leave()} : null,
                        
                     
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.call_end,
                              color: ED0C0C,
                            ),
                            TextClass(
                                size: 16,
                                fontWeight: FontWeight.w600,
                                title: 'End',
                                fontColor: E7ECED)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: height * .75,
            left: width * .6,
            child: 
          
            Container(
              width: width * .35,
              height: height * .18,
              child: Center(child: _localPreview()),
             
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                   color: Colors.grey.shade100
                  ),
            ),
          ),
        ],
      )),
    );
  }
  
}

