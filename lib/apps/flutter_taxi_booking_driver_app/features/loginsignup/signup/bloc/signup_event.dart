import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class SubmitSignupEvent extends SignupEvent {
  const SubmitSignupEvent();
}
