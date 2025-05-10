class AllDoctorsModel {
  final int id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phoneNumber;
  final String? specialization;
  final String? doctorLicense;
  final String? dateOfBirth;
  final String? address;
  final String? academicDegree;
  final int? yearsOfExperience;
  final String? certificates;
  // final String? imageUrl;

  AllDoctorsModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phoneNumber,
    this.specialization,
    this.doctorLicense,
    this.dateOfBirth,
    this.address,
    this.academicDegree,
    this.yearsOfExperience,
    this.certificates,
    // this.imageUrl,
  });

  // Factory constructor to create a Doctor object from a map
  factory AllDoctorsModel.fromJson(Map<String, dynamic> json) {
    return AllDoctorsModel(
      id: json['doctorId'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      specialization: json['specialization'],
      doctorLicense: json['doctorLicense'],
      dateOfBirth: json['dateOfBirth'],
      address: json['address'],
      academicDegree: json['academicDegree'],
      yearsOfExperience: json['yearsOfExperience'],
      certificates: json['certificates'],
      //   imageUrl: json['imageUrl'],
    );
  }

  // Method to convert a Doctor object to a map
  Map<String, dynamic> toJson() {
    return {
      'doctorId': id,
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
      // 'imageUrl': imageUrl,
    };
  }
}
