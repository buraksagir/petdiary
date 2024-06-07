import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petapp/cubit/follow/follow_cubit_state.dart';
import 'package:petapp/services/follow_service.dart';

class FollowCubit extends Cubit<FollowState> {
  FollowCubit() : super(const FollowState());
  late final FollowService _followService = FollowService();

  Future<void> follow(String followerId, String followedId) async {
    emit(state.copyWith(isFollowing: false));
    try {
      await _followService.follow(followerId, followedId);
      emit(state.copyWith(isFollowing: true, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isFollowing: false));
    }
  }

  Future<void> sentRequest(String followerId, String followedId) async {
    emit(state.copyWith(isRequestSent: false));
    try {
      await _followService.follow(followerId, followedId);
      emit(state.copyWith(isRequestSent: true));
    } catch (e) {
      emit(state.copyWith(isRequestSent: false));
    }
  }

  Future<void> acceptFollowRequest(String followerId, String requestId) async {
    emit(state.copyWith(isRequestAccepted: false));
    try {
      await _followService.acceptFollowRequest(followerId, requestId);
      emit(state.copyWith(isRequestAccepted: true));
    } catch (e) {
      log('Error: $e');
      emit(state.copyWith(isRequestAccepted: false));
    }
  }

  Future<void> rejectFollowRequest(String followerId, String requestId) async {
    emit(state.copyWith(isRequestDenied: false));
    try {
      await _followService.rejectFollowRequest(followerId, requestId);
      emit(state.copyWith(isRequestDenied: true));
    } catch (e) {
      log('Error: $e');
      emit(state.copyWith(isRequestDenied: false));
    }
  }

  Future<void> getFollowingOfUser(String followerId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final follows = await _followService.getFollowingOfUser(followerId);
      emit(state.copyWith(
        follows: follows,
        isLoaded: true,
        isLoading: false,
      ));
    } catch (e) {
      log('Error: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> deleteFollowRequest(String senderId, String receiverId) async {
    emit(state.copyWith(isRequestDeleted: false, isRequestSent: true));
    try {
      await _followService.deleteFollowRequest(senderId, receiverId);
      emit(state.copyWith(isRequestDeleted: true, isRequestSent: false));
    } catch (e) {
      log("Error $e");
      emit(state.copyWith(isRequestDeleted: false, isRequestSent: true));
    }
  }

  Future<void> getUsersFollowRequests(String? userId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final follows = await _followService.getUsersFollowRequests(userId!);
      emit(state.copyWith(
          followRequests: follows,
          isLoaded: true,
          isLoading: false,
          testLoaded: follows.isEmpty ? false : true));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> unfollow(String followerId, String followedId) async {
    emit(state.copyWith(isFollowing: true));
    try {
      await _followService.unfollow(followerId, followedId);
      emit(state.copyWith(isFollowing: false));
    } catch (e) {
      emit(state.copyWith(isFollowing: true));
    }
  }
}
