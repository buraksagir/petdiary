import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/user_service.dart';
import 'user_cubit_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState());
  late final UserService userService = UserService();

  Future<void> getUser() async {
    emit(state.copyWith(isPostUserLoading: true));
    try {
      final users = await userService.getUser();
      emit(state.copyWith(postUserListModel: users, isPostUserLoaded: true));
    } catch (e) {
      emit(state.copyWith(isPostUserLoading: false));
    }
  }
}

class SingleUserCubit extends Cubit<SingleUserState> {
  SingleUserCubit() : super(const SingleUserState());
  late final UserService userService = UserService();

  Future<void> getUserById(String userId) async {
    emit(state.copyWith(isLoading: true, isPostUserLoading: true));
    try {
      final user = await userService.getUserById(userId);
      emit(state.copyWith(
          userListModel: user,
          isLoaded: true,
          postUserListModel: user,
          isPostUserLoaded: true));
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isPostUserLoaded: false, isPostUserLoading: false));
    }
  }

  Future<void> getUserByUserName(String userKey) async {
    emit(state.copyWith(isSearchLoading: true));
    try {
      final users = await userService.getUserByUserName(userKey);
      emit(state.copyWith(searchUserListModel: users, isSearchLoaded: true));
    } catch (e) {
      emit(state.copyWith(isSearchLoading: false));
    }
  }
}

class MyUserCubit extends Cubit<MyUserState> {
  MyUserCubit() : super(const MyUserState());
  late final UserService userService = UserService();

  Future<void> getMyUserById(String userId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = await userService.getUserById(userId);
      emit(state.copyWith(userListModel: user, isLoaded: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> editUserInfo(String userId,
      [String? userName,
      String? mail,
      String? password,
      String? phone,
      String? bio,
      String? name,
      String? surname,
      File? photo]) async {
    emit(state.copyWith(isLoading: true));
    try {
      await userService.editUserInfo(
          userId, userName, mail, password, phone, bio, name, surname, photo);
      emit(state.copyWith(isLoaded: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> deleteUser(String userId) async {
    emit(state.copyWith(isLoading: true));

    try {
      await userService.deleteUser(userId);
      emit(state.copyWith(isLoaded: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      log('User not deleted $e');
    }
  }

  Future<void> changeProfileLock(String userId, bool value) async {
    emit(state.copyWith(isLoading: true));
    try {
      await userService.changeProfileLock(userId, value);
      emit(state.copyWith(isLoaded: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      log("error while changing profileLock :/user_cubit.dart \nerror:$e");
    }
  }
}
