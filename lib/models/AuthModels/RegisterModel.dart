class RegisterModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String role;
  final String? doctorLicense;

  RegisterModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.role,
    this.doctorLicense,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'role': role,
    };

    if (doctorLicense != null && doctorLicense!.isNotEmpty) {
      data['doctorLicense'] = doctorLicense;
    }

    return data;
  }
}