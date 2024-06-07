import 'package:equatable/equatable.dart';

import '../../data/models/message_model.dart';

class MessageState extends Equatable {
  final bool isLoading;
  final bool isLoaded;
  final List<Message>? messageListModel;
  final List<Message>? messageListModelForSingleUser;

  const MessageState(
      {this.isLoading = false,
      this.isLoaded = false,
      this.messageListModel,
      this.messageListModelForSingleUser});

  @override
  List<Object?> get props =>
      [isLoading, isLoaded, messageListModel, messageListModelForSingleUser];

  MessageState copyWith(
      {bool? isLoading,
      bool? isLoaded,
      List<Message>? messageListModel,
      List<Message>? messageListModelForSingleUser}) {
    return MessageState(
        isLoading: isLoading ?? this.isLoading,
        isLoaded: isLoaded ?? this.isLoaded,
        messageListModel: messageListModel ?? this.messageListModel,
        messageListModelForSingleUser: messageListModelForSingleUser ??
            this.messageListModelForSingleUser);
  }
}
