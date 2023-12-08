
import 'package:get/get.dart';
import 'package:nauman/global_variables.dart';

////////////////////////////////// *********************************
class HomeModalClass {
  String? status;
  RxList<CandidateList>? candidateList;

  HomeModalClass({this.status, this.candidateList});

  HomeModalClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['candidate_list'] != null) {
      candidateList = <CandidateList>[].obs;
      json['candidate_list'].forEach((v) {
        candidateList!.add(new CandidateList.fromJson(v));
      });
    }
    if(candidateList != null && candidateList!.isNotEmpty){
             print('yES NOT EMPTY');
             if(candidateList!.length < 10){
              noDataHome.value = true;
              callHomePagination.value = false;
             }
             
             if(candidateList!.length == 10){
               page++;
               callHomePagination.value = true;
             }
             
          HomeDataList.addAll(candidateList as Iterable<CandidateList>)  ;

    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.candidateList != null) {
      data['candidate_list'] =
          this.candidateList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CandidateList {
  
  String? userName;
  String? proImgUrl;
  UserDetails? userDetails;
 

  CandidateList(
      {
      this.userName,
      
      this.proImgUrl,
      this.userDetails,
     });

  CandidateList.fromJson(Map<String, dynamic> json) {
    
    userName = json['user_name'];
   
    proImgUrl = json['pro_img_url'];
    userDetails = json['user_details'] != null
        ? new UserDetails.fromJson(json['user_details'])
        : null;
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
  
    data['user_name'] = this.userName;
   
    data['pro_img_url'] = this.proImgUrl;
    if (this.userDetails != null) {
      data['user_details'] = this.userDetails!.toJson();
    }
    
    return data;
  }
}

class UserDetails {
 
  int? userId;
 
  String? profession;
  int? average_rating;

  UserDetails(
      {
      this.userId,
   
      this.profession,
      this.average_rating,
    });

  UserDetails.fromJson(Map<String, dynamic> json) {
  
    userId = json['user_id'];
  
    profession = json['profession'];
    
    average_rating = json['average_rating'];
  
   
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
   
    data['user_id'] = this.userId;
   
   
    data['profession'] = this.profession;
    data['average_rating'] = this.average_rating;

   
    return data;
  }
}








