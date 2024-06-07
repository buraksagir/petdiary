import 'dart:developer';

import 'package:dio/dio.dart';

import 'network_manager.dart';

abstract class ILikeService {
  ILikeService();
  Future<bool> likePost(String userId, String postId);
  Future<bool> dislike(String userId, String postId);
}

class LikeService extends ILikeService {
  LikeService() : super();
  final Dio dio = NetworkManager.getInstance();

  @override
  Future<bool> likePost(String userId, String postId) async {
    try {
      final response =
          await dio.post('/likes', data: {'userId': userId, 'postId': postId});
      if (response.statusCode == 200) {
        log('Post liked successfully\n userId:$userId\npostId:$postId');
        return true;
      } else {
        log('Failed to like post\n userId:$userId\npostId:$postId');
        return false;
      }
    } catch (error) {
      log('Error liking post: \n$error');
      return false;
    }
  }

  @override
  // ignore: avoid_renaming_method_parameters
  Future<bool> dislike(String postId, String userId) async {
    try {
      final response = await dio.delete('/likes/$postId/$userId');
      if (response.statusCode == 200) {
        log('Post disliked successfully\n userId:$userId\npostId:$postId');
        return true;
      } else {
        log('Failed to dislike post \n${response.statusCode}\n userId:$userId\npostId:$postId');
        return false;
      }
    } catch (error) {
      log('Error disliking post: $error');
      return false;
    }
  }
}
