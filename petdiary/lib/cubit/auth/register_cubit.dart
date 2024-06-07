import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petdiary/cubit/auth/register_cubit_state.dart';
import 'package:petdiary/services/auth_service.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(const RegisterState());
  late final AuthService authService = AuthService();

  Future<void> register(String userName, String password, String name,
      String surname, String mail, String phone) async {
    emit(state.copyWith(isLoading: true));
    try {
      final token = await authService.register(
          userName, password, name, surname, mail, phone);
      if (token != null) {
        emit(state.copyWith(tokenModel: token, isLoaded: true));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
