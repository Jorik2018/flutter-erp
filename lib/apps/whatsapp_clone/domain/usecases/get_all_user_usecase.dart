

import 'package:flutter_erp/apps/whatsapp_clone/domain/entities/user_entity.dart';
import 'package:flutter_erp/apps/whatsapp_clone/domain/repositories/firebase_repository.dart';

class GetAllUserUseCase{
  final FirebaseRepository repository;

  GetAllUserUseCase({required this.repository});

  Stream<List<UserEntity>> call(){
    return repository.getAllUsers();
  }

}