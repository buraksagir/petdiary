class Follow {
  int? id;
  String? followerUserName;
  int? followerUserId;
  String? followedUserName;
  int? followedUserId;
  String? createDate;


  Follow(
      {this.id,
      this.followerUserName,
      this.followerUserId,
      this.followedUserName,
      this.followedUserId,
      this.createDate,
     });

  Follow.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    followerUserName = json['followerUserName'];
    followerUserId = json['followerUserId'];
    followedUserName = json['followedUserName'];
    followedUserId = json['followedUserId'];
    createDate = json['createDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['followerUserName'] = followerUserName;
    data['followerUserId'] = followerUserId;
    data['followedUserName'] = followedUserName;
    data['followedUserId'] = followedUserId;
    data['createDate'] = createDate;
    return data;
  }
}

class FollowRequest {
  int? id;
  int? userId;
  String? profilePhoto;
  String? username;
  String? status;

  FollowRequest(
      {this.id, this.userId, this.profilePhoto, this.username, this.status});

  FollowRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    profilePhoto = json['profilePhoto'];
    username = json['username'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['profilePhoto'] = profilePhoto;
    data['username'] = username;
    data['status'] = status;
    return data;
  }
}
