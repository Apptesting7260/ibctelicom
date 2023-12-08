import 'package:get/get.dart';
import 'package:nauman/global_variables.dart';

class RequestListModalClass {
  String? status;
  RxList<OutgoingRequests>? outgoingRequests;
  RxList<IncomingRequests>? incomingRequests;

  RequestListModalClass(
      {this.status, this.outgoingRequests, this.incomingRequests});

  RequestListModalClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['Outgoing_requests'] != null) {
      outgoingRequests = <OutgoingRequests>[].obs;
      json['Outgoing_requests'].forEach((v) {
        outgoingRequests!.add(new OutgoingRequests.fromJson(v));
      });
    }
    if (json['Incoming_requests'] != null) {
      incomingRequests = <IncomingRequests>[].obs;
      json['Incoming_requests'].forEach((v) {
        incomingRequests!.add(new IncomingRequests.fromJson(v));
      });
    }

    if(outgoingRequests != null && outgoingRequests!.isNotEmpty){
      print('ot not empty');
      if(outgoingRequests!.length < 8){
         callOutgoingPagination.value = false;
      }
      if(outgoingRequests!.length == 8){
        pageOutgoing++;
        callOutgoingPagination.value = true;
      }
      OutgoingDataList.addAll(outgoingRequests as Iterable<OutgoingRequests>);
    }

     if(incomingRequests != null && incomingRequests!.isNotEmpty){
      print('im not empty');
      if(incomingRequests!.length < 8){
        callIncomingPagination.value = false;
      }
      if(incomingRequests!.length == 8){
        pageIncoming++;
        callIncomingPagination.value = true;
      }
      IncomingDataList.addAll(incomingRequests as Iterable<IncomingRequests>);
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['status'] = this.status;
  //   if (this.outgoingRequests != null) {
  //     data['Outgoing_requests'] =
  //         this.outgoingRequests!.map((v) => v.toJson()).toList();
  //   }
  //   if (this.incomingRequests != null) {
  //     data['Incoming_requests'] =
  //         this.incomingRequests!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class OutgoingRequests {
  String? userName;

  String? proImgUrl;
  UserDetails? userDetails;

  OutgoingRequests({
    this.userName,
    this.proImgUrl,
    this.userDetails,
  });

  OutgoingRequests.fromJson(Map<String, dynamic> json) {
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

class IncomingRequests {
  String? userName;

  String? proImgUrl;
  UserDetails? userDetails;

  IncomingRequests({
    this.userName,
    this.proImgUrl,
    this.userDetails,
  });

  IncomingRequests.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];

    proImgUrl = json['pro_img_url'];
    userDetails = json['user_details'] != null
        ? new UserDetails.fromJson(json['user_details'])
        : null;

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
}



// class RequestListModalClass {
//   RequestListModalClass({
//     required this.status,
//     required this.OutgoingRequests,
//     required this.IncomingRequests,
//   });
//   late final String status;
//   late final List<OutgoingRequests> OutgoingRequests;
//   late final List<IncomingRequests> IncomingRequests;
  
//   RequestListModalClass.fromJson(Map<String, dynamic> json){
//     status = json['status'];
//     OutgoingRequests = List.from(json['Outgoing_requests']).map((e)=>OutgoingRequests.fromJson(e)).toList();
//     IncomingRequests = List.from(json['Incoming_requests']).map((e)=>IncomingRequests.fromJson(e)).toList();
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['status'] = status;
//     _data['Outgoing_requests'] = OutgoingRequests.map((e)=>e.toJson()).toList();
//     _data['Incoming_requests'] = IncomingRequests.map((e)=>e.toJson()).toList();
//     return _data;
//   }
// }

// class OutgoingRequests {
//   OutgoingRequests({
//     required this.userName,
//     required this.proImgUrl,
//     required this.userDetails,
//   });
//   late final String userName;
//   late final String proImgUrl;
//   late final UserDetails userDetails;
  
//   OutgoingRequests.fromJson(Map<String, dynamic> json){
//     userName = json['user_name'];
//     proImgUrl = json['pro_img_url'];
//     userDetails = UserDetails.fromJson(json['user_details']);
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['user_name'] = userName;
//     _data['pro_img_url'] = proImgUrl;
//     _data['user_details'] = userDetails.toJson();
//     return _data;
//   }
// }

// class UserDetails {
//   UserDetails({
//     required this.id,
//     required this.userId,
//   });
//   late final int id;
//   late final int userId;
  
//   UserDetails.fromJson(Map<String, dynamic> json){
//     id = json['id'];
//     userId = json['user_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['id'] = id;
//     _data['user_id'] = userId;
//     return _data;
//   }
// }

// class IncomingRequests {
//   IncomingRequests({
//     required this.userName,
//     required this.proImgUrl,
//     required this.userDetails,
//   });
//   late final String userName;
//   late final String proImgUrl;
//   late final UserDetails userDetails;
  
//   IncomingRequests.fromJson(Map<String, dynamic> json){
//     userName = json['user_name'];
//     proImgUrl = json['pro_img_url'];
//     userDetails = UserDetails.fromJson(json['user_details']);
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['user_name'] = userName;
//     _data['pro_img_url'] = proImgUrl;
//     _data['user_details'] = userDetails.toJson();
//     return _data;
//   }
// }