import 'package:bloc/bloc.dart';
import 'package:flutter_erp/apps/flutter_taxi_booking_driver_app/repo/repo_provider.dart';
import 'package:get_it/get_it.dart';

import './bloc.dart';

class OnboardBloc extends Bloc<OnboardEvent, OnboardState> {
  final RepoProvider _repoProvider = GetIt.instance.get<RepoProvider>();

  int currentIndex = -1;
  final int maxOnBoard = 2;

  OnboardBloc() : super(InitialOnboardState()) {
    on<NextEvent>(_onNext);
    on<GoToLoginEvent>(_onGoToLogin);
  }

  Future<void> _onNext(NextEvent event, Emitter<OnboardState> emit) async {
    if (await _repoProvider.networkInfo.isConnected) {
      try {
        if (currentIndex >= maxOnBoard) {
          emit(GotoLoginOnboardState());
        } else {
          ++currentIndex;

          emit(CurrentOnboardState(currentIndex: currentIndex));
        }
      } catch (e) {
        emit(ErrorState(errorMsg: "Something went wrong"));
      }
    } else {
      emit(ErrorState(errorMsg: "Connect with working internet..."));
    }
  }

  Future<void> _onGoToLogin(
    GoToLoginEvent event,
    Emitter<OnboardState> emit,
  ) async {
    if (await _repoProvider.networkInfo.isConnected) {
      emit(GotoLoginOnboardState());
    } else {
      emit(ErrorState(errorMsg: "Connect with working internet..."));
    }
  }
}
