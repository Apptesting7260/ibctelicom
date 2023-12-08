class UserProfileViewModalClass {
  String? status;
  UserData? userData;

  UserProfileViewModalClass({this.status, this.userData});

  UserProfileViewModalClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userData = json['user_data'] != null
        ? new UserData.fromJson(json['user_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.userData != null) {
      data['user_data'] = this.userData!.toJson();
    }
    return data;
  }
}

class UserData {
  int? id;
  String? userName;
  String? googleId;
  String? facebookId;
  String? linkedinId;
  String? email;
  String? password;
  String? proImg;
  String? country;
  String? phone;
  String? status;
  String? currentStep;
  int? ownLikes;
  int? ownConnection;
  String? proImgUrl;
  UserDetails? userDetails;


  UserData(
      {this.id,
      this.userName,
      this.googleId,
      this.facebookId,
      this.linkedinId,
      this.email,
      this.password,
      this.proImg,
      this.country,
      this.phone,
      this.status,
      this.currentStep,
      this.ownLikes,
      this.ownConnection,
      this.proImgUrl,
      this.userDetails,
     });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    googleId = json['google_id'];
    facebookId = json['facebook_id'];
    linkedinId = json['linkedin_id'];
    email = json['email'];
    password = json['password'];
    proImg = json['pro_img'];
    country = json['country'];
    phone = json['phone'];
    status = json['status'];
    currentStep = json['current_step'];
    ownLikes = json['own_likes'];
    ownConnection = json['own_connection'];
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
    data['country'] = this.country;
    data['phone'] = this.phone;
    data['status'] = this.status;
    data['current_step'] = this.currentStep;
    data['own_likes'] = this.ownLikes;
    data['own_connection'] = this.ownConnection;
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
  String? gender;
  int? age;
  String? location;
  String? color;
  int? height;
  int? average_rating;
  List<String>? hobbies;
  List<String>? education;
  String? profession;
  String? about;
  List<PersonalityQuestions>? personalityQuestions;
  List<GalleryImagesUrl>? galleryImagesUrl;
  UserVideoUrl? userVideoUrl;

  UserDetails(
      {this.id,
      this.userId,
      this.galleryImages,
      this.userVideo,
      this.gender,
      this.age,
      this.location,
      this.color,
      this.height,
      this.average_rating,
      this.hobbies,
      this.education,
      this.profession,
      this.about,
      this.personalityQuestions,
      this.galleryImagesUrl,
      this.userVideoUrl});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    galleryImages = json['gallery_images'];
    userVideo = json['user_video'];
    gender = json['gender'];
    age = json['age'];
    location = json['location'];
    color = json['color'];
    height = json['height'];
    average_rating = json['average_rating'];
    hobbies = json['hobbies'].cast<String>();
    education = json['education'].cast<String>();
    profession = json['profession'];
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


