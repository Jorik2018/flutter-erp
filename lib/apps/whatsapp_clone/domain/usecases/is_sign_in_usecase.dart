
import 'package:flutter_erp/apps/whatsapp_clone/domain/repositories/firebase_repository.dart';

class IsSignInUseCase{

  final FirebaseRepository repository;

  IsSignInUseCase({required this.repository});

  Future<bool> call() async{
    return await repository.isSignIn();
  }

}