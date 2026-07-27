import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/models.dart';
import '../../repository/repository.dart';

part 'create_account_event.dart';
part 'create_account_state.dart';

class CreateAccountBloc extends Bloc<CreateAccountEvent, CreateAccountState> {
  CreateAccountBloc({
    required this.memberRepository,
    required this.authRepository,
  }) : super(CreateAccountInitial()) {
    on<CreateAccountButtonPressed>(_onCreateAccountButtonPressed);
  }

  final MemberRepository memberRepository;
  final AuthRepository authRepository;

  Future<void> _onCreateAccountButtonPressed(
    CreateAccountButtonPressed event,
    Emitter<CreateAccountState> emit,
  ) async {
    emit(CreateAccountInProgress());

    try {
      final response = await memberRepository.createAccount(
        CreateMemberRequest(
          fullName: event.fullName,
          email: event.email,
          password: event.password,
        ),
      );

      if (response.error != null) {
        emit(
          CreateAccountFailure(
            error: response.error!,
            errorCode: response.errorCode ?? 0,
          ),
        );
        return;
      }

      await authRepository.persistToken(response);
      await authRepository.persistLogInState(loggedIn: true);

      emit(CreateAccountSuccess());
    } catch (error, stackTrace) {
      addError(error, stackTrace);

      emit(CreateAccountFailure(error: error.toString(), errorCode: 0));
    }
  }
}
