import 'package:flutter_erp/apps/pak_tourism/model/user_model.dart';

import '../firebase_remote_data_source_impl.dart';

class SignInUseCase {
  final FirebaseRemoteDataSourceImpl repository =
      FirebaseRemoteDataSourceImpl();

  Future<void> call(UserModel user) {
    return repository.signIn(user);
  }
}
