class HobbiesModalClass {
  List<ProfileHobbie>? profileHobbie;

  HobbiesModalClass({this.profileHobbie});

  HobbiesModalClass.fromJson(Map<String, dynamic> json) {
    if (json['profile_hobbie'] != null) {
      profileHobbie = <ProfileHobbie>[];
      json['profile_hobbie'].forEach((v) {
        profileHobbie!.add(new ProfileHobbie.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profileHobbie != null) {
      data['profile_hobbie'] =
          this.profileHobbie!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProfileHobbie {
  int? id;
  String? hobbieName;

  ProfileHobbie({this.id, this.hobbieName});

  ProfileHobbie.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hobbieName = json['hobbie_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hobbie_name'] = this.hobbieName;
    return data;
  }
}
