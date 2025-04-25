class LoginModel {
  final String email;
  final String password;

  LoginModel({required this.email, required this.password});

  /// تحويل البيانات إلى JSON لإرسالها إلى الـ API
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
    };
  }
}
