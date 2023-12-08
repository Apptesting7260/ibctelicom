class NotificationGetListModalClass {
  String? status;
  String? message;
  List<NotificationList>? notificationList;

  NotificationGetListModalClass(
      {this.status, this.message, this.notificationList});

  NotificationGetListModalClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['notification_list'] != null) {
      notificationList = <NotificationList>[];
      json['notification_list'].forEach((v) {
        notificationList!.add(new NotificationList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.notificationList != null) {
      data['notification_list'] =
          this.notificationList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationList {
  int? userId;
  int? otherUserId;
  String? about;
  String? content;
  String? seenStatus;
  String? timeStamp;

  NotificationList(
      {this.userId,
      this.otherUserId,
      this.about,
      this.content,
      this.seenStatus,
      this.timeStamp});

  NotificationList.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    otherUserId = json['other_user_id'];
    about = json['about'];
    content = json['content'];
    seenStatus = json['seen_status'];
    timeStamp = json['time_stamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['other_user_id'] = this.otherUserId;
    data['about'] = this.about;
    data['content'] = this.content;
    data['seen_status'] = this.seenStatus;
    data['time_stamp'] = this.timeStamp;
    return data;
  }
}
