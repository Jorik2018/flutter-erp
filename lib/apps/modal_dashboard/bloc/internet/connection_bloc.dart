import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/data.dart';

part 'connection_event.dart';
part 'connection_state.dart';

class InternetConnectionBloc
    extends Bloc<InternetConnectionEvent, InternetConnectionState> {
  InternetConnectionBloc({WebLocalStorageHelper? webLocalStorage})
    : _webLocalStorage = webLocalStorage ?? WebLocalStorageHelper(),
      super(InternetInitializing()) {
    on<InternetConnected>(_onInternetConnected);
    on<InternetDisconnected>(_onInternetDisconnected);
  }

  final WebLocalStorageHelper _webLocalStorage;

  Future<void> _onInternetConnected(
    InternetConnected event,
    Emitter<InternetConnectionState> emit,
  ) async {
    await _webLocalStorage.saveInternetState(available: true);

    emit(InternetAvailable());
  }

  Future<void> _onInternetDisconnected(
    InternetDisconnected event,
    Emitter<InternetConnectionState> emit,
  ) async {
    await _webLocalStorage.saveInternetState(available: false);

    emit(InternetUnAvailable());
  }
}
