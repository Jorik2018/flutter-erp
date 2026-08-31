import 'package:equatable/equatable.dart';

abstract class OnboardEvent extends Equatable {
  const OnboardEvent();

  @override
  List<Object?> get props => [];
}

class NextEvent extends OnboardEvent {
  const NextEvent();
}

class GoToLoginEvent extends OnboardEvent {
  const GoToLoginEvent();
}
