import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
// import 'package:nauman/Authentication Screens//onBoarding.dart';
// import 'package:nauman/Authentication%20Screens/signUp.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/view/Authentication%20Screens/onBoarding.dart';
import 'package:nauman/view_models/controller/login/login_timer_controller.dart';

class PgView extends StatefulWidget {
  @override
  State<PgView> createState() => PageViewState();
}

class PageViewState extends State<PgView> {
 
  PageController pageController = PageController(initialPage: 0);
  int activePage = 0;
  List images = ['assets/images/match3.png', 'assets/images/match-1.png'];
  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   pageController;
  // }
 

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        PageView.builder(
            onPageChanged: (value) {
              setState(() {
                activePage = value;
              });
            },
            controller: pageController,
            itemCount: images.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(images[index]), fit: BoxFit.cover)),
                )
            // Image.asset(
            //       images[index],
            //       fit: BoxFit.cover,
            //       width: Get.width,
            //       height: Get.height,
            //     )

            ),
        Padding(
          padding: EdgeInsets.only(bottom: 40.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 12,
                    child: activePage == 0
                        ? Stack(children: [
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: primaryDark,
                            ),
                          ])
                        : null),
                const SizedBox(
                  width: 20,
                ),
                CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white,
                    child: activePage == 1
                        ? CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.white,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  backgroundColor: primaryDark,
                                  radius: 10,
                                ),
                              ],
                            ),
                          )
                        : null),
                const SizedBox(
                  width: 20,
                ),
                CircleAvatar(
                    backgroundColor: primaryDark,
                    radius: 30,
                    child: Center(
                        child: IconButton(
                            onPressed: () {
                              activePage == 0
                                  ? pageController.nextPage(
                                      duration: Duration(milliseconds: 100),
                                      curve: Curves.linear)
                                  : Get.to(() => OnboardingScreen());
                            },
                            icon: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 35,
                            ))))
              ],
            ),
          ),
        )
      ]),
    ));
  }
}













// class ImagesContainer extends StatelessWidget{
//   @override 

//   Widget build(BuildContext context){
// return Container(
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                           image: AssetImage(images[index]), fit: BoxFit.cover),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.only(bottom: 40.0),
//                       child: Align(
//                         alignment: Alignment.bottomCenter,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 radius: 12,
//                                 child: index == 0
//                                     ? Stack(children: [
//                                         CircleAvatar(
//                                           radius: 10,
//                                           backgroundColor: primaryDark,
//                                         ),
//                                       ])
//                                     : null),
//                             const SizedBox(
//                               width: 20,
//                             ),
//                             CircleAvatar(
//                                 radius: 12,
//                                 backgroundColor: Colors.white,
//                                 child: widget.index == 1
//                                     ? CircleAvatar(
//                                         radius: 12,
//                                         backgroundColor: Colors.white,
//                                         child: Stack(
//                                           children: [
//                                             CircleAvatar(
//                                               backgroundColor: primaryDark,
//                                               radius: 10,
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     : null),
//                             const SizedBox(
//                               width: 20,
//                             ),
//                             CircleAvatar(
//                                 backgroundColor: primaryDark,
//                                 radius: 30,
//                                 child: Center(
//                                     child: IconButton(
//                                         onPressed: () {
//                                           widget.index == 0
//                                               ? widget.pageController.nextPage(
//                                                   duration: Duration(
//                                                       milliseconds: 100),
//                                                   curve: Curves.linear)
//                                               : Get.to(
//                                                   () => OnboardingScreen());
//                                         },
//                                         icon: const Icon(
//                                           Icons.arrow_forward_rounded,
//                                           color: Colors.white,
//                                           size: 35,
//                                         ))))
//                           ],
//                         ),
//                       ),
//                     ));
//   }
  
// }






