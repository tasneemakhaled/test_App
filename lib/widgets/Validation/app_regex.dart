class AppRegex {
  static bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+$").hasMatch(email);
  }

  static bool isValidName(String name) {
    return RegExp(r"^[A-Za-z\s'-]+$").hasMatch(name);
  }

  // static bool isValidPassword(String password) {
  //   final passwordRegExp =
  //       RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  //   return passwordRegExp.hasMatch(password);
  // }
}
