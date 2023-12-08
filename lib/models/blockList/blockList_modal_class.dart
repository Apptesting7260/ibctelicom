import 'package:get/get.dart';
import 'package:nauman/global_variables.dart';

class BlockListModalClass {
  String? status;
  String? message;
  RxList<UserBlockedList>? userBlockedList;

  BlockListModalClass({this.status, this.message, this.userBlockedList});

  BlockListModalClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['user_blocked_list'] != null) {
      userBlockedList = <UserBlockedList>[].obs;
      json['user_blocked_list'].forEach((v) {
        userBlockedList!.add(new UserBlockedList.fromJson(v));
      });
    }
    if(userBlockedList != null && userBlockedList!.isNotEmpty){
       print('it is not empty');
       if(userBlockedList!.length < 9){
        callBlockPagination.value = false;
       }
       if(userBlockedList!.length == 9){
        pageBlock++;
        callBlockPagination.value = true;
     
       }
       BlockDataList.addAll(userBlockedList as Iterable<UserBlockedList>);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.userBlockedList != null) {
      data['user_blocked_list'] =
          this.userBlockedList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserBlockedList {
 
  String? userName;
 
 
  String? proImgUrl;
  UserDetails? userDetails;
 

  UserBlockedList(
      {
      this.userName,
    
      this.proImgUrl,
      this.userDetails,
    });

  UserBlockedList.fromJson(Map<String, dynamic> json) {

    userName = json['user_name'];
    
    proImgUrl = json['pro_img_url'];
    userDetails = json['user_details'] != null
        ? new UserDetails.fromJson(json['user_details'])
        : null;
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    
    data['user_name'] = this.userName;
   
    data['pro_img_url'] = this.proImgUrl;
    if (this.userDetails != null) {
      data['user_details'] = this.userDetails!.toJson();
    }
   
    return data;
  }
}

class UserDetails {

  int? userId;
 
  String? profession;
 
  UserDetails(
      {
      this.userId,
     
      this.profession,
     });

  UserDetails.fromJson(Map<String, dynamic> json) {

    userId = json['user_id'];
   
    profession = json['profession'];
  
 

   
  
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
   
    data['user_id'] = this.userId;
 
    data['profession'] = this.profession;
   
    return data;
  }
}







