// This would be the content of your LoginModel.dart file
// Check that it includes the doctorId property in the response

class LoginModel {
  final String email;
  final String password;

  LoginModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

// The response class should include doctorId
class LoginResponse {
  final String token;
  final String role;
  final String? firstName;
  final String? lastName;
  final int? doctorId; // Make sure this is included

  LoginResponse({
    required this.token,
    required this.role,
    this.firstName,
    this.lastName,
    this.doctorId, // Important to include this
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      role: json['role'] ?? '',
      firstName: json['firstName'],
      lastName: json['lastName'],
      doctorId: json['doctorId'], // Parse the doctorId from the response
    );
  }
}
