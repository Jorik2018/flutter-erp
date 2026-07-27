part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

final class LoginInitial extends LoginState {
  const LoginInitial();
}

final class LoginInProgress extends LoginState {
  const LoginInProgress();
}

final class LoginFailure extends LoginState {
  const LoginFailure({required this.error, required this.errorCode});

  final String error;
  final int errorCode;

  @override
  List<Object> get props => [error, errorCode];

  @override
  String toString() {
    return 'LoginFailure('
        'error: $error, '
        'errorCode: $errorCode'
        ')';
  }
}

final class LoginSuccess extends LoginState {
  const LoginSuccess();
}
