import 'package:bloc/bloc.dart';
import 'bloc.dart';

class HelpSupportQuestionsBloc
    extends Bloc<HelpSupportQuestionsEvent, HelpSupportQuestionsState> {
  HelpSupportQuestionsBloc() : super(InitialHelpSupportQuestionsState()) {
    on<HelpSupportQuestionsEvent>((event, emit) async {
      // TODO: Add Logic
    });
  }
}
