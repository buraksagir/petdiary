import 'dart:developer';

import 'package:dio/dio.dart';

import 'network_manager.dart';

abstract class IPetService {
  IPetService();
  Future<void> createPet(String userId, String petName);
  Future<void> deletePet(String petId);
  Future<void> changePetName(String petId, String newPetName, String userId);
}

class PetService extends IPetService {
  PetService() : super();

  final Dio dio = NetworkManager.getInstance();
  @override
  Future<void> createPet(String userId, String petName) async {
    try {
      final response =
          await dio.post('/pets', data: {'userId': userId, 'petName': petName});
      if (response.statusCode == 200) {
        log("Pet created");
      }
    } catch (e) {
      log('Error while creating pet:\n$e');
    }
  }

  @override
  Future<void> deletePet(String petId) async {
    try {
      final response = await dio.delete('/pets/$petId');
      if (response.statusCode == 200) {
        log("Pet deleted $petId");
      }
    } catch (e) {
      log("Pet $petId not deleted error: \n$e");
    }
  }

  @override
  Future<void> changePetName(
      String petId, String newPetName, String userId) async {
    try {
      final response = await dio
          .put('/pets/$petId', data: {'petName': newPetName, 'userId': userId});
      if (response.statusCode == 200) {
        log("Pet info updated $petId - $newPetName");
      }
    } catch (e) {
      log("Pet info couldn't updated \n$e");
    }
  }
}
