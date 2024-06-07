import 'package:equatable/equatable.dart';
import 'package:petdiary/data/models/follow_model.dart';

class FollowState extends Equatable {
  final bool isLoading;
  final bool isLoaded;
  final bool? isRequestSent;
  final bool? isFollowing;
  final List<Follow>? follows;
  final List<FollowRequest>? followRequests;
  final bool isLoadingFollow;
  final bool isLoadedFollow;
  final bool testLoaded;
  final bool? isRequestAccepted;
  final bool? isRequestDenied;
  final bool? isRequestDeleted;
  FollowState updateIsLoaded(bool newValue) {
    return FollowState(isLoaded: newValue);
  }

  const FollowState({
    this.testLoaded = false,
    this.isLoading = false,
    this.isLoaded = false,
    this.isRequestSent,
    this.isFollowing,
    this.follows,
    this.followRequests,
    this.isLoadingFollow = false,
    this.isLoadedFollow = false,
    this.isRequestAccepted,
    this.isRequestDenied,
    this.isRequestDeleted,
  });

  @override
  List<Object?> get props => [
        isLoading,
        isRequestSent,
        isLoaded,
        follows,
        followRequests,
        isLoadedFollow,
        isLoadingFollow,
        isRequestAccepted,
        isRequestDenied,
        isRequestDeleted,
        testLoaded
      ];

  FollowState copyWith(
      {bool? isLoading,
      bool? isLoaded,
      bool? isRequestSent,
      bool? isFollowing,
      bool? isLoadingFollow,
      bool? isLoadedFollow,
      List<Follow>? follows,
      List<FollowRequest>? followRequests,
      bool? isRequestAccepted,
      bool? isRequestDenied,
      isRequestDeleted,
      bool? testLoaded}) {
    return FollowState(
      isLoading: isLoading ?? false,
      isRequestSent: isRequestSent ?? this.isRequestSent,
      isLoaded: isLoaded ?? false,
      isFollowing: isFollowing ?? this.isFollowing,
      follows: follows ?? this.follows,
      isLoadingFollow: isLoadingFollow ?? false,
      isLoadedFollow: isLoadedFollow ?? false,
      testLoaded: testLoaded ?? this.testLoaded,
      followRequests: followRequests ?? this.followRequests,
      isRequestAccepted: isRequestAccepted ?? this.isRequestAccepted,
      isRequestDenied: isRequestDenied ?? this.isRequestDenied,
      isRequestDeleted: isRequestDeleted ?? this.isRequestDeleted,
    );
  }
}
