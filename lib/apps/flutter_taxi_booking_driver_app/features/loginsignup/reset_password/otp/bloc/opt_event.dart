import 'package:equatable/equatable.dart';

abstract class OptEvent extends Equatable {
  const OptEvent();

  @override
  List<Object?> get props => [];
}

class VerifyOTPEvent extends OptEvent {
  const VerifyOTPEvent();
}
