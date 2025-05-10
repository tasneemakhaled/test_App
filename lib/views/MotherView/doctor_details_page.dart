import 'package:flutter/material.dart';
import '../../models/doctorModels/AllDoctorsModel.dart';

class DoctorDetailsPage extends StatelessWidget {
  final AllDoctorsModel doctor;

  const DoctorDetailsPage({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor avatar and name
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        NetworkImage("https://via.placeholder.com/150"),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "${doctor.firstName} ${doctor.lastName}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    doctor.specialization ?? 'Psychologist',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Doctor Information Card
            Container(
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
                      Icon(Icons.person, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Doctor Information',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Divider(color: Colors.white70, thickness: 1),
                  SizedBox(height: 10),
                  _infoRow('Email:', doctor.email ?? 'Not provided'),
                  _infoRow('Phone:', doctor.phoneNumber ?? 'Not provided'),
                  _infoRow('Specialization:',
                      doctor.specialization ?? 'Not provided'),
                  _infoRow('Academic Degree:',
                      doctor.academicDegree ?? 'Not provided'),
                  _infoRow(
                      'Years of Experience:',
                      doctor.yearsOfExperience != null
                          ? doctor.yearsOfExperience.toString()
                          : 'Not provided'),
                  _infoRow('License:', doctor.doctorLicense ?? 'Not provided'),
                  _infoRow('Address:', doctor.address ?? 'Not provided'),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Subscribe button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Subscribe to doctor logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Subscribed to Dr. ${doctor.firstName} ${doctor.lastName}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: Icon(Icons.add_circle_outline, color: Colors.white),
                label: Text(
                  'Subscribe',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey.shade600,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
