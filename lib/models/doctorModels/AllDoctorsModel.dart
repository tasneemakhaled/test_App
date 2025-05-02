class AllDoctorsModel {
  final String firstName;
  final String lastName;
  final String email;
  final String specialization;

  AllDoctorsModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.specialization,
  });

  factory AllDoctorsModel.fromJson(Map<String, dynamic> json) {
    return AllDoctorsModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      specialization: json['specialization'],
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'firstName': firstName,
  //     'lastName': lastName,
  //     'email': email,
  //     'specialization': specialization,
  //   };
  // }
}
