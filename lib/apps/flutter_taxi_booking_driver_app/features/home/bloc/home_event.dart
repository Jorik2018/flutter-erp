import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class CheckLocPer extends HomeEvent {
  const CheckLocPer();
}

class AskLocationDialogEvent extends HomeEvent {
  const AskLocationDialogEvent();
}
