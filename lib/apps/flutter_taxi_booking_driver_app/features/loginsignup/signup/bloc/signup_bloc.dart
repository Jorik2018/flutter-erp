import 'package:bloc/bloc.dart';
import 'package:flutter_erp/apps/flutter_taxi_booking_driver_app/repo/repo_provider.dart';
import 'package:get_it/get_it.dart';

import './bloc.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final RepoProvider _repo = GetIt.instance.get<RepoProvider>();

  SignupBloc() : super(InitialSignupState()) {
    on<SubmitSignupEvent>(_onSubmitSignup);
  }

  Future<void> _onSubmitSignup(
    SubmitSignupEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(LoadingSignupState());

    if (await _repo.networkInfo.isConnected) {
      try {
        emit(SignupSuccessState());
      } catch (e) {
        emit(ErrorState(errorMsg: "Something went wrong"));
      }
    } else {
      emit(ErrorState(errorMsg: "Connect with working internet..."));
    }
  }
}
