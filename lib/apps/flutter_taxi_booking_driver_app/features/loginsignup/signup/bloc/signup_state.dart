import 'package:equatable/equatable.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object?> get props => [];
}

class InitialSignupState extends SignupState {
  const InitialSignupState();
}

class ErrorState extends SignupState {
  final String errorMsg;

  const ErrorState({required this.errorMsg});

  @override
  List<Object?> get props => [errorMsg];
}

class LoadingSignupState extends SignupState {
  const LoadingSignupState();
}

class SignupSuccessState extends SignupState {
  const SignupSuccessState();
}
