import 'package:flutter/material.dart';

class DoctorInformationDisplayWidget extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String academicDegree;
  final String specialization;
  final int yearsOfExperience;
  final String phoneNumber;
  final String doctorLicense;
  final String address;
  final String dateOfBirth;
  final String certificatesSummary; // 'certificates' from your model

  const DoctorInformationDisplayWidget({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.academicDegree,
    required this.specialization,
    required this.yearsOfExperience,
    required this.phoneNumber,
    required this.doctorLicense,
    required this.address,
    required this.dateOfBirth,
    required this.certificatesSummary,
  }) : super(key: key);

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Text(
        '• $label: ${value.isEmpty ? "N/A" : value}',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildInfoRowBold(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Text(
        '• $label: ${value.isEmpty ? "N/A" : value}',
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (firstName.isEmpty &&
        lastName.isEmpty &&
        phoneNumber.isEmpty &&
        specialization.isEmpty &&
        doctorLicense.isEmpty &&
        email.isEmpty) {
      return SizedBox.shrink(); // Don't show card if no essential info
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade500,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_pin_circle, color: Colors.white, size: 28),
              SizedBox(width: 8),
              Text('Doctor Information',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22, // Adjusted size
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Divider(color: Colors.white70, thickness: 1, height: 20),
          _buildInfoRowBold('Full Name', '$firstName $lastName'.trim()),
          if (email.isNotEmpty) _buildInfoRowBold('Email', email),
          if (academicDegree.isNotEmpty)
            _buildInfoRow('Academic Degree', academicDegree),
          if (specialization.isNotEmpty)
            _buildInfoRow('Specialization', specialization),
          _buildInfoRow('Years of Experience', yearsOfExperience.toString()),
          if (phoneNumber.isNotEmpty)
            _buildInfoRow('Phone Number', phoneNumber),
          if (doctorLicense.isNotEmpty)
            _buildInfoRow('License Number', doctorLicense),
          if (address.isNotEmpty) _buildInfoRow('Address', address),
          if (dateOfBirth.isNotEmpty)
            _buildInfoRow('Date of Birth', dateOfBirth),
          if (certificatesSummary.isNotEmpty)
            _buildInfoRow('Certificates (Summary)', certificatesSummary),
        ],
      ),
    );
  }
}
