import 'package:bloc/bloc.dart';

import './bloc.dart';

class HelpSupportBloc extends Bloc<HelpSupportEvent, HelpSupportState> {
  HelpSupportBloc() : super(InitialHelpSupportState()) {
    on<HelpSupportEvent>((event, emit) async {
      // TODO: Add Logic
    });
  }
}
