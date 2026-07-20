import 'package:equatable/equatable.dart';

class ErrorHandler extends Equatable implements Exception {
  final String message;

  const ErrorHandler({required this.message});

  @override
  List<Object?> get props => [message];
}

sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final AppError error;
  const Failure(this.error);
}

sealed class AppError implements Exception {
  final String message;
  const AppError(this.message);

  @override
  String toString() => message;
}

final class UserNotFoundError extends AppError {
  const UserNotFoundError() : super('User does not exist');
}

final class UserNotAdminError extends AppError {
  const UserNotAdminError() : super('User is not an admin');
}

final class AuthError extends AppError {
  const AuthError(super.message);
}

final class UnexpectedError extends AppError {
  const UnexpectedError(super.message);
}
