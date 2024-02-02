class FormValidator {
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Valid Username is Required!';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is Required!';
    } else if (value.length < 6) {
      return 'Password should be at least 6 characters!';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    bool emailValid = RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value!);
    if (value.isEmpty) {
      return 'Email is Required!';
    } else if (!emailValid) {
      return 'Valid Email is Required!';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    bool phoneValid = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value!);
    if (value.isEmpty) {
      return 'Phone is Required!';
    } else if (!phoneValid) {
      return 'Valid Phone number is Required!';
    }
    return null;
  }
}
