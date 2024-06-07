import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petdiary/cubit/post/post_cubit_state.dart';
import 'package:petdiary/services/post_service.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(const PostState());
  late final PostService postService = PostService();

  Future<void> getPostByFollowing(String userId) async {
    emit(state.copyWith(isLoading: true, isLoaded: false)); //Loading state
    try {
      final posts = await postService.getPostByFollowing(userId);
      emit(state.copyWith(
          followingPostModel: posts, isLoaded: true)); // Loaded state
    } catch (e) {
      // Error state
      emit(state.copyWith(isLoading: false, isLoaded: false));
    }
  }

  Future<void> getPostByPostId(String postId) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));
    try {
      final posts = await postService.getPostByPostId(postId);
      emit(state.copyWith(postModel: posts, isLoaded: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, isLoaded: false));
    }
  }

  Future<void> getPostByUserId(String userId) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));
    try {
      final posts = await postService.getPostByUserId(userId);
      emit(state.copyWith(userPostModel: posts, isLoaded: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, isLoaded: false));
    }
  }
}

class MyPostCubit extends Cubit<MyPostState> {
  MyPostCubit() : super(const MyPostState());

  late final PostService postService = PostService();

  Future<void> getOwnPost(String userId) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));
    try {
      final posts = await postService.getOwnPost(userId);
      emit(state.copyWith(userPostModel: posts, isLoaded: true));
    } catch (e) {
      if (kDebugMode) {
        print("$e");
      }
    }
  }

  Future<void> createPost(
      File photo, String text, String contextId, String? petId) async {
    emit(state.copyWith(isPosted: false));
    try {
      await postService.createPost(photo, text, contextId, petId);
      emit(state.copyWith(isPosted: true));
    } catch (e) {
      emit(state.copyWith(isPosted: false));
    }
  }
}
