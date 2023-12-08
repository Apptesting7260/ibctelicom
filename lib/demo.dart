import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/view/Chat%20Screens/videoCallScreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class Demo extends StatefulWidget{
  final String photoUrl;
  final String name;
  final String token;
  final String uid;
  final String channelName;
  Demo({
    required this.photoUrl,
    required this.name,
    required this.token,
    required this.uid,
    required this.channelName
  });

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
   
   late List<CameraDescription> cameras;
   late CameraController _cameraController;
Future<void> initializeCamera() async {
     cameras = await availableCameras();
   

    _cameraController = CameraController(
      cameras[1],
      ResolutionPreset.ultraHigh, // Set the desired resolution
      enableAudio: false
    );

    await _cameraController.initialize().then((value)  {
      if(!mounted){
        return;
      }
      setState(() {
        
      });
    }).onError((error, stackTrace) {
      print(error);
    });
  }
@override
  void initState() {
    initializeCamera();
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _cameraController.dispose();
  }






  @override 
  Widget build(BuildContext context){
  
   try {
     return Scaffold(
      body: Container(
        color: Colors.grey,
        width: Get.width,
        height: Get.height,
        child: Stack(
           fit: StackFit.loose,
          children: [
            
          CameraPreview(_cameraController),
          Align(
            alignment : Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[ CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.photoUrl),),
                SizedBox(height: 10,),
                Chip(
                  
                  label: Text(widget.name))
                
                ]
            )),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.bottomRight,
              
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                child: IconButton(
                    onPressed :() {
                    Get.off(()=>VideoCall(channelName: widget.channelName,token: widget.token,uid: int.parse(widget.uid)));
                    },
                    icon: Icon( Icons.call,color: primaryDark,size: 35,)
                    ),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                child: Center(
                  child: IconButton(
                    onPressed :() {
                     Get.back();
                    },
                    icon: Icon( Icons.call_end,color: Colors.red,size: 35,)
                    ),
                )),
            ),
          ),
        ],),
      ),
     );
   } catch (e) {
     return CircularProgressIndicator(color: primaryDark,);
   }

  }
}
