import 'package:equatable/equatable.dart';
import 'package:petdiary/data/models/post_model.dart';

class MyPostState extends Equatable {
  final bool isLoading;
  final bool isLoaded;
  final List<Post>? postModel;
  final List<Post>? userPostModel;
  final List<FollowingPost>? followingPostModel;
  final bool isPosted;
  final bool isDeleting;
  final bool isDeleted;

  const MyPostState(
      {this.isLoading = false,
      this.isLoaded = false,
      this.postModel,
      this.userPostModel,
      this.followingPostModel,
      this.isPosted = false,
      this.isDeleting = false,
      this.isDeleted = false});

  @override
  List<Object?> get props => [
        isLoading,
        postModel,
        isLoaded,
        followingPostModel,
        userPostModel,
        isPosted,
        isDeleting,
        isDeleted
      ];

  MyPostState copyWith(
      {bool? isLoading,
      List<Post>? postModel,
      bool? isLoaded,
      List<Post>? userPostModel,
      List<FollowingPost>? followingPostModel,
      bool? isPosted,
      bool? isDeleting,
      bool? isDeleted}) {
    return MyPostState(
        isLoading: isLoading ?? false,
        postModel: postModel ?? this.postModel,
        isLoaded: isLoaded ?? false,
        userPostModel: userPostModel ?? this.userPostModel,
        followingPostModel: followingPostModel ?? this.followingPostModel,
        isPosted: isPosted ?? false,
        isDeleting: isDeleting ?? false,
        isDeleted: isDeleted ?? false);
  }
}

class PostState extends Equatable {
  final bool isLoading;
  final bool isLoaded;
  final List<Post>? postModel;
  final List<Post>? userPostModel;
  final List<FollowingPost>? followingPostModel;

  const PostState(
      {this.isLoading = false,
      this.isLoaded = false,
      this.postModel,
      this.userPostModel,
      this.followingPostModel});

  @override
  List<Object?> get props =>
      [isLoading, postModel, isLoaded, followingPostModel, userPostModel];

  PostState copyWith(
      {bool? isLoading,
      List<Post>? postModel,
      bool? isLoaded,
      List<Post>? userPostModel,
      List<FollowingPost>? followingPostModel}) {
    return PostState(
        isLoading: isLoading ?? false,
        postModel: postModel ?? this.postModel,
        isLoaded: isLoaded ?? false,
        userPostModel: userPostModel ?? this.userPostModel,
        followingPostModel: followingPostModel ?? this.followingPostModel);
  }
}
