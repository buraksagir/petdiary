class FollowingPost {
  int? userId;
  List<Following>? following;
  List<Post>? posts;

  FollowingPost({this.userId, this.following, this.posts});

  FollowingPost.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    if (json['following'] != null) {
      following = <Following>[];
      json['following'].forEach((v) {
        following!.add(Following.fromJson(v));
      });
    }
    if (json['posts'] != null) {
      posts = <Post>[];
      json['posts'].forEach((v) {
        posts!.add(Post.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    if (following != null) {
      data['following'] = following!.map((v) => v.toJson()).toList();
    }
    if (posts != null) {
      data['posts'] = posts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Following {
  int? id;
  String? followerUserName;
  String? followedUserName;

  Following({this.id, this.followerUserName, this.followedUserName});

  Following.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    followerUserName = json['followerUserName'];
    followedUserName = json['followedUserName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['followerUserName'] = followerUserName;
    data['followedUserName'] = followedUserName;
    return data;
  }
}

class Post {
  int? id;
  int? userId;
  String? userName;
  String? photo;
  String? text;
  String? createDate;
  List<int>? petIds;
  List<String>? petName;
  List<PostLikes>? postLikes;
  List<Comments>? comments;
  bool? isLikedByCurrentUser;

  Post(
      {this.id,
      this.userId,
      this.userName,
      this.photo,
      this.text,
      this.createDate,
      this.petIds,
      this.petName,
      this.postLikes,
      this.comments,
      this.isLikedByCurrentUser});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    userName = json['userName'];
    photo = json['photo'];
    text = json['text'];
    createDate = json['createDate'];
    petIds = json['petIds'].cast<int>();
    petName = json['petName'].cast<String>();
    if (json['postLikes'] != null) {
      postLikes = <PostLikes>[];
      json['postLikes'].forEach((v) {
        postLikes!.add(PostLikes.fromJson(v));
      });
    }
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['userName'] = userName;
    data['photo'] = photo;
    data['text'] = text;
    data['createDate'] = createDate;
    data['petIds'] = petIds;
    data['petName'] = petName;
    if (postLikes != null) {
      data['postLikes'] = postLikes!.map((v) => v.toJson()).toList();
    }
    if (comments != null) {
      data['comments'] = comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PostLikes {
  int? id;
  int? userId;
  int? postId;

  PostLikes({this.id, this.userId, this.postId});

  PostLikes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    postId = json['postId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['postId'] = postId;
    return data;
  }
}

class Comments {
  int? id;
  String? comment;
  String? userName;
  int? postId;

  Comments({this.id, this.comment, this.userName, this.postId});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    userName = json['userName'];
    postId = json['postId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['userName'] = userName;
    data['postId'] = postId;
    return data;
  }
}
