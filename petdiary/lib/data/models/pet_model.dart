import 'post_model.dart';

class PetTest {
  int? id;
  String? petName;
  int? userId;
  List<Post>? posts;

  PetTest({this.id, this.petName, this.userId, this.posts});

  PetTest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    petName = json['petName'];
    userId = json['userId'];
    if (json['posts'] != null) {
      posts = <Post>[];
      json['posts'].forEach((v) {
        posts!.add(Post.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['petName'] = petName;
    data['userId'] = userId;
    if (posts != null) {
      data['posts'] = posts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
