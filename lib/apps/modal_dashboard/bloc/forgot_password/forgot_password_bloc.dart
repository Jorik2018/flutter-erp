import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/repository.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({required this.authRepository})
    : super(RecoverPasswordUnInitiated()) {
    on<RecoverPassword>(_onRecoverPassword);
  }

  final AuthRepository authRepository;

  Future<void> _onRecoverPassword(
    RecoverPassword event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(RecoverPasswordInitiated());

    try {
      final response = await authRepository.recoverPassword(event.email);

      if (response.success!) {
        emit(RecoverPasswordSuccess());
        return;
      }

      emit(
        RecoverPasswordFailed(
          error: response.error ?? 'No se pudo recuperar la contraseña',
          errorCode: response.errorCode ?? 0,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);

      emit(RecoverPasswordFailed(error: error.toString(), errorCode: 0));
    }
  }
}
