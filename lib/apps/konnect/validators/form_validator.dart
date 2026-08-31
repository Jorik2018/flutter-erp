abstract class StringValidator {
  bool isValid(String value);
}

class ValidEmail implements StringValidator {
  static final RegExp _regex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  @override
  bool isValid(String value) => _regex.hasMatch(value);
}

class NonEmptyString implements StringValidator {
  @override
  bool isValid(String value) => value.isNotEmpty;
}

class ValidPassword implements StringValidator {
  @override
  bool isValid(String value) => value.length >= 6;
}

class ValidPhoneNo implements StringValidator {
  static final RegExp _regex = RegExp(r'^(?:[+0]9)?[0-9]{10,12}$');

  @override
  bool isValid(String value) {
    return value.isNotEmpty && _regex.hasMatch(value);
  }
}

class ValidOtp implements StringValidator {
  @override
  bool isValid(String value) {
    return value.length == 6 && int.tryParse(value) != null;
  }
}

mixin FormValidator {
  final StringValidator nonEmptyTextValidator = NonEmptyString();
  final StringValidator emailValidator = ValidEmail();
  final StringValidator passValidator = ValidPassword();
  final StringValidator phoneValidator = ValidPhoneNo();
  final StringValidator otpValidator = ValidOtp();

  final String emptyname = 'Enter a valid name.';
  final String emailError = 'Enter a valid email.';
  final String passError = 'Enter at least 6 characters password.';
  final String phoneError = 'Enter a valid phone number.';
  final String otpError = 'Enter a valid 6 digit otp.';
}
