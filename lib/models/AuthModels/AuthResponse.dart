class AuthResponse {
  final String token;
  final String role;
  final String? firstName;
  final String? lastName;

  AuthResponse({
    required this.token,
    required this.role,
    this.firstName,
    this.lastName,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      role: json['role'] ?? '',
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}