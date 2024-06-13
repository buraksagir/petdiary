import 'package:easy_localization/easy_localization.dart';
import 'package:string_validator/string_validator.dart';

import '../../generated/locale_keys.g.dart';

abstract class ITextFieldValidators {
  String? validateUsername(String? value);
  String? validatePassword(String? value);
  String? validateName(String? value);
  String? validateSurname(String? value);
  String? validateMail(String? value);
  String? validatePhone(String? value);
  String? validatePostDescription(String? value);
  String? validateWrongPassword(String? value);
}

class TextFieldValidators extends ITextFieldValidators {
  String? usernameError;
  String? passwordError;
  String? wrongPasswordError;
  String? nameError;
  String? surnameError;
  String? mailError;
  String? phoneError;

  @override
  String? validateUsername(String? value) {
    if (value!.isEmpty || value.length < 3 || value.length > 14) {
      return LocaleKeys.validateUsername.tr();
    }
    return null;
  }

  @override
  String? validatePassword(String? value) {
    if (value!.length < 6) {
      return LocaleKeys.validatePassword.tr();
    }
    return null;
  }

  @override
  String? validateWrongPassword(String? value) {
    if (value!.length < 6) {
      return LocaleKeys.wrongPassword.tr();
    }
    return null;
  }

  @override
  String? validateName(String? value) {
    if (value!.isEmpty || value.length <= 1 || value.length > 15) {
      return LocaleKeys.validateName.tr();
    }
    return null;
  }

  @override
  String? validateSurname(String? value) {
    if (value!.isEmpty || value.length <= 1 || value.length > 14) {
      return LocaleKeys.validateSurname.tr();
    }
    return null;
  }

  @override
  String? validateMail(String? value) {
    if (!isEmail(value!)) {
      return LocaleKeys.validateMail.tr();
    }
    return null;
  }

  @override
  String? validatePhone(String? value) {
    if (!isNumeric(value!) || value.length < 6 || value.length > 13) {
      return LocaleKeys.validatePhone.tr();
    }
    return null;
  }

  @override
  String? validatePostDescription(String? value) {
    if (value!.isNotEmpty && !isAscii(value)) {
      return LocaleKeys.validDescription.tr();
    }
    return null;
  }
}
