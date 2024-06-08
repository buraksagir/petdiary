import 'package:equatable/equatable.dart';
import 'package:petdiary/data/models/user_model.dart';

class SingleUserState extends Equatable {
  final bool isLoading;
  final bool isLoaded;
  final User? userModel;
  final List<User>? userListModel;
  final List<User>? searchUserListModel;
  final bool isSearchLoading;
  final bool isSearchLoaded;
  final bool isPostUserLoading;
  final bool isPostUserLoaded;
  final User? postUserModel;
  final List<User>? postUserListModel;

  const SingleUserState({
    this.isLoading = false,
    this.isLoaded = false,
    this.userModel,
    this.userListModel,
    this.isSearchLoading = false,
    this.isSearchLoaded = false,
    this.searchUserListModel,
    this.isPostUserLoading = false,
    this.isPostUserLoaded = false,
    this.postUserModel,
    this.postUserListModel,
  });

  @override
  List<Object?> get props => [
        isLoading,
        userModel,
        userListModel,
        isLoaded,
        isSearchLoading,
        isSearchLoaded,
        searchUserListModel,
        isPostUserLoading,
        postUserModel,
        postUserListModel,
        isPostUserLoaded
      ];

  SingleUserState copyWith({
    bool? isLoading,
    List<User>? userListModel,
    User? userModel,
    bool? isLoaded,
    bool? isSearchLoading,
    bool? isSearchLoaded,
    List<User>? searchUserListModel,
    bool? isPostUserLoading,
    bool? isPostUserLoaded,
    User? postUserModel,
    List<User>? postUserListModel,
  }) {
    return SingleUserState(
      isLoading: isLoading ?? false,
      userModel: userModel ?? this.userModel,
      isLoaded: isLoaded ?? false,
      userListModel: userListModel ?? this.userListModel,
      isSearchLoading: isSearchLoading ?? false,
      isSearchLoaded: isSearchLoaded ?? false,
      searchUserListModel: searchUserListModel ?? this.searchUserListModel,
      isPostUserLoading: isPostUserLoading ?? false,
      isPostUserLoaded: isPostUserLoaded ?? false,
      postUserModel: postUserModel ?? this.postUserModel,
      postUserListModel: postUserListModel ?? this.postUserListModel,
    );
  }
}

class UserState extends Equatable {
  final bool isPostUserLoading;
  final bool isPostUserLoaded;
  final User? postUserModel;
  final List<User>? postUserListModel;

  const UserState({
    this.isPostUserLoading = false,
    this.isPostUserLoaded = false,
    this.postUserModel,
    this.postUserListModel,
  });
  @override
  List<Object?> get props =>
      [isPostUserLoading, postUserModel, postUserListModel, isPostUserLoaded];

  UserState copyWith({
    bool? isPostUserLoading,
    bool? isPostUserLoaded,
    User? postUserModel,
    List<User>? postUserListModel,
  }) {
    return UserState(
      isPostUserLoading: isPostUserLoading ?? false,
      isPostUserLoaded: isPostUserLoaded ?? false,
      postUserModel: postUserModel ?? this.postUserModel,
      postUserListModel: postUserListModel ?? this.postUserListModel,
    );
  }
}

class MyUserState extends Equatable {
  final bool isLoading;
  final bool isLoaded;
  final User? userModel;
  final List<User>? userListModel;

  const MyUserState({
    this.isLoading = false,
    this.isLoaded = false,
    this.userModel,
    this.userListModel,
  });

  @override
  List<Object?> get props => [
        isLoading,
        userModel,
        userListModel,
        isLoaded,
      ];

  MyUserState copyWith({
    bool? isLoading,
    List<User>? userListModel,
    User? userModel,
    bool? isLoaded,
  }) {
    return MyUserState(
        isLoading: isLoading ?? false,
        userModel: userModel ?? this.userModel,
        isLoaded: isLoaded ?? false,
        userListModel: userListModel ?? this.userListModel);
  }
}
