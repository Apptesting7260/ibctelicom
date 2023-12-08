class EducationModalClass {
  List<ProfileEducation>? profileEducation;

  EducationModalClass({this.profileEducation});

  EducationModalClass.fromJson(Map<String, dynamic> json) {
    if (json['profile_education'] != null) {
      profileEducation = <ProfileEducation>[];
      json['profile_education'].forEach((v) {
        profileEducation!.add(new ProfileEducation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profileEducation != null) {
      data['profile_education'] =
          this.profileEducation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProfileEducation {
  int? id;
  String? educationName;

  ProfileEducation({this.id, this.educationName});

  ProfileEducation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    educationName = json['education_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['education_name'] = this.educationName;
    return data;
  }
}
