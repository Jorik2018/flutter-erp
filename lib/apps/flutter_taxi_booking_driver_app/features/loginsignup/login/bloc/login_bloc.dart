import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter_erp/apps/flutter_taxi_booking_driver_app/repo/repo_provider.dart';
import 'package:get_it/get_it.dart';

import 'bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final RepoProvider _repo = GetIt.instance.get<RepoProvider>();

  LoginBloc() : super(InitialLoginState()) {
    on<SubmitLoginEvent>(_onSubmitLogin);
    on<LoginWithFaceidEvent>(_onLoginWithFaceId);
    on<ForgotPassEvent>(_onForgotPass);
  }

  Future<void> _onSubmitLogin(
    SubmitLoginEvent event,
    Emitter<LoginState> emit,
  ) async {
    if (await _repo.networkInfo.isConnected) {
      emit(GotoHomeState());
    } else {
      emit(ErrorLoginState(errorMsg: "Connect with working internet..."));
    }
  }

  Future<void> _onLoginWithFaceId(
    LoginWithFaceidEvent event,
    Emitter<LoginState> emit,
  ) async {
    if (await _repo.networkInfo.isConnected) {
      try {
        final random = Random();

        if (random.nextBool()) {
          emit(GotoFaceIDLoginState());
        } else {
          emit(FacenotRecognizedLoginState());
        }
      } catch (e) {
        emit(ErrorLoginState(errorMsg: "Something went wrong"));
      }
    } else {
      emit(ErrorLoginState(errorMsg: "Connect with working internet..."));
    }
  }

  Future<void> _onForgotPass(
    ForgotPassEvent event,
    Emitter<LoginState> emit,
  ) async {
    if (await _repo.networkInfo.isConnected) {
      try {
        emit(GotoForgotPassState());
      } catch (e) {
        emit(ErrorLoginState(errorMsg: "Something went wrong"));
      }
    } else {
      emit(ErrorLoginState(errorMsg: "Connect with working internet..."));
    }
  }
}
