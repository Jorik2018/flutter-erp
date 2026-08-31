import 'package:bloc/bloc.dart';
import 'package:flutter_erp/apps/flutter_taxi_booking_driver_app/repo/pref_manager.dart';
import 'package:flutter_erp/apps/flutter_taxi_booking_driver_app/repo/repo_provider.dart';
import 'package:get_it/get_it.dart';

import './bloc.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final RepoProvider _repo = GetIt.instance.get<RepoProvider>();
  PrefManager? _pref;

  LanguageBloc() : super(InitialLanguageState()) {
    on<SelectLanEvent>(_onSelectLan);

    initPref();
  }

  Future<void> initPref() async {
    _pref = await PrefManager.getInstance();
  }

  Future<void> _onSelectLan(
    SelectLanEvent event,
    Emitter<LanguageState> emit,
  ) async {
    // Loading indicator for something going to change
    emit(LoadingLanState());

    if (await _repo.networkInfo.isConnected) {
      try {
        _pref ??= await PrefManager.getInstance();

        _pref!.defaultLan = event.lan;
        _pref!.defaultLanCode = event.lanCode;

        // Goto OnBoard Screen
        emit(GoToOnBoardState());
      } catch (e) {
        emit(ErrorState(errorMsg: "Something went wrong"));
      }
    } else {
      emit(ErrorState(errorMsg: "Connect with working internet..."));
    }
  }
}
