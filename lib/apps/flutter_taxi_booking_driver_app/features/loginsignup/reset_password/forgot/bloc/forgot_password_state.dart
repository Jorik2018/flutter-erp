import 'package:equatable/equatable.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

class InitialForgotPasswordState extends ForgotPasswordState {
  const InitialForgotPasswordState();
}

class LoadingForgotState extends ForgotPasswordState {
  const LoadingForgotState();
}

class GotoOTPSendState extends ForgotPasswordState {
  final String mobileNo;

  const GotoOTPSendState(this.mobileNo);

  @override
  List<Object?> get props => [mobileNo];
}

class ErrorState extends ForgotPasswordState {
  final String errorMsg;

  const ErrorState({required this.errorMsg});

  @override
  List<Object?> get props => [errorMsg];
}
