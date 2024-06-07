import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petdiary/cubit/auth/login_cubit_state.dart';
import 'package:petdiary/services/auth_service.dart';

import '../../generated/locale_keys.g.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());
  late final AuthService authService = AuthService();

  Future<void> login(String userName, String password) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final token = await authService.login(userName, password);
      emit(state.copyWith(
          tokenModel: token, isLoaded: true, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, errorMessage: LocaleKeys.loginFailed.tr()));
    }
  }

  Future<void> getToken(String userName, String password) async {
    emit(state.copyWith(credidentalLoading: true));
    try {
      final token = await authService.login(userName, password);
      emit(state.copyWith(
          credidentalCheck: token, credidentalLoaded: true, isEmpty: false));
    } catch (e) {
      log("getToken error : \n$e");
      emit(
        state.copyWith(
          credidentalLoading: false,
          errorMessage: LocaleKeys.wrongPassword.tr(),
          credidentalCheck: null,
          isEmpty: true,
        ),
      );
    }
  }

  void reset() {
    emit((const LoginState()));
  }
}
