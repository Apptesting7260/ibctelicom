class ProfessionModalClass {
  List<ProfileProfession>? profileProfession;

  ProfessionModalClass({this.profileProfession});

  ProfessionModalClass.fromJson(Map<String, dynamic> json) {
    if (json['profile_profession'] != null) {
      profileProfession = <ProfileProfession>[];
      json['profile_profession'].forEach((v) {
        profileProfession!.add(new ProfileProfession.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profileProfession != null) {
      data['profile_profession'] =
          this.profileProfession!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProfileProfession {
  int? id;
  String? professionName;

  ProfileProfession({this.id, this.professionName});

  ProfileProfession.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    professionName = json['profession_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['profession_name'] = this.professionName;
    return data;
  }
}
