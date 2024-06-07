import 'dart:developer';
import 'package:dio/dio.dart';
import '../data/models/post_model.dart';
import 'network_manager.dart';

abstract class ICommentService {
  ICommentService();

  Future<void> sendComment(String userId, String postId, String text);
  Future<List<Comments>>? getCommentsByPostId(String postId);
}

class CommentService extends ICommentService {
  CommentService() : super();
  final Dio dio = NetworkManager.getInstance();

  @override
  Future<bool> sendComment(String userId, String postId, String text) async {
    try {
      final response = await dio.post("/comments",
          data: {"userId": userId, "postId": postId, "text": text});
      if (response.statusCode == 200) {
        log("Comment shared ${response.statusCode}");
        return true;
      } else {
        log("");

        return false;
      }
    } catch (error) {
      log("Send Comment error: \n$error");

      return false;
    }
  }

  @override
  Future<List<Comments>>? getCommentsByPostId(String postId) async {
    try {
      final response = await dio.get('/comments/postId/$postId');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => Comments.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      log("Comments couldn't get \n $e");
      return [];
    }
  }
}
