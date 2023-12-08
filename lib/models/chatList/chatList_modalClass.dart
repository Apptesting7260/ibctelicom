import 'package:nauman/global_variables.dart';

class ChatListModalClass {
  String? status;
  String? message;
  List<UserList>? userList;

  ChatListModalClass({this.status, this.message, this.userList});

  ChatListModalClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['user_list'] != null) {
      userList = <UserList>[];
      json['user_list'].forEach((v) {
        userList!.add(new UserList.fromJson(v));
      });
    }
    if(userList != null && userList!.isNotEmpty){
      print('no empty data');
      if(userList!.length < 9){
        callChatPagination.value = false;
      }
      if(userList!.length == 9){
        pageChat++;
        callChatPagination.value = true;
      }
      ChatDataList.addAll(userList as Iterable<UserList>);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.userList != null) {
      data['user_list'] = this.userList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserList {
 
  String? userName;
 
 
  String? proImgUrl;
  UserDetails? userDetails;
  

  UserList(
      {
      this.userName,
    
      this.proImgUrl,
      this.userDetails,
    });

  UserList.fromJson(Map<String, dynamic> json) {
 
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
 
 

  UserDetails(
      {
      this.userId,
     });

  UserDetails.fromJson(Map<String, dynamic> json) {
   
    userId = json['user_id'];
   
  
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
   
    data['user_id'] = this.userId;
  
   
    return data;
  }
}

