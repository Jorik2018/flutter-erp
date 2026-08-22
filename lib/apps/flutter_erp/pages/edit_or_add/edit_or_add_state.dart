sealed class NameError {
  const NameError();
}

class LengthOfNameIsLessThanThreeCharacters extends NameError {
  const LengthOfNameIsLessThanThreeCharacters();
}

sealed class PhoneError {
  const PhoneError();
}

class InvalidPhoneNumber extends PhoneError {
  const InvalidPhoneNumber();
}

sealed class AddressError {
  const AddressError();
}

class LengthOfAddressIsLessThanThreeCharacters extends AddressError {
  const LengthOfAddressIsLessThanThreeCharacters();
}

sealed class EditOrAddMessage {
  const EditOrAddMessage();
}

class InvalidInformation extends EditOrAddMessage {
  const InvalidInformation();
}

class AddContactSuccess extends EditOrAddMessage {
  const AddContactSuccess();
}

class AddContactFailure extends EditOrAddMessage {
  final Object? error;

  const AddContactFailure([this.error]);

  @override
  String toString() => 'AddContactFailure{error=$error}';
}

class UpdateContactSuccess extends EditOrAddMessage {
  const UpdateContactSuccess();
}

class UpdateContactFailure extends EditOrAddMessage {
  final Object? error;

  const UpdateContactFailure([this.error]);

  @override
  String toString() => 'UpdateContactFailure{error=$error}';
}
