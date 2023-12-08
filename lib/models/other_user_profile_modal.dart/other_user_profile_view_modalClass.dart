class OtherProfileView_ModalClass {
  String? status;
  CandidateList? candidateList;

  OtherProfileView_ModalClass({this.status, this.candidateList});

  OtherProfileView_ModalClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    candidateList = json['candidate_list'] != null
        ? new CandidateList.fromJson(json['candidate_list'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.candidateList != null) {
      data['candidate_list'] = this.candidateList!.toJson();
    }
    return data;
  }
}

class CandidateList {
  int? id;
  String? userName;
  String? googleId;
  String? facebookId;
  String? linkedinId;
  String? email;
  String? password;
  String? proImg;
  String? device_token;
  String? status;
  String? currentStep;
  int? otpVarifyStatus;
  int? distance;
  int? requestStatus;
  int? roomId;
  int? likeStatus;
  int? blockStatus;
  String? proImgUrl;
  UserDetails? userDetails;
 

  CandidateList(
      {this.id,
      this.userName,
      this.googleId,
      this.facebookId,
      this.linkedinId,
      this.email,
      this.password,
      this.proImg,
      this.status,
      this.device_token,
      this.currentStep,
      this.otpVarifyStatus,
      this.distance,
      this.requestStatus,
      this.roomId,
      this.likeStatus,
      this.blockStatus,
      this.proImgUrl,
      this.userDetails,
    });

  CandidateList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    googleId = json['google_id'];
    facebookId = json['facebook_id'];
    linkedinId = json['linkedin_id'];
    email = json['email'];
    password = json['password'];
    proImg = json['pro_img'];
    status = json['status'];
    device_token = json['device_token'];
    currentStep = json['current_step'];
    otpVarifyStatus = json['otp_varify_status'];
    distance = json['distance'];
    requestStatus = json['request_status'];
    roomId = json['room_id'];
    likeStatus = json['like_status'];
    blockStatus = json['block_status'];
    proImgUrl = json['pro_img_url'];
    userDetails = json['user_details'] != null
        ? new UserDetails.fromJson(json['user_details'])
        : null;
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_name'] = this.userName;
    data['google_id'] = this.googleId;
    data['facebook_id'] = this.facebookId;
    data['linkedin_id'] = this.linkedinId;
    data['email'] = this.email;
    data['password'] = this.password;
    data['pro_img'] = this.proImg;
    data['status'] = this.status;
    data['device_token'] = this.device_token;
    data['current_step'] = this.currentStep;
    data['otp_varify_status'] = this.otpVarifyStatus;
    data['distance'] = this.distance;
    data['request_status'] = this.requestStatus;
    data['room_id'] = this.roomId;
    data['like_status'] = this.likeStatus;
    data['block_status'] = this.blockStatus;
    data['pro_img_url'] = this.proImgUrl;
    if (this.userDetails != null) {
      data['user_details'] = this.userDetails!.toJson();
    }
 
    return data;
  }
}

class UserDetails {
  int? id;
  int? userId;
  String? galleryImages;
  String? userVideo;
  String? videoThumbnail;
  String? gender;
  int? age;
  String? location;
  String? color;
  int? height;
  List<String>? hobbies;
  List<String>? education;
  String? profession;
  String? about;
  int?  average_rating;
  List<PersonalityQuestions>? personalityQuestions;
  List<GalleryImagesUrl>? galleryImagesUrl;
  UserVideoUrl? userVideoUrl;

  UserDetails(
      {this.id,
      this.userId,
      this.galleryImages,
      this.userVideo,
      this.videoThumbnail,
      this.gender,
      this.age,
      this.location,
      this.color,
      this.height,
      this.hobbies,
      this.education,
      this.profession,
      this.average_rating,
      this.about,
      this.personalityQuestions,
      this.galleryImagesUrl,
      this.userVideoUrl});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    galleryImages = json['gallery_images'];
    userVideo = json['user_video'];
    videoThumbnail = json['video_thumbnail'];
    gender = json['gender'];
    age = json['age'];
    location = json['location'];
    color = json['color'];
    height = json['height'];
    hobbies = json['hobbies'].cast<String>();
    education = json['education'].cast<String>();
    profession = json['profession'];
    average_rating = json['average_rating'];
    about = json['about'];
    if (json['personality_questions'] != null) {
      personalityQuestions = <PersonalityQuestions>[];
      json['personality_questions'].forEach((v) {
        personalityQuestions!.add(new PersonalityQuestions.fromJson(v));
      });
    }
    if (json['gallery_images_url'] != null) {
      galleryImagesUrl = <GalleryImagesUrl>[];
      json['gallery_images_url'].forEach((v) {
        galleryImagesUrl!.add(new GalleryImagesUrl.fromJson(v));
      });
    }
    userVideoUrl = json['user_video_url'] != null
        ? new UserVideoUrl.fromJson(json['user_video_url'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['gallery_images'] = this.galleryImages;
    data['user_video'] = this.userVideo;
    data['video_thumbnail'] = this.videoThumbnail;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['location'] = this.location;
    data['color'] = this.color;
    data['height'] = this.height;
    data['average_rating'] = this.average_rating;
    data['hobbies'] = this.hobbies;
    data['education'] = this.education;
    data['profession'] = this.profession;
    data['about'] = this.about;
    if (this.personalityQuestions != null) {
      data['personality_questions'] =
          this.personalityQuestions!.map((v) => v.toJson()).toList();
    }
    if (this.galleryImagesUrl != null) {
      data['gallery_images_url'] =
          this.galleryImagesUrl!.map((v) => v.toJson()).toList();
    }
    if (this.userVideoUrl != null) {
      data['user_video_url'] = this.userVideoUrl!.toJson();
    }
    return data;
  }
}

class PersonalityQuestions {
  String? id;
  String? answer;

  PersonalityQuestions({this.id, this.answer});

  PersonalityQuestions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['answer'] = this.answer;
    return data;
  }
}

class GalleryImagesUrl {
  int? key;
  String? galleryImages;

  GalleryImagesUrl({this.key, this.galleryImages});

  GalleryImagesUrl.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    galleryImages = json['gallery_images'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['gallery_images'] = this.galleryImages;
    return data;
  }
}

class UserVideoUrl {
  String? userVideo;

  UserVideoUrl({this.userVideo});

  UserVideoUrl.fromJson(Map<String, dynamic> json) {
    userVideo = json['user_video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_video'] = this.userVideo;
    return data;
  }
}

