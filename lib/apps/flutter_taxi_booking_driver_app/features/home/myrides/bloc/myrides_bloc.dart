import 'package:bloc/bloc.dart';

import './bloc.dart';

class MyridesBloc extends Bloc<MyridesEvent, MyridesState> {
  MyridesBloc() : super(InitialMyridesState()) {
    on<MyridesEvent>((event, emit) async {
      // TODO: Add Logic
    });
  }
}
