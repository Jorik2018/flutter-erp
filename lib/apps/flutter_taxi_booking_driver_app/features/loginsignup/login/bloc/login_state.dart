import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class InitialLoginState extends LoginState {
  const InitialLoginState();
}

class LoadingLoginState extends LoginState {
  const LoadingLoginState();
}

class ErrorLoginState extends LoginState {
  final String errorMsg;

  const ErrorLoginState({required this.errorMsg});

  @override
  List<Object?> get props => [errorMsg];
}

class GotoHomeState extends LoginState {
  const GotoHomeState();
}

class GotoForgotPassState extends LoginState {
  const GotoForgotPassState();
}

class GotoFaceIDLoginState extends LoginState {
  const GotoFaceIDLoginState();
}

class GotoSocialLoginState extends LoginState {
  const GotoSocialLoginState();
}

class GotoSignUpLoginState extends LoginState {
  const GotoSignUpLoginState();
}

class FacenotRecognizedLoginState extends LoginState {
  const FacenotRecognizedLoginState();
}
