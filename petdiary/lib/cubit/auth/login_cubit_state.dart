import 'package:equatable/equatable.dart';
import 'package:petdiary/data/models/auth_models/token_model.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final bool isLoaded;
  final bool credidentalLoading;
  final bool credidentalLoaded;
  final String? errorMessage;
  final TokenModel? tokenModel;
  final TokenModel? credidentalCheck;
  final bool? isEmpty;

  const LoginState({
    this.errorMessage,
    this.isLoading = false,
    this.isLoaded = false,
    this.tokenModel,
    this.credidentalCheck,
    this.credidentalLoading = false,
    this.credidentalLoaded = false,
    this.isEmpty,
  });

  @override
  List<Object?> get props => [
        isLoading,
        tokenModel,
        isLoaded,
        credidentalCheck,
        credidentalLoading,
        credidentalLoaded,
        errorMessage,
        isEmpty,
      ];

  LoginState copyWith({
    bool? isLoading,
    TokenModel? tokenModel,
    bool? isLoaded,
    TokenModel? credidentalCheck,
    bool? credidentalLoading,
    bool? credidentalLoaded,
    String? errorMessage,
    bool? isEmpty,
  }) {
    return LoginState(
      credidentalCheck: credidentalCheck ?? this.credidentalCheck,
      isLoading: isLoading ?? false,
      tokenModel: tokenModel ?? this.tokenModel,
      isLoaded: isLoaded ?? false,
      credidentalLoading: credidentalLoading ?? false,
      credidentalLoaded: credidentalLoaded ?? false,
      errorMessage: errorMessage ?? this.errorMessage,
      isEmpty: isEmpty ?? this.isEmpty,
    );
  }
}
