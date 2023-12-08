class ChatGPT_responseModalClass {
  int? code;
  String? message;
  Data? data;

  ChatGPT_responseModalClass({this.code, this.message, this.data});

  ChatGPT_responseModalClass.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? conversation;

  Data({this.conversation});

  Data.fromJson(Map<String, dynamic> json) {
    conversation = json['conversation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conversation'] = this.conversation;
    return data;
  }
}
