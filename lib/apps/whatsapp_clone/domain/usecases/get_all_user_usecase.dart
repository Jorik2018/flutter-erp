import 'package:flutter_erp/models/user.dart' as app_user;
import 'package:flutter_erp/apps/whatsapp_clone/domain/repositories/firebase_repository.dart';

class GetAllUserUseCase {
  final FirebaseRepository repository;

  GetAllUserUseCase({required this.repository});

  Stream<List<app_user.User>> call() {
    return repository.getAllUsers();
  }
}
