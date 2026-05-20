


import 'package:flutter_erp/apps/whatsapp_clone/domain/repositories/firebase_repository.dart';

class GetOneToOneSingleUserChatChannelUseCase{
  
  final FirebaseRepository repository;

  GetOneToOneSingleUserChatChannelUseCase({required this.repository});

  Future<String?> call(String uid,String otherUid) {
    return repository.getOneToOneSingleUserChannelId(uid, otherUid);
  }
  
}