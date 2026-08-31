import 'package:flutter_erp/models/user.dart' as app_user;
import '../firebase_remote_data_source_impl.dart';

class SignUpUseCase {
  final FirebaseRemoteDataSourceImpl repository =
      FirebaseRemoteDataSourceImpl();

  Future<void> call(app_user.User user) {
    return repository.signUp(user);
  }
}
