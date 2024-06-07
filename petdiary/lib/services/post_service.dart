import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';

import '../data/models/post_model.dart';
import 'network_manager.dart';

abstract class IPostService {
  IPostService();

  Future<List<Post>> getOwnPost(String userId);
  Future<List<FollowingPost>> getPostByFollowing(String userId);
  Future<List<Post>> getPostByUserId(String userId);
  Future<List<Post>> getPostByPostId(String postId);
  Future<void> createPost(
      File? photo, String text, String contextId, String? petId);
}

class PostService extends IPostService {
  PostService() : super();
  final Dio dio = NetworkManager.getInstance();

  @override
  Future<List<Post>> getOwnPost(String userId) async {
    try {
      final response = await dio.get('/posts/$userId');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load own posts');
      }
    } catch (error) {
      throw Exception('Failed to load own posts: $error');
    }
  }

  @override
  Future<List<FollowingPost>> getPostByFollowing(String userId) async {
    try {
      final response = await dio.get('/posts/follow/$userId');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => FollowingPost.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load following posts');
      }
    } catch (error) {
      throw Exception('Failed to load following posts: $error');
    }
  }

  @override
  Future<List<Post>> getPostByUserId(String userId) async {
    try {
      final response = await dio.get('/posts/$userId');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load user posts');
      }
    } catch (error) {
      log("PostData error: \n$error");
      throw Exception('Failed to load user posts: $error');
    }
  }

  @override
  Future<List<Post>> getPostByPostId(String postId) async {
    try {
      final response = await dio.get('/posts/$postId');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load post by post ID');
      }
    } catch (error) {
      throw Exception('Failed to load post by post ID: $error');
    }
  }

  @override
  Future<void> createPost(
      File? photo, String text, String contextId, String? petId) async {
    if (photo == null) {
      throw Exception('Photo file is null');
    }
    try {
      FormData formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(photo.path,
            filename: '$contextId post.jpg'),
        'text': text,
        'userId': contextId,
        'petId': petId,
      });
      final response = await dio.post('/posts', data: formData);
      if (response.statusCode == 201) {
        log("Post shared");
      } else {
        throw Exception('Failed to create post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error while creating post: $e');
    }
  }
}
