import 'package:bloc/bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import './bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(InitialHomeState()) {
    on<CheckLocPer>(_onCheckLocationPermission);
    on<AskLocationDialogEvent>(_onAskLocationPermission);
  }

  Future<void> _onCheckLocationPermission(
    CheckLocPer event,
    Emitter<HomeState> emit,
  ) async {
    final PermissionStatus permission =
        await Permission.locationWhenInUse.status;

    if (permission.isDenied) {
      emit(AskLocationDialog());
    }
  }

  Future<void> _onAskLocationPermission(
    AskLocationDialogEvent event,
    Emitter<HomeState> emit,
  ) async {
    await Permission.locationWhenInUse.request();
  }
}
