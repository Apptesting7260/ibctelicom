class ColorModalClass {
  List<ProfileColour>? profileColour;

  ColorModalClass({this.profileColour});

  ColorModalClass.fromJson(Map<String, dynamic> json) {
    if (json['profile_colour'] != null) {
      profileColour = <ProfileColour>[];
      json['profile_colour'].forEach((v) {
        profileColour!.add(new ProfileColour.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profileColour != null) {
      data['profile_colour'] =
          this.profileColour!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProfileColour {
  int? id;
  String? colorName;

  ProfileColour({this.id, this.colorName});

  ProfileColour.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    colorName = json['color_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['color_name'] = this.colorName;
    return data;
  }
}
