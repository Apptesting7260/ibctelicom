class ChatPersonGetModalClass {
  String? status;
  String? message;
  List<UserList>? userList;

  ChatPersonGetModalClass({this.status, this.message, this.userList});

  ChatPersonGetModalClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['user_list'] != null) {
      userList = <UserList>[];
      json['user_list'].forEach((v) {
        userList!.add(new UserList.fromJson(v));
      });
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

  String? deviceToken;

  int? roomId;
  String? proImgUrl;
  UserDetails? userDetails;

  UserList(
      {this.userName,
      this.deviceToken,
      this.roomId,
      this.proImgUrl,
      this.userDetails});

  UserList.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];

    deviceToken = json['device_token'];

    roomId = json['room_id'];
    proImgUrl = json['pro_img_url'];
    userDetails = json['user_details'] != null
        ? new UserDetails.fromJson(json['user_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['user_name'] = this.userName;

    data['device_token'] = this.deviceToken;

    data['room_id'] = this.roomId;
    data['pro_img_url'] = this.proImgUrl;
    if (this.userDetails != null) {
      data['user_details'] = this.userDetails!.toJson();
    }
    return data;
  }
}

class UserDetails {
  int? userId;

  UserDetails({
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
