import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/color.dart';

import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/data/response/status.dart';
import 'package:nauman/view_models/controller/chatGPT/chatGPT_response_cont.dart';

class ChatGPT extends StatefulWidget {
  int profile_id;
  int user_id;
  ChatGPT({
    required this.profile_id,
    required this.user_id
  });
  @override
  State<ChatGPT> createState() => ChatGPTState();
}

class ChatGPTState extends State<ChatGPT> {
  var chatGPT = Get.put(ChatGPT_responseViewModal());
  var contr = TextEditingController().obs;
  RxString question = ''.obs;
  RxInt a = 1.obs;
  RxBool startSwitch = false.obs;
  String response = '';

  @override
  Widget build(BuildContext context) {
    chatGPT.user_id = widget.user_id.obs;
    chatGPT.profile_id = widget.profile_id.obs;
    return Obx(
      () => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              elevation: 0,
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              title: question.value.isNotEmpty == true
                  ? TextClass(
                      size: 20,
                      fontWeight: FontWeight.w600,
                      title: 'Chat-GPT',
                      fontColor: Colors.black)
                  : Text('')),
          bottomSheet: Padding(
              padding: EdgeInsets.all(5),
              child: TextFormField(
                controller: chatGPT.prompt.value,
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
                    suffixIcon: Padding(
                      padding:
                          const EdgeInsets.only(top: 4, right: 4, bottom: 4),
                      child: IconButton(
                          onPressed: () {
                            question.value = chatGPT.prompt.value.text;
                            print("Prompt --> ${chatGPT.prompt.value.text}");
                            print("User id --> ${chatGPT.user_id}");
                            print("Profile Id --> ${chatGPT.profile_id}");

                            chatGPT.ChatGPT_responseApi();
                            chatGPT.prompt.value.clear();
                          },
                          icon: Icon(Icons.send_outlined,
                              size: 33, color: Color(0xff596E79))),
                    ),
                    hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffB0B0B0)),
                    hintText: 'Ask anything related to profile!'),
              )),
          body: Obx(() {
            if (chatGPT.rxRequestStatus.value == Status.ERROR) {
              return Center(
                child: Text('Error'),
              );
            }

            return SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: question.value.isNotEmpty == true
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: primaryDark,
                                  ),
                                  child: TextClass(
                                      size: 15,
                                      fontWeight: FontWeight.w500,
                                      title: "Question: ${question.value}",
                                      fontColor: Colors.white)),
                              SizedBox(
                                height: Get.height * .05,
                              ),
                              chatGPT.rxRequestStatus.value == Status.LOADING &&
                                      question.isNotEmpty
                                  ? Center(
                                      child: CircularProgressIndicator(
                                      color: primaryDark,
                                    ))
                                  : Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xff50555C),
                                      ),
                                      child: TextClass(
                                          size: 15,
                                          fontWeight: FontWeight.w500,
                                          title:
                                              "Response: ${chatGPT.UserDataList.value.data?.conversation.toString()}",
                                          fontColor: Colors.white)),
                              SizedBox(
                                height: Get.height * .1,
                              ),
                            ],
                          )
                        : Container(
                            width: Get.width,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextClass(
                                    size: 35,
                                    fontWeight: FontWeight.w600,
                                    title: 'ChatGPT',
                                    fontColor: Color(0xffC4C4C4)),
                                SizedBox(
                                  height: Get.height * .25,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.sunny,
                                      color: Color(0xffC4C4C4),
                                    ),
                                    SizedBox(
                                      width: Get.width * .03,
                                    ),
                                    TextClass(
                                        size: 20,
                                        fontWeight: FontWeight.w500,
                                        title: "Examples",
                                        fontColor: Color(0xffC4C4C4)),
                                  ],
                                ),
                                SizedBox(
                                  height: Get.height * .03,
                                ),
                                InkWell(
                                  onTap: () {
                                    chatGPT.prompt.value.text =
                                        'Tell me about him/her.';

                                    question.value = chatGPT.prompt.value.text;

                                    chatGPT.ChatGPT_responseApi();
                                    chatGPT.prompt.value.clear();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade600,
                                    ),
                                    child: TextClass(
                                        size: 20,
                                        fontWeight: FontWeight.w500,
                                        title: 'Tell me about him/her.',
                                        fontColor: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: Get.height * .02,
                                ),
                                InkWell(
                                  onTap: () {
                                    chatGPT.prompt.value.text =
                                        'What are his/her interests.';

                                    question.value = chatGPT.prompt.value.text;

                                    chatGPT.ChatGPT_responseApi();
                                    chatGPT.prompt.value.clear();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade600,
                                    ),
                                    child: TextClass(
                                        size: 20,
                                        fontWeight: FontWeight.w500,
                                        title: 'What are his/her interests.',
                                        fontColor: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: Get.height * .02,
                                ),
                                InkWell(
                                  onTap: () {
                                    chatGPT.prompt.value.text =
                                        'How I can start conversation.';

                                    question.value = chatGPT.prompt.value.text;

                                    chatGPT.ChatGPT_responseApi();
                                    chatGPT.prompt.value.clear();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade600,
                                    ),
                                    child: TextClass(
                                        size: 20,
                                        fontWeight: FontWeight.w500,
                                        title: 'How I can start conversation.',
                                        fontColor: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          )));
          })),
    );
  }
}
