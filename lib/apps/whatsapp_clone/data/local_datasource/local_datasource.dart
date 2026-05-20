import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_erp/apps/whatsapp_clone/domain/entities/contact_entity.dart';

abstract class LocalDataSource {
  Future<List<ContactEntity>> getDeviceNumbers();
}

class LocalDataSourceImpl implements LocalDataSource {
  @override
  Future<List<ContactEntity>> getDeviceNumbers() async {
    final getContactsData = await FlutterContacts.getAll(
      properties: {ContactProperty.photoThumbnail},
    );

    return getContactsData
        .expand(
          (contact) => contact.phones.map((phone) {
            return ContactEntity(
              phoneNumber: phone.number,
              label: contact.displayName,
            );
          }),
        )
        .toList();
  }
}
