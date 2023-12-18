




import 'package:get/get.dart';
import 'package:nauman/global_variables.dart';

class FavouriteListModalClass {
  String? status;
  RxList<UserFavouriteList>? userFavouriteList;

  FavouriteListModalClass({this.status, this.userFavouriteList});

  FavouriteListModalClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['user_favourite_list'] != null) {
      userFavouriteList = <UserFavouriteList>[].obs;
      json['user_favourite_list'].forEach((v) {
        userFavouriteList!.add(new UserFavouriteList.fromJson(v));
      });
    }
    if(userFavouriteList != null && userFavouriteList!.isNotEmpty){
      print('fav no empty');
      if(userFavouriteList!.length < 6){
        callFavPagination.value = false;
           noDataFav.value = true;
      }
      if(userFavouriteList!.length == 6){
         pageFav++;
         callFavPagination.value = true;
      }
         FavouriteDataList.addAll(userFavouriteList as Iterable<UserFavouriteList>);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.userFavouriteList != null) {
      data['user_favourite_list'] =
          this.userFavouriteList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserFavouriteList {
 
  String? userName;
 int? block_status;
 
  String? proImgUrl;
  UserDetails? userDetails;
 

  UserFavouriteList(
      {
      this.userName,
      this.block_status,
    
      this.proImgUrl,
      this.userDetails,
  });

  UserFavouriteList.fromJson(Map<String, dynamic> json) {
 
    userName = json['user_name'];
    block_status = json['block_status'];
   
    proImgUrl = json['pro_img_url'];
    userDetails = json['user_details'] != null
        ? new UserDetails.fromJson(json['user_details'])
        : null;
  
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
   
    data['user_name'] = this.userName;
    data['block_status'] = this.block_status;
   
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








