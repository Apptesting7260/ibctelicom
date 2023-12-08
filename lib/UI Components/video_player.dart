import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerClass extends StatefulWidget {
  String? videoUrl;
  VideoPlayerClass({super.key, required this.videoUrl});

  @override
  State<VideoPlayerClass> createState() => VideoPlayerState();
}

class VideoPlayerState extends State<VideoPlayerClass> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  void initState() {
    // TODO: implement initState
    super.initState();
    initializeVideo();
  }

  Future<ChewieController> initializeVideo() async {
    _videoPlayerController =
        await VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));
    await _videoPlayerController.initialize();
    _chewieController = await ChewieController(
        videoPlayerController: _videoPlayerController, aspectRatio: 16 / 9);

    return _chewieController;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final height = Get.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          title: Text('Your Video'),
        ),
        body: Center(
          child: SizedBox(
            width: width,
            height: height * .3,
            child: FutureBuilder<ChewieController>(
              future: initializeVideo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final chewieController = snapshot.data;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AspectRatio(
                      aspectRatio: 16 / 13,
                      child: Chewie(
                        controller: _chewieController,
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return Center(
                    child: Lottie.network('https://lottie.host/1815bacc-3515-40eb-a8a6-a97a09b6bbda/X9Ljy71b1m.json')
                  );
                }
              },
            ),
          ),
        ));
  }
}
