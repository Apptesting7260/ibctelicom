import 'dart:io';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:nauman/models/blockList/blockList_modal_class.dart';
import 'package:nauman/models/chatList/chatList_modalClass.dart';
import 'package:nauman/models/favouriteList/favouriteListModalClass.dart';
import 'package:nauman/models/home/home_screen_modal_class.dart';
import 'package:nauman/models/my_connections/my_connections_modalClass.dart';
import 'package:nauman/models/request_list/request_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
 RxInt second = 0.obs; // 1 minutes in seconds
 RxInt minute = 0.obs; // 1 minutes in seconds
// 1 minutes in seconds
RxInt unReadValue = 0.obs;
RxBool notificationBell = false.obs;
RxInt attempts = 2.obs;
RxBool hideLoginButton = false.obs;
String? fcmToken;
 String? currentRouteName ;
 RxBool screenStatus = true.obs;
String? id;
String? Tokenid;
String? Step;
RxList<File> ImagesPathList = <File>[].obs;
RxString? videoPath;
List<String> globalHobbies = [];
List<String> globalEducation = [];
String globalProfession = '';
List<String> optionList = [];
RxBool fromFilterScr = false.obs;
RxList<CandidateList> HomeDataList = <CandidateList>[].obs;
RxInt page = 1.obs;
RxBool callHomePagination = true.obs;
RxBool noDataHome = false.obs;
RxList<UserFavouriteList> FavouriteDataList = <UserFavouriteList>[].obs;
RxInt pageFav = 1.obs;
RxBool noDataFav = false.obs;
RxBool callFavPagination = true.obs;
RxList<UserBlockedList> BlockDataList = <UserBlockedList>[].obs;
RxInt pageBlock = 1.obs;
RxBool callBlockPagination = true.obs;
RxList<UserConnection> ConnectionDataList = <UserConnection>[].obs;
RxInt pageConnection = 1.obs;
RxBool callConnectionPagination = true.obs;
RxList<OutgoingRequests> OutgoingDataList = <OutgoingRequests>[].obs;
RxInt pageOutgoing = 1.obs;
RxBool callOutgoingPagination = true.obs;
RxList<IncomingRequests> IncomingDataList = <IncomingRequests>[].obs;
RxInt pageIncoming = 1.obs;
RxBool callIncomingPagination = true.obs;
RxList<UserList> ChatDataList = <UserList>[].obs;
RxInt pageChat = 1.obs;
RxBool callChatPagination = true.obs;

String ChatGPTkey = "5KoOINAy3g71nPiaBR54e3nkZ9goUtQg4HKp7GPG";
bool? googleActive ;
bool? facebookActive ;
bool? linkedinActive  ;
bool? hitGPT;

Future<void> setHitGPT(bool value)async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setBool('gpt', value);
  hitGPT = sp.getBool('gpt');
}

Future<bool?> getHitGPT()async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  bool? value = sp.getBool('gpt');
  return value;
}





Future<void> setGoogle(bool value)async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setBool('google', value);
  googleActive = sp.getBool('google');
}

Future<void> setFacebook(bool value)async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setBool('facebook', value);

  facebookActive = sp.getBool('facebook');
}
Future<void> setLinkedin(bool value)async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setBool('linkedin', value);
  print(sp.getBool('linkedin'));
  linkedinActive = sp.getBool('linkedin');
}



Future<bool?> getGoogle()async{
  SharedPreferences sp = await SharedPreferences.getInstance();
 bool? val =  sp.getBool('google');
 return val;
}

Future<bool?> getFacebook()async{
 SharedPreferences sp = await SharedPreferences.getInstance();
 bool? val =  sp.getBool('facebook');
 return val;
}
Future<bool?> getLinkedin()async{
  SharedPreferences sp = await SharedPreferences.getInstance();
 bool? val =  sp.getBool('linkedin');
 return val;
}


String Chat_GPT_Modal_Train_Sentence = "";
