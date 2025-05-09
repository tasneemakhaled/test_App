class AuthResponse {
  final String token;
  final String role;
  final String? firstName;
  final String? lastName;
  final int? doctorId;

  AuthResponse({
    required this.token,
    required this.role,
    this.firstName,
    this.lastName,
    this.doctorId,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      role: json['role'] ?? '',
      firstName: json['firstName'],
      lastName: json['lastName'],
      doctorId: json['doctorId'] != null
          ? int.tryParse(json['doctorId'].toString())
          : null,
    );
  }
}
