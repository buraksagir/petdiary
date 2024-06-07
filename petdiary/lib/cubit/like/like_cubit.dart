import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/like_service.dart';
import 'like_cubit_state.dart';

class LikeCubit extends Cubit<LikeState> {
  LikeCubit() : super(const LikeState());
  late final LikeService _likeService = LikeService();

  Future<void> likePost(String userId, String postId) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _likeService.likePost(userId, postId);
      emit(state.copyWith(isLiked: true, isLoaded: true, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> dislikePost(String postId, String userId) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _likeService.dislike(postId, userId);
      emit(state.copyWith(isLiked: false, isLoaded: true, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
