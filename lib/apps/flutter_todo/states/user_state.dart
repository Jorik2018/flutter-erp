import 'package:flutter_erp/apps/flutter_todo/models/user.dart';

class UserState {
  final User? user;
  final bool isLoading;

  const UserState({
    this.user,
    this.isLoading = false,
  });

  UserState copyWith({
    User? user,
    bool? isLoading,
  }) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}