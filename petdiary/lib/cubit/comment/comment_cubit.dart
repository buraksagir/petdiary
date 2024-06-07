import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petapp/services/comment_service.dart';

import 'comment_cubit_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit() : super(const CommentState());
  late final CommentService _commentService = CommentService();

  Future<void> sendComment(String userId, String postId, String text) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await _commentService.sendComment(userId, postId, text);
      emit(state.copyWith(isLoaded: true, isShared: response));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> getCommentsByPostId(String postId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await _commentService.getCommentsByPostId(postId);
      emit(
          state.copyWith(isLoaded: true, isLoading: false, comments: response));
    } catch (e) {
      emit(state.copyWith(isLoaded: false, isLoading: false));
    }
  }
}
