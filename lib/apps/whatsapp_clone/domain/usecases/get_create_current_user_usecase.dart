import 'package:flutter_erp/models/user.dart' as app_user;
import 'package:flutter_erp/apps/whatsapp_clone/domain/repositories/firebase_repository.dart';

class GetCreateCurrentUserUseCase {
  final FirebaseRepository repository;

  GetCreateCurrentUserUseCase({required this.repository});

  Future<void> call(app_user.User user) async {
    return await repository.getCreateCurrentUser(user);
  }
}
