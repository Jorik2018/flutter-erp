import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class InitialHomeState extends HomeState {
  const InitialHomeState();
}

class AskLocationDialog extends HomeState {
  const AskLocationDialog();
}

class LoadingHomeState extends HomeState {
  const LoadingHomeState();
}

class ErrorState extends HomeState {
  final String errorMsg;

  const ErrorState({required this.errorMsg});

  @override
  List<Object?> get props => [errorMsg];
}
