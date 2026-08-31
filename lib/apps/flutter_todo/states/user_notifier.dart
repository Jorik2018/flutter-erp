import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_erp/models/user.dart' as app_user;
import 'package:flutter_erp/apps/flutter_todo/states/user_state.dart';

class UserNotifier extends Notifier<UserState> {
  @override
  UserState build() {
    return const UserState();
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true);

    try {
      // API CALL (igual que antes)

      final user = app_user.User(id: "1", email: email, token: "token");

      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void logout() {
    state = const UserState(user: null);
  }
}
