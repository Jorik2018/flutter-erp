

import 'package:flutter_erp/apps/whatsapp_clone/domain/entities/contact_entity.dart';

abstract class GetDeviceNumberRepository{
  Future<List<ContactEntity>> getDeviceNumbers();
}