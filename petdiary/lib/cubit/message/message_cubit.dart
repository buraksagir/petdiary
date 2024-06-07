import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petdiary/services/message_service.dart';

import 'message_cubit_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(const MessageState());
  late final MessageService messageService = MessageService();

  Future<void> getAllMessagesByReceiverSenderId(
      String contextUserId, String userId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final messages = await messageService.getAllMessagesByReceiverSenderId(
          contextUserId, userId);
      emit(state.copyWith(messageListModel: messages, isLoaded: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, isLoaded: false));
    }
  }

  Future<void> getAllMessagesByUserId(String contextUserId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final messages =
          await messageService.getAllMessagesByUserId(contextUserId);
      emit(state.copyWith(messageListModel: messages, isLoaded: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, isLoaded: false));
    }
  }
}
