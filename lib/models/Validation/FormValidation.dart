import 'package:email_validator/email_validator.dart';

class FormValidation {
  static String? emailValidation(String value, String errorMessage) {
    if (_basicValidation(value) && EmailValidator.validate(value)) {
      return null;
    }

    return errorMessage;
  }

  static String? staffValidation(String value, String errorMessage) {
    if (_basicValidation(value) && value.contains('@clearance.aaua.edu.ng')) {
      return null;
    }

    return errorMessage;
  }

  static String? studentValidation(String value, String errorMessage) {
    if (_basicValidation(value) && value.startsWith('17', 0) ||
        value.startsWith('18', 0) ||
        value.startsWith('16', 0) ||
        value.startsWith('15', 0) ||
        value.startsWith('14', 0) ||
        value.startsWith('13', 0) ||
        value.startsWith('12', 0) ||
        value.startsWith('11', 0) ||
        value.startsWith('10', 0) ||
        value.startsWith('09', 0) ||
        value.startsWith('08', 0) ||
        value.startsWith('07', 0) ||
        value.startsWith('06', 0)) {
      return null;
    }

    return errorMessage;
  }

  static String? notEmptyValidation(String value, String errorMessage) {
    if (_basicValidation(value)) {
      return null;
    }
    return errorMessage;
  }

  static String? urlValidation(String value, String errorMessage) {
    if (_basicValidation(value) &&
        value.startsWith('http') &&
        value.startsWith('https')) {
      return null;
    }
    return errorMessage;
  }

  static String? passwordValidation(String value) {
    if (_basicValidation(value) && value.length > 5) {
      return null;
    }

    return "Invalid Password";
  }

  static String? retypePasswordValidation(String value1, String value2) {
    if (_basicValidation(value1) && value1 == value2) {
      return null;
    }

    return "Passwords not matched";
  }

  static bool _basicValidation(String value) {
    value = value.trim();
    if (value.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static String? isInteger(value, String errorMessage) {
    try {
      int.parse(value);
      return null;
    } catch (e) {
      return errorMessage;
    }
  }
}
