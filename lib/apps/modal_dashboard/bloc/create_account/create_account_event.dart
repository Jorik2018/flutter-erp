part of 'create_account_bloc.dart';

sealed class CreateAccountEvent extends Equatable {
  const CreateAccountEvent();

  @override
  List<Object?> get props => [];
}

final class CreateAccountButtonPressed extends CreateAccountEvent {
  const CreateAccountButtonPressed({
    required this.fullName,
    required this.email,
    required this.password,
  });

  final String fullName;
  final String email;
  final String password;

  @override
  List<Object> get props => [fullName, email, password];

  @override
  String toString() {
    return 'CreateAccountButtonPressed('
        'fullName: $fullName, '
        'email: $email'
        ')';
  }
}
