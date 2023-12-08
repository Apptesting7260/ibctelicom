import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:nauman/global_variables.dart';

class MyConnectionsModalClass {
  String? status;
  String? message;
  RxList<UserConnection>? userConnection;

  MyConnectionsModalClass({this.status, this.message, this.userConnection});

  MyConnectionsModalClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['user_connection'] != null) {
      userConnection = <UserConnection>[].obs;
      json['user_connection'].forEach((v) {
        userConnection!.add(new UserConnection.fromJson(v));
      });
    }

    if(userConnection != null && userConnection!.isNotEmpty){
      print('no empty data');
      if(userConnection!.length < 9){
        
        callConnectionPagination.value = false;
      }
      if(userConnection!.length == 9){
        pageConnection++;
        callConnectionPagination.value = true;
      }
      ConnectionDataList.addAll(userConnection as Iterable<UserConnection>);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.userConnection != null) {
      data['user_connection'] =
          this.userConnection!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserConnection {
  String? userName;

  String? proImgUrl;
  UserDetails? userDetails;

  UserConnection({
    this.userName,
    this.proImgUrl,
    this.userDetails,
  });

  UserConnection.fromJson(Map<String, dynamic> json) {
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

  UserDetails({
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
