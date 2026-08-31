import 'package:bloc/bloc.dart';

import './bloc.dart';

class ResetPassBloc extends Bloc<ResetPassEvent, ResetPassState> {
  ResetPassBloc() : super(InitialResetPassState()) {
    on<ResetPassEvent>((event, emit) async {
      // TODO: Add Logic
    });
  }
}
