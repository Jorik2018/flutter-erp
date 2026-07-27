import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/models.dart';
import '../../repository/auth.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  final AuthRepository authRepository;

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginInProgress());

    try {
      final Token token = await authRepository.generateToken(
        event.email,
        event.password,
      );

      if (token.error != null) {
        emit(
          LoginFailure(error: token.error!, errorCode: token.errorCode ?? 0),
        );
        return;
      }

      await authRepository.persistToken(token);
      await authRepository.persistLogInState(loggedIn: true);

      emit(LoginSuccess());
    } catch (error, stackTrace) {
      addError(error, stackTrace);

      emit(LoginFailure(error: error.toString(), errorCode: 0));
    }
  }
}
