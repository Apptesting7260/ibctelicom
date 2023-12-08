class PersonalityTraitsOptionsModalClass {
  String? status;
  String? message;
  List<String>? personalityTraitsOptions;

  PersonalityTraitsOptionsModalClass(
      {this.status, this.message, this.personalityTraitsOptions});

  PersonalityTraitsOptionsModalClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    personalityTraitsOptions =
        json['personality_traits_options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['personality_traits_options'] = this.personalityTraitsOptions;
    return data;
  }
}
