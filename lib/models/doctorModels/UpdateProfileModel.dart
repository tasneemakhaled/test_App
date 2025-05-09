class Doctor {
  final int? doctorId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String phoneNumber;
  final String specialization;
  final String doctorLicense;
  final String dateOfBirth;
  final String address;
  final String academicDegree;
  final dynamic yearsOfExperience;
  final String certificates;

  Doctor({
    this.doctorId,
    this.firstName,
    this.lastName,
    this.email,
    required this.phoneNumber,
    required this.specialization,
    required this.doctorLicense,
    required this.dateOfBirth,
    required this.address,
    required this.academicDegree,
    required this.yearsOfExperience,
    required this.certificates,
  });

  // From JSON to Object
  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      doctorId: json['doctorId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      specialization: json['specialization'],
      doctorLicense: json['doctorLicense'],
      dateOfBirth: json['dateOfBirth'],
      address: json['address'],
      academicDegree: json['academicDegree'],
      yearsOfExperience: json['yearsOfExperience'],
      certificates: json['certificates'],
    );
  }

  // From Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'doctorLicense': doctorLicense,
      'phoneNumber': phoneNumber,
      'specialization': specialization,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'academicDegree': academicDegree,
      'yearsOfExperience': yearsOfExperience is int
          ? yearsOfExperience.toString()
          : yearsOfExperience,
      'certificates': certificates,
    };
  }

  // Complete version that includes all data for display
  Map<String, dynamic> toCompleteJson() {
    return {
      'doctorId': doctorId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'specialization': specialization,
      'doctorLicense': doctorLicense,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'academicDegree': academicDegree,
      'yearsOfExperience': yearsOfExperience,
      'certificates': certificates,
    };
  }
}
