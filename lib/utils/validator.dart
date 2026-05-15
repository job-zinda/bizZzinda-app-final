class Validator {
  static String? text(String? text) {
    if (text!.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? textSpecific(String text, String specific) {
    if (text.trim().isEmpty) {
      return 'Please enter your $specific';
    }
    return null;
  }

  static String? email(value) {
    if (value.isEmpty) {
      return 'Please enter your email address';
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? mobile(value) {
    if (value.isEmpty) {
      return 'Please enter your mobile number';
    }
    if (value.length < 10) {
      return 'Please enter a valid mobile number';
    }
    return null;
  }

  static String? otp(value) {
    if (value.toString().isEmpty) {
      return 'Please enter your OTP';
    }
    if (value.toString().length < 6) {
      return 'Please enter a valid OTP';
    }
    return null;
  }

  static String? password(value) {
    if (value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must contain at least 8 characters';
    }
    return null;
  }

  static String? url(value) {
    bool validURL = Uri.parse(value).isAbsolute;
    if (validURL) {
      return null;
    } else {
      return 'Please enter a valid URL';
    }
  }

  static String? validateDropdown({var value, required String msg}) {
    if (value == null) {
      return msg;
    }
    return null;
  }
}
