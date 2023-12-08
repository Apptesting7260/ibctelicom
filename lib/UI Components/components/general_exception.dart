import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nauman/UI%20Components/color.dart';
// import 'package:getx_mvvm/res/colors/app_color.dart';

class GeneralExceptionWidget extends StatefulWidget {
  final VoidCallback onPress;
  const GeneralExceptionWidget({Key? key, required this.onPress})
      : super(key: key);

  @override
  State<GeneralExceptionWidget> createState() => _GeneralExceptionWidgetState();
}

class _GeneralExceptionWidgetState extends State<GeneralExceptionWidget> {
  @override
  Widget build(BuildContext context) {
    
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            height: height * .1,
          ),
          // Icon(
          //   Icons.cloud_off,
          //   color: Colors.red,
          //   size: 50,
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 30),
          //   child: Center(
          //       child: Text(
          //     'Server Error'.tr,
          //     textAlign: TextAlign.center,
          //   )),
          // ),

Lottie.network(
                'https://lottie.host/4d0d7f9d-6794-43bd-a953-e90c6a315116/qU2pV6DYhd.json'),
          // SizedBox(
          //   height: height * .15,
          // ),
          InkWell(
            onTap: widget.onPress,
            child: Container(
              height: 44,
              width: 160,
              decoration: BoxDecoration(
                  color: primaryDark, borderRadius: BorderRadius.circular(50)),
              child: Center(
                  child: Text(
                'Retry',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white),
              )),
            ),
          )
        ],
      ),
    );
  }
}
