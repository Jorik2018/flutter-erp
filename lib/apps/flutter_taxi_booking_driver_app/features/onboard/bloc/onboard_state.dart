import 'package:equatable/equatable.dart';

abstract class OnboardState extends Equatable {
  const OnboardState();

  @override
  List<Object?> get props => [];
}

class InitialOnboardState extends OnboardState {
  const InitialOnboardState();
}

class CurrentOnboardState extends OnboardState {
  final int currentIndex;

  const CurrentOnboardState({required this.currentIndex});

  @override
  List<Object?> get props => [currentIndex];
}

class LoadingOnboardState extends OnboardState {
  const LoadingOnboardState();
}

class GotoLoginOnboardState extends OnboardState {
  const GotoLoginOnboardState();
}

class ErrorState extends OnboardState {
  final String errorMsg;

  const ErrorState({required this.errorMsg});

  @override
  List<Object?> get props => [errorMsg];
}
