import 'package:petdiary/data/models/post_model.dart';

class User {
  int? id;
  String? userName;
  String? mail;
  String? password;
  String? phone;
  String? bio;
  String? name;
  String? surname;
  String? photo;
  List<Followers>? followers;
  List<Following>? following;
  bool? profileLock;
  List<Pet>? pets;

  User(
      {this.id,
      this.userName,
      this.mail,
      this.password,
      this.phone,
      this.bio,
      this.name,
      this.surname,
      this.photo,
      this.followers,
      this.following,
      this.profileLock,
      this.pets});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    mail = json['mail'];
    password = json['password'];
    phone = json['phone'];
    bio = json['bio'];
    name = json['name'];
    surname = json['surname'];
    photo = json['photo'];
    if (json['followers'] != null) {
      followers = <Followers>[];
      json['followers'].forEach((v) {
        followers!.add(Followers.fromJson(v));
      });
    }
    if (json['following'] != null) {
      following = <Following>[];
      json['following'].forEach((v) {
        following!.add(Following.fromJson(v));
      });
    }
    profileLock = json['profileLock'];
    if (json['pets'] != null) {
      pets = <Pet>[];
      json['pets'].forEach((v) {
        pets!.add(Pet.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userName'] = userName;
    data['mail'] = mail;
    data['password'] = password;
    data['phone'] = phone;
    data['bio'] = bio;
    data['name'] = name;
    data['surname'] = surname;
    data['photo'] = photo;
    if (followers != null) {
      data['followers'] = followers!.map((v) => v.toJson()).toList();
    }
    if (following != null) {
      data['following'] = following!.map((v) => v.toJson()).toList();
    }
    data['profileLock'] = profileLock;
    if (pets != null) {
      data['pets'] = pets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Followers {
  int? id;
  String? followerUserName;
  int? followerUserId;
  String? followedUserName;
  int? followedUserId;
  String? createDate;

  Followers(
      {this.id,
      this.followerUserName,
      this.followerUserId,
      this.followedUserName,
      this.followedUserId,
      this.createDate});

  Followers.fromJson(Map<String, dynamic> json) {
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

class Pet {
  int? id;
  String? petName;
  int? userId;
  List<int>? posts;

  Pet({this.id, this.petName, this.userId, this.posts});

  Pet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    petName = json['petName'];
    userId = json['userId'];
    posts = json['posts'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['petName'] = petName;
    data['userId'] = userId;
    data['posts'] = posts;
    return data;
  }
}
