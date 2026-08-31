import 'package:bloc/bloc.dart';
import 'package:flutter_erp/apps/flutter_taxi_booking_driver_app/repo/pref_manager.dart';
import 'package:flutter_erp/apps/flutter_taxi_booking_driver_app/repo/repo_provider.dart';
import 'package:get_it/get_it.dart';

import 'bloc.dart';

class LandingBloc extends Bloc<LandingEvent, LandingState> {
  PrefManager? pref;
  final RepoProvider repoProvider = GetIt.instance.get<RepoProvider>();

  LandingBloc() : super(LandingInitialState()) {
    on<LandingIsGuest>(_onLandingIsGuest);

    initPref();
  }

  Future<void> initPref() async {
    pref = await PrefManager.getInstance();
  }

  Future<void> _onLandingIsGuest(
    LandingIsGuest event,
    Emitter<LandingState> emit,
  ) async {
    emit(LandingLoadingState());

    try {
      pref ??= await PrefManager.getInstance();

      if (pref!.isLogin) {
        emit(LandingGoToUser());
      } else {
        emit(LandingGoToGuest());
      }
    } catch (e) {
      emit(ErrorState(errorMsg: "Something went wrong"));
    }
  }
}
