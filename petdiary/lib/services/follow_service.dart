import 'dart:developer';
import 'package:dio/dio.dart';
import '../data/models/follow_model.dart';
import 'network_manager.dart';

abstract class IFollowService {
  IFollowService();
  Future<bool> follow(String followerId, String followedId);
  Future<bool> unfollow(String followerId, String followedId);
  Future<List<Follow>> getFollowingOfUser(String followerId);
  Future<List<FollowRequest>> getUsersFollowRequests(String userId);
  Future<bool> acceptFollowRequest(String followerId, String requestId);
  Future<bool> rejectFollowRequest(String followerId, String requestId);
  Future<bool> deleteFollowRequest(String senderId, String receiverId);
}

class FollowService extends IFollowService {
  FollowService() : super();
  final Dio dio = NetworkManager.getInstance();

  @override
  Future<bool> follow(String followerId, String followedId) async {
    try {
      final response = await dio.post('/follow',
          data: {'followerId': followerId, 'followedUserId': followedId});
      if (response.statusCode == 200) {
        log("Follow success\nfollower: $followerId\nfollowed:$followedId");
        return true;
      } else {
        log("Follow failed\nfollower: $followerId\nfollowed:$followedId ${response.statusCode}");
        return false;
      }
    } catch (error) {
      log("Follow failed\nfollower: $followerId\nfollowed:$followedId $error");
      return false;
    }
  }

  @override
  Future<bool> acceptFollowRequest(String followerId, String requestId) async {
    try {
      final response = await dio.post(
        '/follow/requests/accept/$followerId/$requestId',
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  @override
  Future<bool> rejectFollowRequest(String followerId, String requestId) async {
    try {
      final response = await dio.post(
        '/follow/requests/reject/$followerId/$requestId',
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  @override
  Future<List<FollowRequest>> getUsersFollowRequests(String userId) async {
    try {
      final response = await dio.get('/follow/requests/incoming/$userId');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => FollowRequest.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  @override
  Future<List<Follow>> getFollowingOfUser(String followerId) async {
    try {
      final response = await dio.get('/follow/follows/$followerId');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => Follow.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  @override
  Future<bool> unfollow(String followerId, String followedId) async {
    try {
      final response =
          await dio.delete('/follow/delete/$followerId/$followedId');
      if (response.statusCode == 200) {
        log("Unfollow success\nfollower: $followerId\nfollowed:$followedId");
        return true;
      } else {
        log("Unfollow fail\nfollower: $followerId\nfollowed:$followedId");

        return false;
      }
    } catch (error) {
      log("Unfollow error: \n$error");

      return false;
    }
  }

  @override
  Future<bool> deleteFollowRequest(String senderId, String receiverId) async {
    try {
      final response =
          await dio.delete('/follow/requests/delete/$senderId/$receiverId');
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("DeleteFollowRequest error: \n$e");
      return false;
    }
  }
}
