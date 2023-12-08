import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/global_variables.dart';
import 'package:nauman/view_models/controller/aboutYou/aboutYou_view_model.dart';
import 'package:nauman/view_models/controller/user_profile_edit/user_profile_eidt_view_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class VideoPickerAndPlayer extends StatefulWidget {
  bool fromEdit;
  VideoPickerAndPlayer({required this.fromEdit});
  @override
  _VideoPickerAndPlayerState createState() => _VideoPickerAndPlayerState();
}

class _VideoPickerAndPlayerState extends State<VideoPickerAndPlayer> {
  bool showButton = false;
  String sizeError = '';
  AboutYouViewModel aboutYouViewModel = Get.put(AboutYouViewModel());
  var userProfileEditViewModel = Get.put(UserProfileEditViewModel());
  VideoPlayerController? _controller;
  late Future<void> _initializeVideoPlayerFuture;
  Future<void> requestStoragePermission() async {
    final PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      // Permission granted, proceed with file picking and playing
    } else {
      // Permission denied
      // You can show a message to the user indicating that the app needs storage permission to proceed
    }
  }

  void _pickAndPlayVideo() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);
    await requestStoragePermission();
    if (result != null && (result.files.first.size <= 20000000) ) {
     
      videoPath = result.files.single.path!.obs;
      _controller = VideoPlayerController.file(File(videoPath.toString()));
      _initializeVideoPlayerFuture = _controller!.initialize();
      aboutYouViewModel.videotakingpath = await videoPath;
      setState(() {});
    }
    else{

         sizeError = "Video size is greater than 20 mb, please chose video upto 20 mb.";
         setState(() {
             videoPath = null;
                            _controller = null;
                            aboutYouViewModel.videotakingpath = null;
         });
    }
  }

  @override
  void initState() {
    super.initState();
    if (videoPath != null) {
      _controller = VideoPlayerController.file(File(videoPath.toString()));
      _initializeVideoPlayerFuture = _controller!.initialize();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: videoPath != null
              ? Align(
                  heightFactor: .15,
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 200,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                textStyle: MaterialStatePropertyAll(
                                    TextStyle(fontSize: 20)),
                                padding: MaterialStatePropertyAll(
                                    EdgeInsets.all(14)),
                                backgroundColor:
                                    MaterialStatePropertyAll(primaryDark)),
                            onPressed: () {
                              if (widget.fromEdit == true) {
                                userProfileEditViewModel.videotakingpath =
                                    videoPath;

                                Get.back(result: true);
                              } else {
                                aboutYouViewModel.videotakingpath = videoPath;
                                Get.back();
                              }
                            },
                            child: Text('Done')),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                )
              : Align(
                  heightFactor: .1,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 10,
                  ),
                ),
          appBar: AppBar(
            elevation: 0,
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            title: Text('Video Picker and Player'),
          ),
          body: Center(
            child: _controller != null
                ? Stack(alignment: Alignment.topRight, children: [
                    FutureBuilder(
                      future: _initializeVideoPlayerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: VideoPlayer(_controller!),
                          );
                        } else {
                          return CircularProgressIndicator(
                            color: primaryDark,
                          );
                        }
                      },
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            videoPath = null;
                            _controller = null;
                            aboutYouViewModel.videotakingpath = null;
                          });
                        },
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 30,
                        ))
                  ])
                : 
                sizeError.isNotEmpty ?
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(sizeError,textAlign: TextAlign.center,),
                ):
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No video selected'),
                    SizedBox(height: Get.height*.02,),
                    Text("NOTE: Please select video upto 20 mb.")
                  ],
                ),
          ),
          floatingActionButton: _controller == null
              ? FloatingActionButton(
                  backgroundColor: primaryDark,
                  onPressed: () {
                    _pickAndPlayVideo();
                  },
                  child: Icon(Icons.upload_rounded))
              : FloatingActionButton(
                  backgroundColor: primaryDark,
                  onPressed: () {
                    if (_controller!.value.isPlaying) {
                      _controller!.pause();
                    } else {
                      _controller!.play();
                    }
                    setState(() {}); // Add this line to trigger UI update
                  },
                  child: Icon(
                    _controller!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                ),
        ),
      ),
    );
  }
}
