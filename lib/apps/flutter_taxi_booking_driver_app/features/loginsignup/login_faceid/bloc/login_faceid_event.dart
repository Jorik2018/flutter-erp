import 'package:equatable/equatable.dart';

abstract class LoginFaceidEvent extends Equatable {
  const LoginFaceidEvent();

  @override
  List<Object?> get props => [];
}

class UserFaceidEvent extends LoginFaceidEvent {
  const UserFaceidEvent();
}
