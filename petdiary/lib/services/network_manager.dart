import 'package:dio/dio.dart';

import 'shared_preferences.dart';

class NetworkManager {
  static final Dio _dio = Dio(BaseOptions(baseUrl: 'https://petdiary.net:81'));

  static final SharedPreferencesUtils _sharedPreferencesUtils =
      SharedPreferencesUtils();

  static Dio getInstance() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _sharedPreferencesUtils.getToken();

        if (token != null) {
          options.headers["Authorization"] = token;
        }
        options.extra["cors"] = true;
        return handler.next(options);
      },
    ));
    return _dio;
  }
}
