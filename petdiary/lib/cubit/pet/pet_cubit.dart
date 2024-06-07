import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:petapp/services/pet_service.dart';
import 'pet_cubit_state.dart';

class PetCubit extends Cubit<PetState> {
  PetCubit() : super(const PetState());
  late final PetService petService = PetService();

  Future<void> createPet(String userId, String petName) async {
    emit(state.copyWith(isLoading: true, isLoaded: false)); //Loading state
    try {
      await petService.createPet(userId, petName);
      emit(state.copyWith(isCreated: true, isLoaded: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, isLoaded: false));
    }
  }

  Future<void> deletePet(String petId) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));
    try {
      await petService.deletePet(petId);
      emit(state.copyWith(isDeleted: true));
    } catch (e) {
      log("Pet not deleted $e");
    }
  }

  Future<void> changePetName(
      String petId, String userId, String newPetName) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));
    try {
      await petService.changePetName(petId, newPetName, userId);
      emit(state.copyWith(isUpdated: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, isLoaded: false, isUpdated: false));
      log("Pet not deleted $e");
    }
  }
}
