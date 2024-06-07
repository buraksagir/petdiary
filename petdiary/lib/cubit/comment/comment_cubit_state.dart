import 'package:equatable/equatable.dart';

import '../../data/models/post_model.dart';

class CommentState extends Equatable {
  final bool isLoading;
  final bool isLoaded;
  final bool? isShared;
  final List<Comments>? comments;

  const CommentState(
      {this.isLoading = false,
      this.isLoaded = false,
      this.isShared,
      this.comments});

  @override
  List<Object?> get props => [isLoading, isLoaded, isShared, comments];

  CommentState copyWith(
      {bool? isLoading,
      bool? isLoaded,
      bool? isShared,
      List<Comments>? comments}) {
    return CommentState(
        isLoading: isLoading ?? false,
        isLoaded: isLoaded ?? false,
        isShared: isShared,
        comments: comments);
  }
}
