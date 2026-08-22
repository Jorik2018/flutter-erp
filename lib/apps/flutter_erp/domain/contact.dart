//domain/contact.dart
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

/**Target of URI hasn't been generated: 'package:flutter_erp/apps/flutter_erp/domain/contact.g.dart'.
Try running the generator that will generate the file referenced by the URI */
part 'contact.g.dart';

/**The name 'ContactBuilder' isn't a type, so it can't be used as a type argument.
Try correcting the name to an existing type, or defining a type named 'ContactBuilder'. */
abstract class Contact implements Built<Contact, ContactBuilder> {
  int? get id;

  String get name;

  String get phone;

  String get address;

  Gender get gender;

  DateTime get updatedAt;

  DateTime? get createdAt;

  Contact._();

  factory Contact([void Function(ContactBuilder b)? updates]) = _$Contact;
}

class Gender extends EnumClass {
  /**Const variables must be initialized with a constant value.
Try changing the initializer to be a constant expression.dar */
  static const Gender male = _$male;
  static const Gender female = _$female;

  const Gender._(super.name);

  static BuiltSet<Gender> get values => _$values;
/**The method '_$valueOf' isn't defined for the type 'Gender'.
Try correcting the name to the name of an existing method, or defining a method named '_$valueOf' */
  static Gender valueOf(String name) => _$valueOf(name);
}