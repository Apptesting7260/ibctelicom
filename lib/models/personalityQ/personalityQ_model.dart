class PersonalityQModalClass {
  List<PersonalityQuesstions>? personalityQuesstions;

  PersonalityQModalClass({this.personalityQuesstions});

  PersonalityQModalClass.fromJson(Map<String, dynamic> json) {
    if (json['personality_quesstions'] != null) {
      personalityQuesstions = <PersonalityQuesstions>[];
      json['personality_quesstions'].forEach((v) {
        personalityQuesstions!.add(new PersonalityQuesstions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.personalityQuesstions != null) {
      data['personality_quesstions'] =
          this.personalityQuesstions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PersonalityQuesstions {
  int? id;
  String? question;
  List<String>? answer;

  PersonalityQuesstions({this.id, this.question, this.answer});

  PersonalityQuesstions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['answer'] = this.answer;
    return data;
  }
}
