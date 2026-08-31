import 'package:equatable/equatable.dart';

abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object?> get props => [];
}

class InitialLanguageState extends LanguageState {
  const InitialLanguageState();
}

class GoToOnBoardState extends LanguageState {
  const GoToOnBoardState();
}

class LoadingLanState extends LanguageState {
  const LoadingLanState();
}

class ErrorState extends LanguageState {
  final String errorMsg;

  const ErrorState({required this.errorMsg});

  @override
  List<Object?> get props => [errorMsg];
}
