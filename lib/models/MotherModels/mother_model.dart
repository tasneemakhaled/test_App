class Mother {
  final String firstName;
  final String lastName;
  final String email;
  final String id;

  Mother({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.id,
  });

  factory Mother.fromJson(Map<String, dynamic> json) {
    return Mother(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'id': id,
    };
  }
}
