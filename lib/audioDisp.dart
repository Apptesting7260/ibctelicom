import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/view/Chat%20Screens/audioCallScreen.dart';
import 'package:nauman/view/Chat%20Screens/videoCallScreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class AudioDisp extends StatefulWidget{
  final String photoUrl;
  final String name;
  final String token;
  final String uid;
  final String channelName;
  AudioDisp({
    required this.photoUrl,
    required this.name,
    required this.token,
    required this.uid,
    required this.channelName
  });

  @override
  State<AudioDisp> createState() => AudioDispState();
}

class AudioDispState extends State<AudioDisp> {
   



  @override 
  Widget build(BuildContext context){
  
   try {
     return Scaffold(
      appBar: AppBar(elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.blue.shade100,
      ),
      body:
       Container(
        color: Colors.blue.shade100,
        width: Get.width,
        height: Get.height,
        child: Stack(
           fit: StackFit.loose,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: TextClass(size: 18, fontWeight: FontWeight.w500, title: "Incoming Audio Call", fontColor: Colors.teal)),
       
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
                    Get.off(()=>AudioCall(channelName: widget.channelName,token: widget.token,uid: int.parse(widget.uid)));
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
