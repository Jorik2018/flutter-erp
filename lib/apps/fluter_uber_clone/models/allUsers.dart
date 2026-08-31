import 'package:firebase_database/firebase_database.dart';

class Users {
  String? id;
  String? email;
  String? name;
  String? phone;

  Users({this.id, this.email, this.name, this.phone});

  Users.fromSnapshot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key;

    final value = dataSnapshot.value;

    if (value is Map) {
      email = value['email']?.toString();
      name = value['name']?.toString();
      phone = value['phone']?.toString();
    }
  }
}
