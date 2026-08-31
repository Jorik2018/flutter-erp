import 'package:flutter_erp/models/user.dart' as app_user;

class UserState {
  final app_user.User? user;
  final bool isLoading;

  const UserState({this.user, this.isLoading = false});

  UserState copyWith({app_user.User? user, bool? isLoading}) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
