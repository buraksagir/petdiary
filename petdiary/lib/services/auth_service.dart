import 'package:dio/dio.dart';
import '../data/models/auth_models/token_model.dart';
import 'network_manager.dart';

abstract class IAuthService {
  IAuthService();

  Future<TokenModel?> login(String userName, String password);
  Future<TokenModel?> register(String userName, String password, String name,
      String surname, String mail, String phone);
}

class AuthService extends IAuthService {
  AuthService() : super();
  final Dio dio = NetworkManager.getInstance();

  @override
  Future<TokenModel?> login(String userName, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'userName': userName, 'password': password},
      );

      if (response.statusCode == 200) {
        var jsonBody = response.data;
        return TokenModel.fromJson(jsonBody);
      } else {
        throw Exception('Authentication failed');
      }
    } catch (error) {
      throw Exception('Failed to login: $error');
    }
  }

  @override
  Future<TokenModel?> register(String userName, String password, String name,
      String surname, String mail, String phone) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: {
          'userName': userName,
          'password': password,
          'name': name,
          'surname': surname,
          'mail': mail,
          'phone': phone
        },
      );

      if (response.statusCode == 201) {
        var jsonBody = response.data;
        return TokenModel.fromJson(jsonBody);
      } else {
        throw Exception('Registration failed');
      }
    } catch (error) {
      throw Exception('Failed to register: $error');
    }
  }
}
