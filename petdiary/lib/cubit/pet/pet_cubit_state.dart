import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';

class PetState extends Equatable {
  final bool isLoading;
  final bool isLoaded;
  final bool isCreated;
  final List<Pet>? petModel;
  final List<Pet>? petListModel;
  final bool isDeleted;
  final bool isUpdated;

  const PetState(
      {this.isLoading = false,
      this.isLoaded = false,
      this.isCreated = false,
      this.petModel,
      this.petListModel,
      this.isDeleted = false,
      this.isUpdated = false});

  @override
  List<Object?> get props => [
        isLoading,
        isLoaded,
        isCreated,
        petModel,
        petListModel,
        isDeleted,
        isUpdated
      ];

  PetState copyWith(
      {bool? isLoading,
      bool? isLoaded,
      bool? isCreated,
      List<Pet>? petModel,
      List<Pet>? petListModel,
      bool? isDeleted,
      bool? isUpdated}) {
    return PetState(
        isLoading: isLoading ?? false,
        isLoaded: isLoaded ?? false,
        isCreated: isCreated ?? false,
        petModel: petModel ?? this.petModel,
        petListModel: petListModel ?? this.petListModel,
        isDeleted: isDeleted ?? false,
        isUpdated: isUpdated ?? false);
  }
}
