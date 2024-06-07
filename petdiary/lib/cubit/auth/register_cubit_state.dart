import 'package:equatable/equatable.dart';
import 'package:petdiary/data/models/auth_models/token_model.dart';

class RegisterState extends Equatable {
  final bool isLoading;
  final bool isLoaded;

  final TokenModel? tokenModel;

  const RegisterState({
    this.isLoading = false,
    this.isLoaded = false,
    this.tokenModel,
  });

  @override
  List<Object?> get props => [isLoading, tokenModel, isLoaded];

  RegisterState copyWith({
    bool? isLoading,
    TokenModel? tokenModel,
    bool? isLoaded,
  }) {
    return RegisterState(
      isLoading: isLoading ?? false,
      tokenModel: tokenModel ?? this.tokenModel,
      isLoaded: isLoaded ?? false,
    );
  }
}
