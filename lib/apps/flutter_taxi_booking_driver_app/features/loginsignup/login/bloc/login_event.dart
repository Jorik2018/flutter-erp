import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class SubmitLoginEvent extends LoginEvent {
  final String mobile;
  final String password;

  const SubmitLoginEvent(this.mobile, this.password);

  @override
  List<Object?> get props => [mobile, password];
}

class LoginWithFaceidEvent extends LoginEvent {
  const LoginWithFaceidEvent();
}

class ForgotPassEvent extends LoginEvent {
  const ForgotPassEvent();
}
