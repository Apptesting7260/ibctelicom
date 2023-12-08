class SignupEmailModalClass {
  String? status;
  String? message;
  UserData? userData;

  SignupEmailModalClass({this.status, this.message, this.userData});

  SignupEmailModalClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userData = json['user_data'] != null
        ? new UserData.fromJson(json['user_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.userData != null) {
      data['user_data'] = this.userData!.toJson();
    }
    return data;
  }
}

class UserData {
  String? userName;
  String? email;
  String? password;
  int? id;
  String? imagePath;
  String? videoPath;

  UserData(
      {this.userName,
      this.email,
      this.password,
      this.id,
      this.imagePath,
      this.videoPath});

  UserData.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    email = json['email'];
    password = json['password'];
    id = json['id'];
    imagePath = json['image_path'];
    videoPath = json['video_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['id'] = this.id;
    data['image_path'] = this.imagePath;
    data['video_path'] = this.videoPath;
    return data;
  }
}
