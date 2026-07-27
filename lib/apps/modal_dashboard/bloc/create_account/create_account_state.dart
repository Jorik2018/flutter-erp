part of 'create_account_bloc.dart';

sealed class CreateAccountState extends Equatable {
  const CreateAccountState();

  @override
  List<Object?> get props => [];
}

final class CreateAccountInitial extends CreateAccountState {
  const CreateAccountInitial();
}

final class CreateAccountInProgress extends CreateAccountState {
  const CreateAccountInProgress();
}

final class CreateAccountFailure extends CreateAccountState {
  const CreateAccountFailure({required this.error, required this.errorCode});

  final String error;
  final int errorCode;

  @override
  List<Object> get props => [error, errorCode];

  @override
  String toString() {
    return 'CreateAccountFailure('
        'error: $error, '
        'errorCode: $errorCode'
        ')';
  }
}

final class CreateAccountSuccess extends CreateAccountState {
  const CreateAccountSuccess();
}
