import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Help extends StatelessWidget {
  String title =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make ";
       WebViewController  controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse('https://urlsdemo.xyz/soulmate/api/pages-api?pagename=help'));
  @override
  Widget build(BuildContext context) {
    final height = Get.height;
    final width = Get.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: TextClass(
            fontColor: Colors.black,
            fontWeight: FontWeight.w600,
            size: 20,
            title: 'Help'),
      ),
      body:   WebViewWidget(controller: controller),
      //  SingleChildScrollView(
      //   padding: EdgeInsets.all(20),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       TextClass(
      //           size: 14,
      //           fontWeight: FontWeight.w300,
      //           title: title + title + title,
      //           fontColor: Colors.black),
      //       SizedBox(
      //         height: height * .03,
      //       ),
      //       TextClass(
      //           size: 20,
      //           fontWeight: FontWeight.w600,
      //           title: 'Authorized user',
      //           fontColor: Colors.black),
      //       SizedBox(
      //         height: height * .03,
      //       ),
      //       TextClass(
      //           size: 14,
      //           fontWeight: FontWeight.w300,
      //           title: title + title,
      //           fontColor: Colors.black),
      //     ],
      //   ),
      // ),
    );
  }
}
