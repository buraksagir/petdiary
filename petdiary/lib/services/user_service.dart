import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import '../data/models/user_model.dart';
import 'network_manager.dart';

abstract class IUserService {
  IUserService();

  Future<List<User>> getUser();
  Future<List<User>> getUserByUserName(String userName);
  Future<List<User>> getUserById(String userId);
  Future<void> editUserInfo(String userId);
  Future<void> deleteUser(String userId);
  Future<void> changeProfileLock(String userId, bool value);
}

class UserService extends IUserService {
  UserService() : super();

  final Dio dio = NetworkManager.getInstance();

  @override
  Future<List<User>> getUser() async {
    try {
      final response = await dio.get('/users');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => User.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  @override
  Future<List<User>> getUserById(String userId) async {
    try {
      final response = await dio.get('/users/$userId');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => User.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  @override
  Future<List<User>> getUserByUserName(String userName) async {
    try {
      final response = await dio.get('/users/search/$userName');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => User.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      log("getUserByUserName error: \n$e");
      return [];
    }
  }

  @override
  Future<void> editUserInfo(String userId,
      [String? userName,
      String? mail,
      String? password,
      String? phone,
      String? bio,
      String? name,
      String? surname,
      File? photo]) async {
    if (photo != null) {
      try {
        FormData formData = FormData.fromMap({
          'userName': userName,
          'mail': mail,
          'password': password,
          'phone': phone,
          'bio': bio,
          'name': name,
          'surname': surname,
          'photo':
              await MultipartFile.fromFile(photo.path, filename: 'asdasd.jpg'),
        });

        final response = await dio.put('/users/$userId', data: formData);

        if (response.statusCode == 200) {
          log('User information edited\nUserId=$userId\nResponse=${response.statusCode}');
        }
      } catch (e) {
        log('editUserInfo error:\n$e');
      }
    } else {
      try {
        FormData formData = FormData.fromMap({
          'userName': userName,
          'mail': mail,
          'password': password,
          'phone': phone,
          'bio': bio,
          'name': name,
          'surname': surname,
        });

        final response = await dio.put('/users/$userId', data: formData);

        if (response.statusCode == 200) {
          log('User information edited\nUserId=$userId\nResponse=${response.statusCode}');
        }
      } catch (e) {
        log('editUserInfo error:\n$e');
      }
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      final response = await dio.delete('users/$userId');

      if (response.statusCode == 200) {
        log('User deleted successfully User Id: $userId');
      }
    } catch (e) {
      log("DeleteUser error :\n$e");
    }
  }

  @override
  Future<void> changeProfileLock(String userId, bool value) async {
    try {
      final response =
          await dio.put('/users/$userId/privacy', data: {'profileLock': value});
      if (response.statusCode == 200) {
        log("UserId : $userId changed profileLock successfully to $value");
      }
    } catch (e) {
      log("changeProfileLock error: \n$e");
    }
  }
}
