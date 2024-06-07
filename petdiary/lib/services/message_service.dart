import 'dart:developer';

import 'package:dio/dio.dart';

import '../data/models/message_model.dart';
import 'network_manager.dart';

abstract class IMessageService {
  Future<void> sendMessage(String contextUserId, String userId, String message);
  Future<List<Message>?> getAllMessagesByUserId(String contextUserId);
  Future<List<Message>?> getAllMessagesByReceiverSenderId(
      String contextUserId, String userId);
}

class MessageService extends IMessageService {
  final Dio dio = NetworkManager.getInstance();
  @override
  Future<List<Message>?> getAllMessagesByReceiverSenderId(
      String contextUserId, String userId) async {
    try {
      final response = await dio.get('/chat/messages/$contextUserId/$userId');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => Message.fromJson(json)).toList();
      }
    } catch (e) {
      log("getMessage error: $e");
    }
    return null;
  }

  @override
  Future<void> sendMessage(
      String contextUserId, String userId, String message) async {
    try {
      final response = await dio.post('/chat/send', data: {
        'senderId': contextUserId,
        'receiverId': contextUserId,
        'message': message
      });
      if (response.statusCode == 201) {
        log("Message sent to user $userId");
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Future<List<Message>?> getAllMessagesByUserId(String contextUserId) async {
    try {
      final response = await dio.get('/chat/messages/$contextUserId');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => Message.fromJson(json)).toList();
      }
    } catch (e) {
      log("getMessage error: $e");
    }
    return null;
  }
}
