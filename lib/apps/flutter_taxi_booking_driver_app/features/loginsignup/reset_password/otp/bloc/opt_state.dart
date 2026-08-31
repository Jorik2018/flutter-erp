import 'package:equatable/equatable.dart';

abstract class OptState extends Equatable {
  const OptState();

  @override
  List<Object?> get props => [];
}

class InitialOptState extends OptState {
  const InitialOptState();
}

class LoadingOptState extends OptState {
  const LoadingOptState();
}

class GotoResetPassState extends OptState {
  const GotoResetPassState();
}

class ErrorState extends OptState {
  final String errorMsg;

  const ErrorState({required this.errorMsg});

  @override
  List<Object?> get props => [errorMsg];
}
