import 'package:equatable/equatable.dart';

abstract class ResetPassState extends Equatable {
  const ResetPassState();

  @override
  List<Object?> get props => [];
}

class InitialResetPassState extends ResetPassState {
  const InitialResetPassState();
}

class LoadingResetPassState extends ResetPassState {
  const LoadingResetPassState();
}

class ErrorState extends ResetPassState {
  final String errorMsg;

  const ErrorState({required this.errorMsg});

  @override
  List<Object?> get props => [errorMsg];
}
