import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:nauman/Chat%20Screens/chatListScreen.dart';
// import 'package:nauman/Chat%20Screens/chatwithPersonScreen.dart';
// import 'package:nauman/HomeScreens/homePage.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioCall extends StatefulWidget {
  final  String token ;
  final String channelName ;
  final int uid ;
  AudioCall({
required this.channelName,
required this.token,
required this.uid
  });
  @override
  State<AudioCall> createState() => AudioCallState();
}

class AudioCallState extends State<AudioCall> {
  String appId = "048672a2bddb40f49ee58938c779e4ae";
  // String channelName = "abc";
  // String token =
  //     "007eJxTYMg5wsFzOeaqWGpWcHoPT3PNmaZnxRumWLifqsp96mHL/VGBwcDEwszcKNEoKSUlycQgzcQyNdXUwtLYItnc3DLVJDF1na1TqoIMA8OzbZwMjFAI4jMzJCYlMzIYAADu/x0i";

  int uid = 0; // uid of the local user

  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold

  showMessage(String message) {
    // scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
    //   content: Text(message),
    // ));
    Utils.toastMessageCenter(message, false);
  }

  Future<void> setupVoiceSDKEngine() async {
    // retrieve or request microphone permission
    await [Permission.microphone].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(RtcEngineContext(appId: appId));
    join();
    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage(
              "Calling");
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("Connected");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage("Connected");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );
  }

  void join() async {
    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
      token: widget.token,
      channelId: widget.channelName,
      options: options,
      uid: uid,
    );
  }

  void leave() {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
  }

  @override
  void initState() {
    super.initState();
    // Set up an instance of Agora engine
    setupVoiceSDKEngine();
  }

// Clean up the resources when you leave
  @override
  void dispose() async {
    super.dispose();
    await agoraEngine.leaveChannel();
    agoraEngine.release();

  }

  @override
  Widget build(BuildContext context) {
    final height = Get.height;
    print("=========================================================================================================================================");
    print(_remoteUid);
    final width = Get.width;
    return Scaffold(
        body: 
        // ListView(
        //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        //     children: [
        //     // Status text
        //     Container(
        //         height: 40,
        //         child:Center(
        //             child:_status()
        //         )
        //     ),
        //     // Button Row
        //     Row(
        //         children: <Widget>[
        //         Expanded(
        //             child: ElevatedButton(
        //             child: const Text("Join"),
        //             onPressed: () => {join()},
        //             ),
        //         ),
        //         const SizedBox(width: 10),
        //         Expanded(
        //             child: ElevatedButton(
        //             child: const Text("Leave"),
        //             onPressed: () => {leave()},
        //             ),
        //         ),
        //         ],
        //     ),
        //     ],
        // )
    
      
            SafeArea(
          child: Stack(
            fit: StackFit.loose,
            children: [
              Image.asset(
                'assets/images/callpng.png',
                fit: BoxFit.cover,
              ),
              
              Center(
                  child:
                      // Image.asset('assets/images/callpresonpng.png')
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                radius: 70,
                backgroundColor: C556080,
                child: Center(
                  child: Icon(
                    Icons.person,
                    size: width * .3,
                    color: E7ECED,
                  ),
                ),
              ),
              SizedBox(height: height*.05,),
              _status()
                        ],
                      )),
              // back arrow icon button
              IconButton(
                  icon: Icon(Icons.arrow_back_outlined),
                  onPressed: () => Get.back()),

              // Padding(
              //   padding: EdgeInsets.only(top: 40, left: 20),
              //   child: SvgPicture.asset('assets/images/backArrow.svg'),
              // ),
            
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
                          onTap: () {
                            join();
                          },
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
                        InkWell(
                          onTap: () {
                            leave();
                            Get.back();
                          },
                          child: Container(
                            height: height * .05,
                            width: width * .3,
                            decoration: BoxDecoration(
                                color: ED0C0CAD,
                                borderRadius: BorderRadius.circular(20)),
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
            ],
          ),
        )
        );
  }
  bool otherusercutcall = false;
Widget _status(){
    String statusText;

    if (!_isJoined)
        statusText = 'Connecting';
    else if (_remoteUid == null){
      if( otherusercutcall == true){
        leave();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pop(context);
        });
      }
      statusText = 'Calling..';
    }

    else{
      otherusercutcall = true;
      statusText = 'Connected';
    }


    return Text(
    statusText,
    );
}
}
