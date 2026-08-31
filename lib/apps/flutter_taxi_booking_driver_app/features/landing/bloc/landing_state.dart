import 'package:equatable/equatable.dart';

abstract class LandingState extends Equatable {
  const LandingState();

  @override
  List<Object?> get props => [];
}

class LandingInitialState extends LandingState {
  const LandingInitialState();
}

class LandingLoadingState extends LandingState {
  const LandingLoadingState();
}

class LandingGoToGuest extends LandingState {
  const LandingGoToGuest();
}

class LandingGoToUser extends LandingState {
  const LandingGoToUser();
}

class ErrorState extends LandingState {
  final String errorMsg;

  const ErrorState({required this.errorMsg});

  @override
  List<Object?> get props => [errorMsg];
}
