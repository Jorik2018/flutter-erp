import 'package:bloc/bloc.dart';
import 'package:flutter_erp/apps/flutter_taxi_booking_driver_app/repo/repo_provider.dart';
import 'package:get_it/get_it.dart';

import './bloc.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final RepoProvider _repo = GetIt.instance.get<RepoProvider>();

  ForgotPasswordBloc() : super(InitialForgotPasswordState()) {
    on<SendOTPEvent>(_onSendOTP);
  }

  Future<void> _onSendOTP(
    SendOTPEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (await _repo.networkInfo.isConnected) {
      try {
        emit(GotoOTPSendState(event.mobileNo));
      } catch (e) {
        emit(ErrorState(errorMsg: "Something went wrong"));
      }
    } else {
      emit(ErrorState(errorMsg: "Connect with working internet..."));
    }
  }
}
