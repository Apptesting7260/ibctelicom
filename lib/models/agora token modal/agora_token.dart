class AgoraTokenModalClass {
  String? status;
  String? message;
  Details? details;

  AgoraTokenModalClass({this.status, this.message, this.details});

  AgoraTokenModalClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    details =
        json['details'] != null ? new Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}

class Details {
  int? uid;
  String? userName;
  String? userProfile;
  String? channelName;
  String? otherUserId;
  String? otherUserFcmToken;
  String? callingType;
  String? rtcToken;

  Details(
      {this.uid,
      this.userName,
      this.userProfile,
      this.channelName,
      this.otherUserId,
      this.otherUserFcmToken,
      this.callingType,
      this.rtcToken});

  Details.fromJson(Map<String, dynamic> json) {
    uid = json['Uid'];
    userName = json['user_name'];
    userProfile = json['user_profile'];
    channelName = json['channelName'];
    otherUserId = json['other_user_id'];
    otherUserFcmToken = json['other_user_fcm_token'];
    callingType = json['calling_type'];
    rtcToken = json['rtc_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Uid'] = this.uid;
    data['user_name'] = this.userName;
    data['user_profile'] = this.userProfile;
    data['channelName'] = this.channelName;
    data['other_user_id'] = this.otherUserId;
    data['other_user_fcm_token'] = this.otherUserFcmToken;
    data['calling_type'] = this.callingType;
    data['rtc_token'] = this.rtcToken;
    return data;
  }
}
