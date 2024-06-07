import 'package:equatable/equatable.dart';

class LikeState extends Equatable {
  final bool isLoading;
  final bool isLoaded;
  final bool? isLiked;
  const LikeState(
      {this.isLoading = false, this.isLoaded = false, this.isLiked});

  @override
  List<Object?> get props => [isLoading, isLiked, isLoaded];

  LikeState copyWith(
      {bool? isLoading,
      bool? isLoaded,
      bool? isLiked}) {
    return LikeState(
        isLoading: isLoading ?? false,
        isLiked: isLiked ?? this.isLiked,
        isLoaded: isLoaded ?? false);
  }
}
