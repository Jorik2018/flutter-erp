
import 'package:flutter_erp/apps/whatsapp_clone/domain/entities/text_message_entity.dart';
import 'package:flutter_erp/apps/whatsapp_clone/domain/repositories/firebase_repository.dart';

class SendTextMessageUseCase{

  final FirebaseRepository repository;

  SendTextMessageUseCase({required this.repository});

  Future<void> sendTextMessage(TextMessageEntity textMessageEntity,String channelId)async{
    return await repository.sendTextMessage(textMessageEntity,channelId);
  }

}